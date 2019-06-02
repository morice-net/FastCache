#ifndef SQLITESTORAGE_H
#define SQLITESTORAGE_H

#include "objectstorage.h"

#include <QSqlDatabase>

class SQLiteStorage : public ObjectStorage
{
    Q_OBJECT
public:
    explicit SQLiteStorage(QObject * parent = nullptr);

    bool readAllObjects();
    bool readObject(QObject *object, const QString &columnNameId, const QString &valueId, QString table = "");
    bool createObject(const QString &tableName, const QVector<QString> &columnNames, const QVector<QString> &columnValues) override;
    bool createTable(const QString &tableName, const QVector<QString> &columnNames, const QVector<QString> &columnTypes, const QString &primaryKey) override;
    QString stringFromType(const QVariant::Type &type) const override;

private:
    QSqlDatabase m_database;

    void extractList();
};

#endif // SQLITESTORAGE_H
