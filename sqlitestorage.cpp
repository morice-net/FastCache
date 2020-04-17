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

bool SQLiteStorage::isCacheInTable(const QString &tableName , const QString &id)
{
    QString selectQueryText = "SELECT json FROM " + tableName + " WHERE " + "id='" + id + "'";
    qDebug() << "Query:" << selectQueryText;
    QSqlQuery select;
    select.exec(selectQueryText);

    if (select.next()) {
        return true;
    }
    return false;
}

QList<int> SQLiteStorage::cacheInLists(const QString &tableName , const QString &geocode)
{
    QString selectQueryText = "SELECT id FROM " + tableName + " WHERE " + "text='" + geocode + "'";
    qDebug() << "Query:" << selectQueryText;
    QSqlQuery select;

    if(!select.exec(selectQueryText))
    {
        qDebug() << "Error ? " << select.lastError().text();
        return  QList<int>();
    }
    qDebug() << "Request success";
    QList<int> list = QList<int>();
    while(select.next()) {
        list.append(select.value(0).toInt());
    }
    qDebug() << "List ? " << list;
    return list;
}

QList<QString> SQLiteStorage::readAllIdsFromTable(const QString &tableName)
{
    QString selectQueryText = "SELECT id FROM " + tableName ;
    qDebug() << "Query:" << selectQueryText;
    QSqlQuery select;

    if(!select.exec(selectQueryText))
    {
        qDebug() << "Error ? " << select.lastError().text();
        return  QList<QString>();
    }
    qDebug() << "Request success";
    QList<QString> list = QList<QString>();
    while(select.next()) {
        list.append(select.value(0).toString());
    }
    return list;
}

QList<QString> SQLiteStorage::readAllStringsFromTable(const QString &tableName)
{
    QString selectQueryText = "SELECT text FROM " + tableName ;
    qDebug() << "Query:" << selectQueryText;
    QSqlQuery select;

    if(!select.exec(selectQueryText))
    {
        qDebug() << "Error ? " << select.lastError().text();
        return  QList<QString>();
    }

    qDebug() << "Request success";
    QList<QString> list = QList<QString>();
    while(select.next()) {
        list.append(select.value(0).toString());
    }
    return list;
}

QJsonDocument SQLiteStorage::readObject(const QString &tableName, const QString &id)
{
    QString selectQueryText = "SELECT json FROM " + tableName + " WHERE " + "id='" + id + "'";
    qDebug() << "Query:" << selectQueryText;
    QSqlQuery select;

    if(!select.exec(selectQueryText))
    {
        qDebug() << "Error ? " << select.lastError().text();
        return  QJsonDocument();
    }

    qDebug() << "Request success";
    QJsonDocument json = QJsonDocument();
    if (select.next()) {
        QString jsonString = select.value(0).toString();
        QByteArray jsonByteArray = jsonString.toUtf8();
        QJsonDocument json = QJsonDocument::fromJson(jsonByteArray);
        return json;
    }
    return json;
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

bool SQLiteStorage::updateString(const QString &tableName, const int &id,  const QString &text)
{
    QString queryCommand;
    QString::number(id);
    queryCommand += "REPLACE INTO " + tableName + " (id, text) VALUES ('" + QString::number(id) + "', '" + text + "')";

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

void SQLiteStorage::deleteObject(const QString &tableName, const QString &id)
{
    QString queryCommand;
    queryCommand += "DELETE FROM " + tableName + " WHERE " + "id='" + id + "'";

    QSqlQuery query;
    query.exec(queryCommand);
    qDebug() << "Query command: " << queryCommand;
    if (query.lastError().type() == QSqlError::NoError) {
        qDebug() << "Request success";
    } else {
        qDebug() << "Error ? " << query.lastError().text();
    }
}

void SQLiteStorage::deleteString(const QString &tableName, const QString &text)
{
    QString queryCommand;
    queryCommand += "DELETE FROM " + tableName + " WHERE " + "text='" + text + "'";

    QSqlQuery query;
    query.exec(queryCommand);
    qDebug() << "Query command: " << queryCommand;
    if (query.lastError().type() == QSqlError::NoError) {
        qDebug() << "Request success";
    } else {
        qDebug() << "Error ? " << query.lastError().text();
    }
}

int SQLiteStorage::count(const QString &tableName)
{
    QString queryCommand;
    queryCommand += "SELECT COUNT(*) FROM" + tableName;

    QSqlQuery query;
    if(!query.exec(queryCommand))
    {
        qDebug() << "Error ? " << query.lastError().text();
        return 0 ;
    }
    int nbr = 0;
    if(query.next() == true)
    {
        nbr = query.value(0).toInt();
        qDebug() << "Nombre d'elements dans la table : " << QString::number(nbr);
        return nbr;
    }
    else
    {
        qDebug() << "On n'a pas reussi a compter le nombre d'éléments dans la table!!";
        return 0;
    }
}

bool SQLiteStorage::createTable(const QString &tableName, const QString &columns)
{
    QString queryCommand;
    queryCommand += "CREATE TABLE IF NOT EXISTS " + tableName + columns;
    qDebug() << "Query command: " << queryCommand;
    QSqlQuery query;

    if(!query.exec(queryCommand))
    {
        qDebug() << "Error ? " << query.lastError().text();
        return false ;
    }
    qDebug() << "Request success";
    return true;
}





