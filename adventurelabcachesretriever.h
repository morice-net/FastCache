#ifndef ADVENTURELABCACHESRETRIEVER_H
#define ADVENTURELABCACHESRETRIEVER_H

#include "requestor.h"
#include "cachessinglelist.h"

#include <QNetworkReply>

class AdventureLabCachesRetriever : public Requestor
{
    Q_OBJECT

    Q_PROPERTY(int indexMoreCaches READ indexMoreCaches WRITE setIndexMoreCaches NOTIFY indexMoreCachesChanged)
    Q_PROPERTY(int maxCaches READ maxCaches WRITE setMaxCaches NOTIFY maxCachesChanged)
    Q_PROPERTY(double latPoint READ latPoint WRITE setLatPoint NOTIFY latPointChanged)
    Q_PROPERTY(double lonPoint READ lonPoint WRITE setLonPoint NOTIFY lonPointChanged)
    Q_PROPERTY(bool excludeOwnedCompleted READ excludeOwnedCompleted WRITE setExcludeOwnedCompleted NOTIFY excludeOwnedCompletedChanged)

public:
    explicit  AdventureLabCachesRetriever(Requestor *parent = nullptr);
    ~AdventureLabCachesRetriever() override;

    Q_INVOKABLE void sendRequest(QString token);

    void parseJson(const QJsonDocument &dataJsonDoc) override;

    int indexMoreCaches();
    void setIndexMoreCaches(int indexMoreCaches);

    int maxCaches();
    void setMaxCaches(int max);

    double latPoint() const;
    void setLatPoint(double latPoint);

    double lonPoint() const;
    void setLonPoint(double lonPoint);

    bool excludeOwnedCompleted() const;
    void setExcludeOwnedCompleted(bool exclude);


signals:
    void clearMapRequested();
    void indexMoreCachesChanged();
    void maxCachesChanged();
    void latPointChanged();
    void lonPointChanged();
    void excludeOwnedCompletedChanged();

private:
    int m_indexMoreCaches;
    int m_maxCaches;
    QString m_tokenTemp ;
    QString m_userName;
    double m_latPoint;
    double m_lonPoint;
    bool m_excludeOwnedCompleted;


    CachesSingleList *m_listLabCaches;
};

#endif // ADVENTURELABCACHESRETRIEVER_H
