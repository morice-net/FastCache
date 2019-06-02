#ifndef OBJECTSTORAGE_H
#define OBJECTSTORAGE_H

#include <QObject>
#include <QVector>
#include <QVariant>

const QString DELIMITER("|#|");

class ObjectStorage : public QObject
{
    Q_OBJECT

public:
    explicit ObjectStorage(QObject *parent = 0);

    virtual bool createObject(const QString &tableName, const QVector<QString> &columnNames, const QVector<QString> &columnValues) = 0;
    virtual bool createTable(const QString &tableName, const QVector<QString> &columnNames, const QVector<QString> &columnTypes, const QString &primaryKey) = 0;
    virtual QString stringFromType(const QVariant::Type &type) const = 0;

    bool insertObject(QObject* dataRow, const QString &primaryKey, QString table = "");
    bool createTableFromObject(QObject* dataRow, const QString &primaryKey);
    QString serializeValue(const QVariant &variant) const;
    QVariantList unserializeValue(const QString &text) const;

    QVector<QObject *> dataTableObjects(const QString& tableName) const;
    QVector<QObject *> dataObjects() const;
    QVector<QString> tableNames() const;

protected:
    /**
     * List of tables
     * Table name is the object name of the QObject
     * Columns are Q_PROPERTIES
     * Rows are children objects (one object is one row)
     */
    QVector<QObject*> m_dataObjects;
    QVector<QString> m_tableNames;

};

#endif // OBJECTSTORAGE_H
