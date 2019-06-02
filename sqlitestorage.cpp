#include "sqlitestorage.h"

#include <QCoreApplication>
#include <QMetaObject>
#include <QMetaProperty>
#include <QSqlQuery>
#include <QSqlRecord>
#include <QSqlError>
#include <QDebug>

SQLiteStorage::SQLiteStorage(QObject *parent) : ObjectStorage(parent)
{
    QString path = "./FastCacheDatabase.db";
    m_database = QSqlDatabase::addDatabase("QSQLITE");
    m_database.setDatabaseName(path);
    if (! m_database.open()) {
        qDebug() << m_database.lastError().text();

        qDebug() << QCoreApplication::libraryPaths();
        QCoreApplication::exit(-1);
    }
}

bool SQLiteStorage::readAllObjects()
{
    QSqlQuery query;
    query.exec("SELECT name FROM sqlite_master WHERE type='table'");
    if (query.lastError().type() == QSqlError::NoError) {
        qDebug() << "Request success";
    } else {
        qDebug() << "Error ? " << query.lastError().text();
        return false;
    }
    int idName = query.record().indexOf("name");
    while (query.next())
    {
        QString tablename = query.value(idName).toString();
        qDebug() << tablename;
        QSqlQuery select;
        select.exec("SELECT * FROM " + tablename);
        if (select.lastError().type() == QSqlError::NoError) {
            qDebug() << "Request success";
        } else {
            qDebug() << "Error ? " << select.lastError().text();
            return false;
        }
        while (select.next())
        {
            //TODO Create and treat all objects
        }
    }
    return true;
}

bool SQLiteStorage::readObject(QObject *dataRow, const QString &columnNameId, const QString &valueId, QString table)
{
    if (table.isEmpty()) {
        table = dataRow->objectName();
    }
    QString selectQueryText = "SELECT * FROM " + table + " WHERE " + columnNameId + "='" + valueId+"'";
    qDebug() << "Query:" << selectQueryText;
    QSqlQuery select;
    select.exec(selectQueryText);

    if (select.next()) {
        for (int i = 1; i < dataRow->metaObject()->propertyCount(); ++i) {
            auto variantList = unserializeValue(select.value(i-1).toString());
            QVariant value;
            if (variantList.size() == 1) {
                // Case of single value
                value = variantList.first();
            } else {
                // Case of lists
                const char *typeName = dataRow->metaObject()->property(i).typeName();
                if (typeName == QStringLiteral("QList<int>")) {
                    QList<int> unserializedList;
                    for (auto elem: variantList) {
                        unserializedList.append(elem.toInt());
                    }
                    value = QVariant::fromValue<QList<int>>(unserializedList);
                } else if (typeName == QStringLiteral("QList<bool>")) {
                    QList<bool> unserializedList;
                    for (auto elem: variantList) {
                        unserializedList.append(elem.toBool());
                    }
                    value = QVariant::fromValue<QList<bool>>(unserializedList);
                } else if (typeName == QStringLiteral("QList<QString>")) {
                    QList<QString> unserializedList;
                    for (auto elem: variantList) {
                        unserializedList.append(elem.toString());
                    }
                    value = QVariant::fromValue<QList<QString>>(unserializedList);
                } else if (typeName == QStringLiteral("QList<double>")) {
                    QList<double> unserializedList;
                    for (auto elem: variantList) {
                        unserializedList.append(elem.toDouble());
                    }
                    value = QVariant::fromValue<QList<double>>(unserializedList);
                }
            }
            dataRow->metaObject()->property(i).write(dataRow, value);

            std::string signalName( std::string(dataRow->metaObject()->property(i).name()) + "Changed");
            QMetaObject::invokeMethod(dataRow, signalName.c_str());
        }
        return true;
    }
    return false;
}

bool SQLiteStorage::createObject(const QString &tableName, const QVector<QString> &columnNames, const QVector<QString> &columnValues)
{
    QString queryCommand;
    queryCommand += "REPLACE INTO " + tableName + " ( ";
    for(int i = 0; i < columnNames.size(); i++) {
        queryCommand += columnNames[i];
        if (i == (columnNames.size() - 1))
            queryCommand += " ) ";
        else
            queryCommand += ", ";
    }
    queryCommand += "VALUES (";
    for(int i = 0; i < columnValues.size(); i++) {
        queryCommand += "'" + QString(columnValues[i]).replace('\"', '"').replace("'","''") + "'";
        if (i == (columnValues.size() - 1))
            queryCommand += " );";
        else
            queryCommand += ", ";
    }

    QSqlQuery query;
    query.exec(queryCommand);
    qDebug() << "Query command: " << queryCommand;
    if (query.lastError().type() == QSqlError::NoError) {
        qDebug() << "Request success";
    } else {
        qDebug() << "Error ? " << query.lastError().text();
    }

    return true;
}

bool SQLiteStorage::createTable(const QString &tableName, const QVector<QString> &columnNames, const QVector<QString> &columnTypes, const QString& primaryKey)
{
    QString queryCommand;
    queryCommand += "CREATE TABLE IF NOT EXISTS " + tableName + " ( ";
    for(int i = 0; i < columnNames.size(); i++) {
        queryCommand += columnNames[i] + " " + columnTypes[i] + ((columnNames[i] == primaryKey) ? " primary key " : "");
        if (i == (columnNames.size() - 1))
            queryCommand += " );";
        else
            queryCommand += ", ";
    }

    QSqlQuery query;
    return query.exec(queryCommand);
}

QString SQLiteStorage::stringFromType(const QVariant::Type &type) const
{
    if (type == QVariant::Int)
        return "INTEGER";
    else if (type == QVariant::String)
        return "TEXT";
    else
        return "TEXT";
}
