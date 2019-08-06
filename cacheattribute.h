#ifndef CACHEATTRIBUTE_H
#define CACHEATTRIBUTE_H

#include <QObject>

class CacheAttribute : public QObject
{
    Q_OBJECT

    Q_PROPERTY(QList<QString> listTextYes READ listTextYes  NOTIFY listTextYesChanged)
    Q_PROPERTY(QList<QString> listTextNo READ listTextNo  NOTIFY listTextNoChanged)
    Q_PROPERTY(QList<QString> listIcon READ listIcon  NOTIFY listIconChanged)

public:
    explicit  CacheAttribute(QObject *parent = nullptr);
    ~CacheAttribute();

    QList<QString>  listTextYes() const;
    QList<QString>  listTextNo() const;
    QList<QString>  listIcon() const;

private:
    QList<QString> createListAttributes();
    QList<QString>  listAttributesYes(QList<QString> listAttributes) ;
    QList<QString>  listAttributesNo(QList<QString> listAttributes) ;
    QList<QString>  listAttributesIcon(QList<QString> listAttributes) ;

signals:
    void listTextYesChanged();
    void listTextNoChanged();
    void listIconChanged();

private:
    QList<QString> m_listTextYes;
    QList<QString> m_listTextNo;
    QList<QString> m_listIcon;
};

#endif // CACHEATTRIBUTE_H
