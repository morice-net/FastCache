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
    Q_PROPERTY(QString location READ location WRITE setLocation NOTIFY locationChanged)

public:
    explicit FullCache(Cache *parent = nullptr);

    Q_INVOKABLE void sendRequest(QString token);

    QList<int> attributes() const;
    void setAttributes(const QList<int> &attributes);

    QList<bool> attributesBool() const;
    void setAttributesBool(const  QList<bool> &attributesBool);

    QString state() const;
    void setState(const QString &state);

    QString location() const;
    void setLocation(const QString &location);

public slots:  
    void onReplyFinished(QNetworkReply* reply)  ;

signals:
    void stateChanged();
    void attributesChanged();
    void attributesBoolChanged();
    void locationChanged();

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
    QString m_location;
};

#endif // FULLCACHE_H
