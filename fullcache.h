#ifndef FULLCACHE_H
#define FULLCACHE_H

#include "cache.h"
#include "requestor.h"

class FullCache : public Cache
{
    Q_OBJECT

    Q_PROPERTY(QString state READ state WRITE setState NOTIFY stateChanged)
    Q_PROPERTY(QString description READ description WRITE setDescription NOTIFY descriptionChanged)
public:
    FullCache();

    Q_INVOKABLE void loadCache(const QString &token, const QString &geocode);

    QString description() const;
    void setDescription(const QString &description);

    QString state() const;
    void setState(const QString &state);

public slots:
    void onReplyFinished();
    void onReplyFinished(QNetworkReply* reply);

signals:
    void stateChanged();
    void descriptionChanged();

private:
    QString m_state;
    QString m_description;
};

#endif // FULLCACHE_H
