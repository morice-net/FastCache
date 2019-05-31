#include "objectstorage.h"
#include "objectstorage.h"

#include <QMetaObject>
#include <QMetaProperty>
#include <QVariant>
#include <QJsonDocument>
#include <QJsonArray>
#include <QDebug>

ObjectStorage::ObjectStorage(QObject *parent) :
    QObject(parent)
{
}

bool ObjectStorage::insertObject(QObject* dataRow, const QString &primaryKey)
{
    if (!m_tableNames.contains(dataRow->objectName())) {
        createTableFromObject(dataRow, primaryKey);
    }

    QVector<QString> columnNames;
    QVector<QString> columnValues;
    for (int i = 1; i < dataRow->metaObject()->propertyCount(); ++i) {
        QMetaProperty property = dataRow->metaObject()->property(i);
        columnNames << property.name();
        qDebug() << property.typeName();
        if (property.typeName() == QStringLiteral("QJsonArray")) {
            QJsonDocument doc(property.read(dataRow).toJsonArray());
            qDebug() << "JSON:" << doc.toJson();
            columnValues << serializeValue(QVariant(doc.toJson()));
        } else {
            columnValues << serializeValue(property.read(dataRow));
        }
    }
    // Create and add in the list the storage created objects
    if (createObject(dataRow->objectName(),columnNames,columnValues)) {
        m_dataObjects << dataRow;
        return true;
    }
    return false;
}

QVector<QObject *> ObjectStorage::dataTableObjects(const QString& tableName) const
{
    QVector<QObject*> tableObjects;
    for (QObject* object: m_dataObjects) {
        if (object->objectName() == tableName) {
            tableObjects << object;
        }
    }
    return tableObjects;
}

QVector<QObject *> ObjectStorage::dataObjects() const
{
    return m_dataObjects;
}

QVector<QString> ObjectStorage::tableNames() const
{
    return m_tableNames;
}

bool ObjectStorage::createTableFromObject(QObject *dataRow, const QString &primaryKey)
{
    QString name = dataRow->objectName();
    QVector<QString> columnNames;
    QVector<QString> columnTypes;
    qDebug() << "Table" << name;
    for (int i = 1; i < dataRow->metaObject()->propertyCount(); ++i) {
        columnNames << dataRow->metaObject()->property(i).name();
        columnTypes << stringFromType(dataRow->metaObject()->property(i).type());
        qDebug() << "\tRow" << dataRow->metaObject()->property(i).name() << dataRow->metaObject()->property(i).type();
    }
    if (createTable(name, columnNames, columnTypes, primaryKey)) {
        m_tableNames << name;
        return true;
    }
    return false;
}

QString ObjectStorage::serializeValue(const QVariant &variant) const
{
    QString value(variant.toString());
    if (value.isEmpty()) {
        QString serializedValue;

        // in this case we need to serialize data, probably a list
        if (variant.canConvert<QVariantList>()) {
            QSequentialIterable iterable = variant.value<QSequentialIterable>();

            for (const QVariant &v : iterable) {
                serializedValue += v.toString();
                serializedValue += DELIMITER;
            }
        }

        serializedValue.chop(3);
        return serializedValue;
    } else {
        return value;
    }
}

QVariantList ObjectStorage::unserializeValue(const QString &text) const
{
    QVariantList unserialized;
    for (auto element : text.split(DELIMITER)) {
        unserialized.append(QVariant::fromValue(element));
    }
    return  unserialized;
}

