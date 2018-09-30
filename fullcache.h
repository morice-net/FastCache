#ifndef FULLCACHE_H
#define FULLCACHE_H

#include <QNetworkReply>
#include <QObject>

#include "cache.h"

class FullCache : public Cache
{
    Q_OBJECT

    Q_PROPERTY(QString state READ state WRITE setState NOTIFY stateChanged)
    Q_PROPERTY(QList<int> attributes READ attributes WRITE setAttributes NOTIFY attributesChanged)
    Q_PROPERTY(QList<bool> attributesBool READ attributesBool WRITE setAttributesBool NOTIFY attributesBoolChanged)

public:
    explicit FullCache(Cache *parent = nullptr);

    Q_INVOKABLE void sendRequest(QString token) ;

    QList<int> attributes();
    void setAttributes(QList<int> &attributes);

    QList<bool> attributesBool();
    void setAttributesBool(  QList<bool> &attributesBool);

    QString state() const;
    void setState(const QString &state);


public slots:  
    void onReplyFinished(QNetworkReply* reply)  ;

signals:
    void stateChanged();
    void attributesChanged();
    void attributesBoolChanged();

protected:
    const int MAX_PER_PAGE=40;
    const int GEOCACHE_LOG_COUNT=30;
    const int TRACKABLE_LOG_COUNT=30;

    QList<int> m_attributes;
    QList<bool> m_attributesBool;

private:

    //  network manager

    QNetworkAccessManager *m_networkManager;

    QString m_state;
};

#endif // FULLCACHE_H
