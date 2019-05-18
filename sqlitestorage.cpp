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

bool SQLiteStorage::readObject(QObject *dataRow, QString columnNameId, QString valueId)
{
    QString selectQueryText = "SELECT * FROM " + dataRow->objectName()  + " WHERE " + columnNameId + "='" + valueId+"'";
    qDebug() << "Query:" << selectQueryText;
    QSqlQuery select;
    select.exec(selectQueryText);

    if (select.next()) {
        for (int i = 1; i < dataRow->metaObject()->propertyCount(); ++i) {
            qDebug() << "===================>" << select.value(i-1).toString() << dataRow->metaObject()->property(i).name();
            dataRow->metaObject()->property(i).write(dataRow, select.value(i-1));

            std::string signalName( std::string(dataRow->metaObject()->property(i).name()) + "Changed");
            QMetaObject::invokeMethod(dataRow, signalName.c_str());
        }
        return true;
    }
    return false;
}

bool SQLiteStorage::createObject(QString tableName, QVector<QString> columnNames, QVector<QString> columnValues)
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
        queryCommand += "'" + columnValues[i].replace('\"', '"').replace("'","''") + "'";
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

bool SQLiteStorage::createTable(QString tableName, QVector<QString> columnNames, QVector<QString> columnTypes, const QString& primaryKey)
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

QString SQLiteStorage::stringFromType(QVariant::Type type) const
{
    if (type == QVariant::Int)
        return "INTEGER";
    else if (type == QVariant::String)
        return "TEXT";
    else
        return "TEXT";
}
