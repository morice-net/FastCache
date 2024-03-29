#include "sqlitestorage.h"

#include <QCoreApplication>
#include <QSqlQuery>
#include <QSqlRecord>
#include <QSqlError>
#include <QDebug>

SQLiteStorage::SQLiteStorage(QObject *parent) : QObject(parent)
{
    m_listWithGeocode = QList<bool>();
    m_listsIds = QList<int>();
    m_countLists = 0 ;
    m_countCachesInLists = QList<int>();

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

// cache in tables

bool SQLiteStorage::isCacheInTable(const QString &tableName , const QString &id)
{
    QString selectQueryText = "SELECT id FROM " + tableName + " WHERE " + "id='" + id + "'";
    qDebug() << "Query:" << selectQueryText;
    QSqlQuery select;
    select.exec(selectQueryText);

    if (select.next()) {
        return true;
    }
    return false;
}

QList<bool> SQLiteStorage::cacheInLists(const QString &tableName , const QString &code)
{
    QString selectQueryText = "SELECT list FROM " + tableName + " WHERE " + "code='" + code + "'" + " ORDER BY list";
    qDebug() << "Query:" << selectQueryText;
    QSqlQuery select;

    if(!select.exec(selectQueryText))
    {
        qDebug() << "Error ? " << select.lastError().text();
        return QList<bool>();
    }
    qDebug() << "Request success";
    QList<int> list = QList<int>();
    QList<bool> listBool = QList<bool>();

    while(select.next()) {
        list.append(select.value(0).toInt());
    }

    foreach ( const int & a, m_listsIds)
    {
        if(list.indexOf(a) == -1){
            listBool.append(false);
        } else {
            listBool.append(true);
        }
    }
    qDebug() << " cache in lists " << listBool;
    setListWithGeocode(listBool);
    return listBool;
}

QList<int> SQLiteStorage::numberCachesInLists(const QString &tableName)
{
    QString selectQueryText = "SELECT list , COUNT(list) FROM " + tableName + " GROUP BY list ORDER BY list";
    qDebug() << "Query:" << selectQueryText;
    QSqlQuery select;

    if(!select.exec(selectQueryText))
    {
        qDebug() << "Error ? " << select.lastError().text();
        return QList<int>();
    }
    qDebug() << "Request success";
    QList<int> list = QList<int>();
    QList<int> listCount = QList<int>();
    QList<int> listResult = QList<int>();

    while(select.next()) {
        list.append(select.value(0).toInt());
        listCount.append(select.value(1).toInt());
    }

    int j = 0;
    for ( int i = 0; i < m_listsIds.length();i++)
    {
        if(list.indexOf(m_listsIds[i]) == -1){
            listResult.append(0);
        } else {
            listResult.append(listCount[j]);
            j = j+1;
        }
    }
    qDebug() << " Number of caches in lists " << listResult;
    setCountCachesInLists(listResult);
    return listResult;
}

// read in tables
QList<int> SQLiteStorage::readAllIdsFromLists(const QString &tableName)
{
    QString selectQueryText = "SELECT id FROM " + tableName + " ORDER BY id" ;
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
    qDebug() << "ids from lists " << list;
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
    qDebug() << "List: "<< list;
    return list;
}

QJsonDocument SQLiteStorage::readColumnJson(const QString &tableName, const QString &id)
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

QJsonDocument SQLiteStorage::readColumnUserlogs(const QString &tableName, const QString &id)
{
    QString selectQueryText = "SELECT userlogs FROM " + tableName + " WHERE " + "id='" + id + "'";
    qDebug() << "Query:" << selectQueryText;
    QSqlQuery select;

    if(!select.exec(selectQueryText))
    {
        qDebug() << "Error ? " << select.lastError().text();
        return  QJsonDocument();
    }

    qDebug() << "Request success";
    QJsonDocument userlogs = QJsonDocument();
    if (select.next()) {
        QString userlogsString = select.value(0).toString();
        QByteArray userlogsByteArray = userlogsString.toUtf8();
        QJsonDocument userlogs = QJsonDocument::fromJson(userlogsByteArray);
        return userlogs;
    }
    return userlogs;
}


// update in tables

bool SQLiteStorage::updateFullCacheColumns(const QString &tableName, const QString &geocode, const QString &name, const QString &type,
                                           const QString &size, const double &difficulty, const double &terrain , const double &lat,
                                           const double &lon, const bool &found, const bool &own, const QJsonDocument &json, const QJsonDocument &userlogs)
{
    QString nameAlias = name;
    QString queryCommand;
    QString stringJson(json.toJson(QJsonDocument::Compact));
    QString stringUserlogs(userlogs.toJson(QJsonDocument::Compact));
    queryCommand += "REPLACE INTO " + tableName + " (id , name, type, size, difficulty, terrain, lat, lon, found, own, json, userlogs) VALUES ('" + geocode
                    + "' , '"  + nameAlias.replace('\"', '"').replace("'","''")
                    + "' , '"  + type
                    + "' , '"  + size
                    + "' , '"  + QString::number(difficulty)
                    + "' , '"  + QString::number(terrain )
                    + "' , '"  + QString::number(lat)
                    + "' , '"  + QString::number(lon)
                    + "' , '"  + QString::number(found ? 1 : 0)
                    + "' , '"  + QString::number(own ? 1 : 0)
                    + "' , '"  + stringJson.replace('\"', '"').replace("'","''")
                    + "' , '"  + stringUserlogs.replace('\"', '"').replace("'","''")
                    + "')";
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

bool SQLiteStorage::updateFullCacheColumnsFoundJson(const QString &tableName, const QString &id, const bool &found, const QJsonDocument &json)
{
    QString queryCommand;
    QString stringJson(json.toJson(QJsonDocument::Compact));
    queryCommand += "UPDATE " + tableName
                    + " SET found = '" + QString::number(found ? 1 : 0) + "' , "
                    + " json = '" + stringJson.replace('\"', '"').replace("'","''") + "'"
                    + " WHERE " + "id='" + id + "'";
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

bool SQLiteStorage::updateFullCacheColumnUserlogs(const QString &tableName, const QString &id, const QJsonDocument &userlogs)
{
    QString queryCommand;
    QString stringUserlogs(userlogs.toJson(QJsonDocument::Compact));
    queryCommand += "UPDATE " + tableName
                    + " SET userlogs = '" + stringUserlogs.replace('\"', '"').replace("'","''") + "'"
                    + " WHERE " + "id='" + id + "'";
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

bool SQLiteStorage::updateFullCacheColumnJson(const QString &tableName, const QString &id, const QJsonDocument &json)
{
    QString queryCommand;
    QString stringJson(json.toJson(QJsonDocument::Compact));
    queryCommand += "UPDATE " + tableName
                    + " SET json = '" + stringJson.replace('\"', '"').replace("'","''") + "'"
                    + " WHERE " + "id='" + id + "'";
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

bool SQLiteStorage::updateObject(const QString &tableName, const QString &id, const QJsonDocument &json)
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

bool SQLiteStorage::updateLists(const QString &tableName, const int &id,  const QString &text)
{
    QString queryCommand;
    // Auto increment
    if(id == -1){
        queryCommand += " REPLACE INTO " + tableName + " (id, text) VALUES (" + " NULL , '" + text + "')";
    } else{
        queryCommand += " REPLACE INTO " + tableName + " (id, text) VALUES ('" + QString::number(id) + "', '" + text + "')";
    }

    QSqlQuery query;
    query.exec(queryCommand);
    qDebug() << "Query command: " << queryCommand;
    if (query.lastError().type() == QSqlError::NoError) {
        qDebug() << "Request success";
        setListsIds( readAllIdsFromLists("lists"));
        setCountLists(m_listsIds.length());
    } else {
        qDebug() << "Error ? " << query.lastError().text();
        return  false;
    }
    return true;
}

bool SQLiteStorage::updateCacheInLists(const QString &tableName, const int &list, const QString &code)
{
    QString queryCommand;
    queryCommand += " INSERT OR IGNORE INTO " + tableName + " (id, list, code) VALUES (" + " NULL , '" + QString::number(list) + "', '" + code + "') ";

    QSqlQuery query;
    query.exec(queryCommand);
    qDebug() << "Query command: " << queryCommand;
    if (query.lastError().type() == QSqlError::NoError) {
        qDebug() << "Request success";
    } else {
        qDebug() << "Error ? " << query.lastError().text();
        return  false;
    }
    return true;
}

void SQLiteStorage::updateListWithGeocode(const QString &tableName , const QList<bool> &list , const QString &code , const bool &deleteIfTrue)
{
    for(int index=0 ; index<list.length() ; index++)
    {
        if(list[index] == true) {
            updateCacheInLists(tableName, m_listsIds[index] , code);
        } else {
            if(deleteIfTrue)
                deleteCacheInList(tableName , m_listsIds[index] , code);
        }
    }
    setListWithGeocode(list);
}


void SQLiteStorage::updateFullCachesTable(const QString &tableNameLists , const QString &tableNameFullCache )
{
    QString selectQueryText = "SELECT code FROM " + tableNameLists + " GROUP BY code ORDER BY code";
    qDebug() << "Query:" << selectQueryText;
    QSqlQuery select;

    if(!select.exec(selectQueryText))
    {
        qDebug() << "Error ? " << select.lastError().text();
        return ;
    }
    qDebug() << "Request success";
    QList<QString> listCodes = QList<QString>();

    while(select.next()) {
        listCodes.append(select.value(0).toString());
    }
    qDebug() << "list Codes:  "<<listCodes;

    selectQueryText = "SELECT id FROM " + tableNameFullCache + " ORDER BY id ";
    qDebug() << "Query:" << selectQueryText;

    if(!select.exec(selectQueryText))
    {
        qDebug() << "Error ? " << select.lastError().text();
        return ;
    }
    qDebug() << "Request success";

    while(select.next()) {
        QString codeFullCache = select.value(0).toString();
        // eventually delete element of table "fullcache"
        if(listCodes.indexOf(codeFullCache) == -1){
            deleteObject("fullcache", codeFullCache);
            // delete dir of recorded cache images
            m_replaceImageInText->removeDir(codeFullCache);
        }
    }
}

// delete in tables

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

void SQLiteStorage::deleteList(const QString &tableName, const QString &id)
{
    QString queryCommand;
    queryCommand += "DELETE FROM " + tableName + " WHERE " + "id='" + id + "'";

    QSqlQuery query;
    query.exec(queryCommand);
    qDebug() << "Query command: " << queryCommand;
    if (query.lastError().type() == QSqlError::NoError) {
        qDebug() << "Request success";
        setListsIds( readAllIdsFromLists("lists"));
        setCountLists(m_listsIds.length());
    } else {
        qDebug() << "Error ? " << query.lastError().text();
    }
}

void SQLiteStorage::deleteCacheInList(const QString &tableName , const int &list , const QString &code)
{
    QString queryCommand;
    queryCommand += "DELETE FROM " + tableName + " WHERE code='" + code + "'" + " AND list='" + QString::number(list) + "'"  ;

    QSqlQuery query;
    query.exec(queryCommand);
    qDebug() << "Query command: " << queryCommand;
    if (query.lastError().type() == QSqlError::NoError) {
        qDebug() << "Request success";
    } else {
        qDebug() << "Error ? " << query.lastError().text();
    }
}

void SQLiteStorage::deleteCachesInList(const QString &tableName , const int &list)
{
    QString queryCommand;
    queryCommand += "DELETE FROM " + tableName + " WHERE list='" + QString::number(list) + "'"  ;

    QSqlQuery query;
    query.exec(queryCommand);
    qDebug() << "Query command: " << queryCommand;
    if (query.lastError().type() == QSqlError::NoError) {
        qDebug() << "Request success";
    } else {
        qDebug() << "Error ? " << query.lastError().text();
    }
}

// count

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

//create tables

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

void SQLiteStorage::updateReplaceImageInText(ReplaceImageInText *replace)
{
    m_replaceImageInText = replace;
}

/** Getters & Setters **/

QList<bool> SQLiteStorage::listWithGeocode() const
{
    return m_listWithGeocode;
}

void SQLiteStorage::setListWithGeocode(const QList<bool> &list)
{
    m_listWithGeocode = list;
    emit listWithGeocodeChanged();
}

QList<int> SQLiteStorage::listsIds() const
{
    return m_listsIds;
}

void SQLiteStorage::setListsIds(const QList<int> &list)
{
    m_listsIds = list;
    emit listsIdsChanged();
}

int SQLiteStorage::countLists() const
{
    return m_countLists;
}

void SQLiteStorage::setCountLists(const int &count)
{
    m_countLists = count;
    emit countListsChanged();
}

QList<int> SQLiteStorage::countCachesInLists() const
{
    return m_countCachesInLists;
}

void SQLiteStorage::setCountCachesInLists(const QList<int> &count)
{
    m_countCachesInLists = count;
    emit countCachesInListsChanged();
}






