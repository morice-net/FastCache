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
    explicit  CachesNear(CachesRetriever *parent = nullptr) ;
    ~CachesNear() override;

    Q_INVOKABLE void sendRequest(QString token) override;
    void parseJson(const QJsonDocument &dataJsonDoc) override;


    double latPoint() const;
    void setLatPoint(double latPoint);

    double lonPoint() const;
    void setLonPoint(double lonPoint);

    double distance() const;
    void setDistance(double distance);

protected:
    void addGetRequestParameters(QString &parameters) override;

signals:
    void latPointChanged();
    void lonPointChanged();
    void distanceChanged();

private:
    double m_latPoint;
    double m_lonPoint;
    double m_distance;

};

#endif // CACHESNEAR_H
