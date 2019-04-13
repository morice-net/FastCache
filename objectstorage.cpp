#include "objectstorage.h"
#include "objectstorage.h"

#include <QMetaObject>
#include <QMetaProperty>
#include <QVariant>
#include <QDebug>

ObjectStorage::ObjectStorage(QObject *parent) :
	QObject(parent)
{
}

bool ObjectStorage::insertObject(QObject* dataRow)
{
	if (!m_tableNames.contains(dataRow->objectName())) {
		createTableFromObject(dataRow);
	}

	QVector<QString> columnNames;
	QVector<QString> columnTypes;
	for (int i = 1; i < dataRow->metaObject()->propertyCount(); ++i) {
		columnNames << dataRow->metaObject()->property(i).name();
		columnTypes << dataRow->metaObject()->property(i).read(dataRow).toString();
	}
	if (createObject(dataRow->objectName(),columnNames,columnTypes)) {
		m_dataObjects << dataRow;
		return true;
	}
	return false;
}

QVector<QObject *> ObjectStorage::dataTableObjects(const QString& tableName) const
{
	QVector<QObject*> tableObjects;
	foreach (QObject* object, m_dataObjects) {
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

bool ObjectStorage::createTableFromObject(QObject *dataRow)
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
    if (createTable(name,columnNames,columnTypes)) {
		m_tableNames << name;
		return true;
	}
	return false;
}

