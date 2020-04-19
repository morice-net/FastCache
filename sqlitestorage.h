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

    bool isCacheInTable(const QString &tableName, const QString &id);
    void deleteObject(const QString &tableName, const QString &id);

    Q_INVOKABLE   QJsonDocument readObject(const QString &tableName, const QString &id);
    Q_INVOKABLE  QList<QString> readAllIdsFromTable(const QString &tableName);
    Q_INVOKABLE  QList<int> readAllIdsFromLists(const QString &tableName);
    Q_INVOKABLE   int count(const QString &tableName);
    Q_INVOKABLE   QList<QString> readAllStringsFromTable(const QString &tableName);
    Q_INVOKABLE   QList<int> cacheInLists(const QString &tableName, const QString &string);
    Q_INVOKABLE   void deleteString(const QString &tableName, const int &id , const QString &text);
    Q_INVOKABLE bool updateString(const QString &tableName, const int &id, const QString &string);
    Q_INVOKABLE bool updateObject(const QString &tableName, const QString &id, QJsonDocument &json);
    Q_INVOKABLE bool createTable(const QString &tableName, const QString &columns);

private:
    QSqlDatabase m_database;
};

#endif // SQLITESTORAGE_H
