#ifndef FULLCACHE_H
#define FULLCACHE_H

#include "cache.h"
#include "requestor.h"

class FullCache : public Requestor
{
    Q_OBJECT

    Q_PROPERTY(QString cacheCode READ cacheCode WRITE setCacheCode NOTIFY cacheCodeChanged)
    Q_PROPERTY(QString state READ state WRITE setState NOTIFY stateChanged)
    Q_PROPERTY(QString description READ description WRITE setDescription NOTIFY descriptionChanged)

public:
 explicit FullCache(QObject *parent = nullptr);

    Q_INVOKABLE void sendRequest(QString token) override;

    QString description() const;
    void setDescription(const QString &description);

    QString cacheCode() const;
    void setCacheCode(const QString &cacheCode);

    QString state() const;
    void setState(const QString &state);

public slots:
    void onReplyFinished();
    void onReplyFinished(QNetworkReply* reply) override ;

signals:
    void stateChanged();
    void descriptionChanged();
    void cacheCodeChanged();

protected:
    const int MAX_PER_PAGE=40;
    const int GEOCACHE_LOG_COUNT=30;
    const int TRACKABLE_LOG_COUNT=30;

private:
    QString m_state;
    QString m_description;
    QString m_cacheCode;
};

#endif // FULLCACHE_H
