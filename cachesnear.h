#ifndef CACHESNEAR_H
#define CACHESNEAR_H

#include "cachesretriever.h"

class Cache;

class CachesNear : public CachesRetriever
{
    Q_OBJECT

    Q_PROPERTY(double latPoint READ latPoint WRITE setLatPoint NOTIFY latPointChanged)
    Q_PROPERTY(double lonPoint READ lonPoint WRITE setLonPoint NOTIFY lonPointChanged)
    Q_PROPERTY(double distance READ distance WRITE setDistance NOTIFY distanceChanged)

public:
    explicit  CachesNear(QObject *parent = nullptr) ;
    ~CachesNear();

    double latPoint() const;
    void setLatPoint(double latPoint);

    double lonPoint() const;
    void setLonPoint(double lonPoint);

    double distance() const;
    void setDistance(double distance);


signals:
    void latPointChanged();
    void lonPointChanged();
    void distanceChanged();

public slots:
    void onReplyFinished(QNetworkReply* reply) override;

protected:
    bool parameterChecker() override;
    void addSpecificParameters(QJsonObject &parameters) override;

private:
    double m_latPoint;
    double m_lonPoint;
    double m_distance;

};

#endif // CACHESNEAR_H
