#ifndef CACHESNEAR_H
#define CACHESNEAR_H

#include "cachesretriever.h"

#include <QtQml>

class Cache;

class CachesNear : public CachesRetriever
{
    Q_OBJECT
    QML_ELEMENT

    Q_PROPERTY(double latPoint READ latPoint WRITE setLatPoint NOTIFY latPointChanged)
    Q_PROPERTY(double lonPoint READ lonPoint WRITE setLonPoint NOTIFY lonPointChanged)
    Q_PROPERTY(double distance READ distance WRITE setDistance NOTIFY distanceChanged)

public:
    explicit  CachesNear(CachesRetriever *parent = nullptr) ;
    ~CachesNear() override;

    Q_INVOKABLE void sendRequest(QString token);
    void parseJson(const QJsonDocument &dataJsonDoc) override;
    void moreCaches() override;


    double latPoint() const;
    void setLatPoint(double latPoint);

    double lonPoint() const;
    void setLonPoint(double lonPoint);

    double distance() const;
    void setDistance(double distance);

protected:
    QString addGetRequestParameters(QString parameters) override;

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
