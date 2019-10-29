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
    bool readObject(const QString &tableName, const QString &id, QJsonDocument &json);
    bool updateObject(const QString &tableName, const QString &id, QJsonDocument &json);
    void deleteObject(const QString &tableName, const QString &id);
    bool createTable(const QString &tableName);

private:
    QSqlDatabase m_database;
};

#endif // SQLITESTORAGE_H
