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
    Q_PROPERTY(QString state READ state WRITE setState NOTIFY stateChanged)

public:
    explicit  CachesBBox(CachesRetriever *parent = nullptr);
    ~CachesBBox() override;

    Q_INVOKABLE void sendRequest(QString token) override;
    Q_INVOKABLE void updateFilterCaches(QList <int> types , QList <int> Sizes , QList <double > difficultyTerrain ,bool found , bool archived ,QList <QString > keyWordDiscoverOwner ,QString userName);

    QString state() const;
    void setState(const QString &state);

    void parseJson(const QJsonDocument &dataJsonDoc) override;

    double latBottomRight() const;
    void setLatBottomRight(double latBottomRight);

    double lonBottomRight() const;
    void setLonBottomRight(double lonBottomRight);

    double latTopLeft() const;
    void setLatTopLeft(double latTopLeft);

    double lonTopLeft() const;
    void setLonTopLeft(double lonTopLeft);

protected:
    void addGetRequestParameters(QString &parameters) override;

signals:
    void latBottomRightChanged();
    void lonBottomRightChanged();
    void latTopLeftChanged();
    void lonTopLeftChanged();
    void cachesChanged();
    void stateChanged();

private:
    QString m_state;
    double m_latBottomRight;
    double m_lonBottomRight;
    double m_latTopLeft;
    double m_lonTopLeft;
};

#endif // CACHESBBOX_H
