#ifndef SQLITESTORAGE_H
#define SQLITESTORAGE_H

#include <QObject>
#include <QSqlDatabase>
#include <QJsonDocument>

class SQLiteStorage: public QObject
{
    Q_OBJECT
public:
    explicit SQLiteStorage(QObject * parent = nullptr);
    virtual ~SQLiteStorage();

    bool isCacheInTable(const QString &tableName , const QString &id);
    bool readAllObjectsFromTable(const QString &tableName);
    bool updateObject(const QString &tableName, const QString &id, QJsonDocument &json);
    void deleteObject(const QString &tableName, const QString &id);
    bool createTableCaches(const QString &tableName);
    bool createTableLists(const QString &tableName);
    bool createTableCachesLists(const QString &tableName);



    Q_INVOKABLE   QJsonDocument readObject(const QString &tableName, const QString &id);
    Q_INVOKABLE  QList<QString> readAllIdsFromTable(const QString &tableName);

private:
    QSqlDatabase m_database;
};

#endif // SQLITESTORAGE_H
