#ifndef SQLITESTORAGE_H
#define SQLITESTORAGE_H

#include <QObject>
#include <QSqlDatabase>
#include <QJsonDocument>
#include "replaceimageintext.h"

class SQLiteStorage: public QObject
{
    Q_OBJECT

    Q_PROPERTY(QList<bool> listWithGeocode READ listWithGeocode WRITE setListWithGeocode NOTIFY listWithGeocodeChanged)
    Q_PROPERTY(QList<int> listsIds READ listsIds WRITE setListsIds NOTIFY listsIdsChanged)
    Q_PROPERTY(int countLists READ countLists WRITE setCountLists NOTIFY countListsChanged)
    Q_PROPERTY(QList<int> countCachesInLists READ countCachesInLists WRITE setCountCachesInLists NOTIFY countCachesInListsChanged)

public:
    explicit SQLiteStorage(QObject * parent = nullptr);
    virtual ~SQLiteStorage();

    bool updateCacheInLists(const QString &tableName, const int &list, const QString &code);
    QList<int> readAllIdsFromLists(const QString &tableName);
    int count(const QString &tableName);
    bool updateFullCacheColumns(const QString &tableName, const QString &geocode, const QString &name, const QString &type, const QString &size,
                                const double &difficulty, const double &terrain , const double &lat, const double &lon, const bool &found,
                                const bool &own, const QJsonDocument &json , const QJsonDocument &userlogs);
    bool updateFullCacheColumnUserlogs(const QString &tableName, const QString &id, const QJsonDocument &userlogs);
    bool updateFullCacheColumnJson(const QString &tableName, const QString &id, const QJsonDocument &json);
    Q_INVOKABLE void deleteCacheInList(const QString &tableName , const int &list , const QString &code);
    Q_INVOKABLE bool isCacheInTable(const QString &tableName, const QString &id);
    Q_INVOKABLE void deleteObject(const QString &tableName, const QString &id);
    Q_INVOKABLE bool updateObject(const QString &tableName, const QString &id, const QJsonDocument &json);
    Q_INVOKABLE bool updateFullCacheColumnsFoundJson(const QString &tableName, const QString &id, const bool &found, const QJsonDocument &json);
    Q_INVOKABLE QJsonDocument readColumnJson(const QString &tableName, const QString &id);
    Q_INVOKABLE QJsonDocument readColumnUserlogs(const QString &tableName, const QString &id);
    Q_INVOKABLE QList<QString> readAllStringsFromTable(const QString &tableName);
    Q_INVOKABLE bool updateLists(const QString &tableName, const int &id, const QString &string);
    Q_INVOKABLE bool createTable(const QString &tableName, const QString &columns);
    Q_INVOKABLE QList<bool> cacheInLists(const QString &tableName, const QString &code);
    Q_INVOKABLE void updateListWithGeocode(const QString &tableName , const QList<bool> &list , const QString &code , const bool &deleteIfTrue);
    Q_INVOKABLE QList<int> numberCachesInLists(const QString &tableName);
    Q_INVOKABLE void deleteCachesInList(const QString &tableName , const int &list);
    Q_INVOKABLE void deleteList(const QString &tableName, const QString &id);
    Q_INVOKABLE void updateFullCachesTable(const QString &tableNameLists , const QString &tableNameFullCache);
    Q_INVOKABLE void updateReplaceImageInText(ReplaceImageInText *replace);

    QList<bool> listWithGeocode() const;
    void setListWithGeocode(const QList<bool> &list);

    QList<int> listsIds() const;
    void setListsIds(const QList<int> &list);

    int countLists() const;
    void setCountLists(const int &count);

    QList<int> countCachesInLists() const;
    void setCountCachesInLists(const QList<int> &count);

signals:
    void listWithGeocodeChanged();
    void listsIdsChanged();
    void countListsChanged();
    void countCachesInListsChanged();

private:
    QSqlDatabase m_database;
    QList<bool> m_listWithGeocode;
    QList<int> m_listsIds;
    int m_countLists;
    QList<int> m_countCachesInLists;
    ReplaceImageInText* m_replaceImageInText;
};

#endif // SQLITESTORAGE_H
