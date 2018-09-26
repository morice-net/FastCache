#ifndef CACHEATTRIBUTE_H
#define CACHEATTRIBUTE_H


#include <QObject>

class CacheAttribute : public QObject
{
    Q_OBJECT

    Q_PROPERTY(int gcId READ gcId WRITE setGcId NOTIFY gcIdChanged)
    Q_PROPERTY(QString textYes READ textYes WRITE setTextYes NOTIFY textYesChanged)
    Q_PROPERTY(QString textNo READ textNo WRITE setTextNo NOTIFY textNoChanged)
    Q_PROPERTY(QString icon READ icon WRITE setIcon NOTIFY iconChanged)

public:
    explicit  CacheAttribute(QObject *parent = nullptr);
    ~CacheAttribute();

    int gcId() const;
    void  setGcId(int &m_gcId);

    QString  textYes() const;
    void  setTextYes(QString &m_textYes);

    QString  textNo() const;
    void  setTextNo(QString &m_textNo);

    QString  icon() const;
    void  setIcon(QString &m_icon);


signals:
    void gcIdChanged();
    void textYesChanged();
    void textNoChanged();
    void iconChanged();

private:
    int m_gcId;
    QString m_textYes;
    QString m_textNo;
    QString m_icon;
};

#endif // CACHEATTRIBUTE_H
