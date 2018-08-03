#ifndef CACHESIZE_H
#define CACHESIZE_H


#include <QObject>

class CacheSize : public QObject
{
    Q_OBJECT

    Q_PROPERTY(QString sizeId READ sizeId WRITE setSizeId NOTIFY sizeIdChanged)
    Q_PROPERTY(int sizeIdGs READ sizeIdGs WRITE setSizeIdGs NOTIFY sizeIdGsChanged)

public:
    explicit  CacheSize(QObject *parent = nullptr);
    ~CacheSize();

    QString sizeId() const;
    void  setSizeId(QString &m_sizeId);

    int  sizeIdGs()const;
    void    setSizeIdGs(int &m_sizeIdGs);


signals:
    void sizeIdChanged();
    void sizeIdGsChanged();

private:
    QString m_sizeId;
    int m_sizeIdGs;

};

#endif // CACHESIZE_H
