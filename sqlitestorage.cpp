#include "sqlitestorage.h"

#include <QCoreApplication>
#include <QSqlQuery>
#include <QSqlRecord>
#include <QSqlError>
#include <QDebug>

SQLiteStorage::SQLiteStorage(QObject *parent) : QObject(parent)
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

SQLiteStorage::~SQLiteStorage()
{
}

bool SQLiteStorage::readAllObjectsFromTable(const QString &tableName)
{
    Q_UNUSED(tableName)
    return true;
}

bool SQLiteStorage::readObject(const QString &tableName, const QString &id, QJsonDocument &json)
{
    QString selectQueryText = "SELECT json FROM " + tableName + " WHERE " + "id='" + id + "'";
    qDebug() << "Query:" << selectQueryText;
    QSqlQuery select;
    select.exec(selectQueryText);

    if (select.next()) {
        json = QJsonDocument::fromVariant(select.value(0));
        return true;
    }
    return false;
}

bool SQLiteStorage::updateObject(const QString &tableName, const QString &id, QJsonDocument &json)
{
    QString queryCommand;
    QString stringJson(json.toJson(QJsonDocument::Compact));
    queryCommand += "REPLACE INTO " + tableName + " (id, json) VALUES ('" + id + "', '" + stringJson.replace('\"', '"').replace("'","''") + "')";

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

bool SQLiteStorage::createTable(const QString &tableName)
{
    QString queryCommand;
    queryCommand += "CREATE TABLE IF NOT EXISTS " + tableName + " (id string primary key, json string)";

    QSqlQuery query;
    return query.exec(queryCommand);
}

