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

bool SQLiteStorage::readObject(QObject *dataRow, QString tableName, QString columnNameId, QString valueId)
{
    QSqlQuery query;
    query.exec("SELECT name FROM sqlite_master WHERE type='table'");
    int idName = query.record().indexOf("name");
    while (query.next())
    {
       QString tablename = query.value(idName).toString();
       qDebug() << tablename;
       QSqlQuery select;
       select.exec("SELECT * FROM " + tablename + " WHERE " + columnNameId + "=" + valueId);
       while (select.next())
       {
           if (tablename.toLower() == tableName.toLower()) {
               for (int i = 1; i < dataRow->metaObject()->propertyCount(); ++i) {
                   dataRow->metaObject()->property(i).write(dataRow, select.value(i));
               }
               return true;
               // CREATE CACHE emit loadAccount(select.value(0).toString(),select.value(1).toString(),select.value(2).toString(),select.value(3).toInt(),select.value(4).toInt(),select.value(5).toInt());
           }
       }
    }
    return false;
}

bool SQLiteStorage::createObject(QString tableName, QVector<QString> columnNames, QVector<QString> columnValues)
{
    QString queryCommand;
    queryCommand += "INSERT INTO " + tableName + " ( ";
    for(int i = 0; i < columnNames.size(); i++) {
        queryCommand += columnNames[i];
        if (i == (columnNames.size() - 1))
            queryCommand += " ) ";
        else
            queryCommand += ", ";
    }
    queryCommand += "VALUES (";
    for(int i = 0; i < columnValues.size(); i++) {
        queryCommand += "\"" + columnValues[i] + "\"";
        if (i == (columnValues.size() - 1))
            queryCommand += " );";
        else
            queryCommand += ", ";
    }

    QSqlQuery query;
    query.exec(queryCommand);
    qDebug() << queryCommand;
    qDebug() << query.lastError().text();
    return true;
}

bool SQLiteStorage::createTable(QString tableName, QVector<QString> columnNames, QVector<QString> columnTypes)
{
    QString queryCommand;
    queryCommand += "CREATE TABLE IF NOT EXISTS " + tableName + " ( ";
    for(int i = 0; i < columnNames.size(); i++) {
        queryCommand += columnNames[i] + " " + columnTypes[i];
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
