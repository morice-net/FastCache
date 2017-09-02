#ifndef CACHESBBOX_H
#define CACHESBBOX_H

#include "requestor.h"

class CachesBBox : public Requestor
{

    Q_OBJECT

    Q_PROPERTY(double latBottomRight READ latBottomRight WRITE setLatBottomRight NOTIFY latBottomRightChanged)
    Q_PROPERTY(double lonBottomRight READ lonBottomRight WRITE setLonBottomRight NOTIFY lonBottomRightChanged)
    Q_PROPERTY(double latTopLeft READ latTopLeft WRITE setLatTopLeft NOTIFY latTopLeftChanged)
    Q_PROPERTY(double lonTopLeft READ lonTopLeft WRITE setLonTopLeft NOTIFY lonTopLeftChanged)

public:
    explicit  CachesBBox(QObject *parent = 0);
    ~CachesBBox();

    Q_INVOKABLE virtual void sendRequest(QString token);
    Q_INVOKABLE void sendRequest(QString token, double latBottomRight, double lonBottomRight , double latTopLeft , double lonTopLeft) ;

    double latBottomRight() const;
    void setLatBottomRight(double latBottomRight);

    double lonBottomRight() const;
    void setLonBottomRight(double lonBottomRight);

    double latTopLeft() const;
    void setLatTopLeft(double latTopLeft);

    double lonTopLeft() const;
    void setLonTopLeft(double lonTopLeft);

signals:
    void latBottomRightChanged();
    void lonBottomRightChanged();
    void latTopLeftChanged();
    void lonTopLeftChanged();

public slots:
    void onReplyFinished(QNetworkReply* reply) override;

private:
    const int MAX_PER_PAGE=40;
    const int GEOCACHE_LOG_COUNT=30;
    const int TRACKABLE_LOG_COUNT=30;

    double m_latBottomRight;
    double m_lonBottomRight;
    double m_latTopLeft;
    double m_lonTopLeft;

    void   sendRequestMore(QString token);
};

#endif // CACHESBBOX_H
