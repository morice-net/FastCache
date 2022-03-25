#ifndef CACHEATTRIBUTE_H
#define CACHEATTRIBUTE_H

#include <QObject>

class CacheAttribute : public QObject
{
    Q_OBJECT

    //all attributes
    Q_PROPERTY(QList<QString> listTextYes READ listTextYes  NOTIFY listTextYesChanged)
    Q_PROPERTY(QList<QString> listTextNo READ listTextNo  NOTIFY listTextNoChanged)
    Q_PROPERTY(QList<QString> listIcon READ listIcon  NOTIFY listIconChanged)
    Q_PROPERTY(QList<int> listGroup READ listGroup  NOTIFY listGroupChanged)

    // attributes of a cache
    Q_PROPERTY(QList<int> numberAttributesByGroup READ numberAttributesByGroup WRITE setNumberAttributesByGroup  NOTIFY numberAttributesByGroupChanged)
    Q_PROPERTY(QList<int> sortedAttributesByGroup READ sortedAttributesByGroup WRITE setSortedAttributesByGroup  NOTIFY sortedAttributesByGroupChanged)
    Q_PROPERTY(QList<bool> sortedBoolByGroup READ sortedBoolByGroup WRITE setSortedBoolByGroup  NOTIFY sortedBoolByGroupChanged)

public:
    explicit  CacheAttribute(QObject *parent = nullptr);
    ~CacheAttribute();

    QList<QString>  listTextYes() const;
    QList<QString>  listTextNo() const;
    QList<QString>  listIcon() const;
    QList<int>  listGroup() const;
    QList<int>  numberAttributesByGroup() const;
    void setNumberAttributesByGroup(QList<int> list);
    QList<int>  sortedAttributesByGroup() const;
    void setSortedAttributesByGroup(QList<int> list);
    QList<bool>  sortedBoolByGroup() const;
    void setSortedBoolByGroup(QList<bool> list);

    Q_INVOKABLE QList<QString> sortAttributes(QList<bool> listBool , QList<int> listAtt);

private:
    QList<QString> createListAttributes();
    QList<QString>  listAttributesYes(QList<QString> list) ;
    QList<QString>  listAttributesNo(QList<QString> list) ;
    QList<QString>  listAttributesIcon(QList<QString> list) ;
    QList<int>  listAttributesGroup(QList<QString> list) ;
    QString  headerText(int index) ;

signals:
    void listTextYesChanged();
    void listTextNoChanged();
    void listIconChanged();
    void listGroupChanged();
    void numberAttributesByGroupChanged();
    void sortedAttributesByGroupChanged();
    void sortedBoolByGroupChanged();

private:
    QList<QString> m_listTextYes;
    QList<QString> m_listTextNo;
    QList<QString> m_listIcon;
    QList<int> m_listGroup;
    QList<int> m_numberAttributesByGroup;
    QList<int> m_sortedAttributesByGroup;
    QList<bool> m_sortedBoolByGroup;
};

#endif // CACHEATTRIBUTE_H
