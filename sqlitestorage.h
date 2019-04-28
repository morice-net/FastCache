#ifndef SQLITESTORAGE_H
#define SQLITESTORAGE_H

#include "objectstorage.h"

#include <QSqlDatabase>

class SQLiteStorage : public ObjectStorage
{
    Q_OBJECT
public:
    explicit SQLiteStorage(QObject * parent = 0);

    bool readObject(QObject *object, QString tableName, QString columnNameId, QString valueId);
    bool createObject(QString tableName, QVector<QString> columnNames, QVector<QString> columnValues);
    bool createTable(QString tableName, QVector<QString> columnNames, QVector<QString> columnTypes);
    QString stringFromType(QVariant::Type type) const;


private:
    QSqlDatabase m_database;

};

#endif // SQLITESTORAGE_H