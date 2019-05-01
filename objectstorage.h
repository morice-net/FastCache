#ifndef OBJECTSTORAGE_H
#define OBJECTSTORAGE_H

#include <QObject>
#include <QVector>
#include <QVariant>

class ObjectStorage : public QObject
{
    Q_OBJECT

public:
    explicit ObjectStorage(QObject *parent = 0);

    virtual bool createObject(QString tableName, QVector<QString> columnNames, QVector<QString> columnValues) = 0;
    virtual bool createTable(QString tableName, QVector<QString> columnNames, QVector<QString> columnTypes) = 0;
    virtual QString stringFromType(QVariant::Type type) const = 0;

    bool insertObject(QObject* dataRow);
    bool createTableFromObject(QObject* dataRow);
    QString serializeValue(const QVariant &variant) const;

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
