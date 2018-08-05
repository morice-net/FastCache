#ifndef CACHESBBOX_H
#define CACHESBBOX_H

#include "cachesretriever.h"

class Cache;

class CachesBBox : public CachesRetriever
{    
    Q_OBJECT

    Q_PROPERTY(double latBottomRight READ latBottomRight WRITE setLatBottomRight NOTIFY latBottomRightChanged)
    Q_PROPERTY(double lonBottomRight READ lonBottomRight WRITE setLonBottomRight NOTIFY lonBottomRightChanged)
    Q_PROPERTY(double latTopLeft READ latTopLeft WRITE setLatTopLeft NOTIFY latTopLeftChanged)
    Q_PROPERTY(double lonTopLeft READ lonTopLeft WRITE setLonTopLeft NOTIFY lonTopLeftChanged)

public:
    explicit  CachesBBox(QObject *parent = nullptr);
    ~CachesBBox() override;    

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
    void cachesChanged();

public slots:
    void onReplyFinished(QNetworkReply* reply) override;

protected:
    bool parameterChecker() override;
    void addSpecificParameters(QJsonObject &parameters) override;

private:
    double m_latBottomRight;
    double m_lonBottomRight;
    double m_latTopLeft;
    double m_lonTopLeft;
};

#endif // CACHESBBOX_H
