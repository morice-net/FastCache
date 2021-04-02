#ifndef CACHESRETRIEVER_H
#define CACHESRETRIEVER_H

#include "requestor.h"
#include "cachessinglelist.h"

#include <QNetworkReply>
#include <QQmlListProperty>

class Cache;

class CachesRetriever : public Requestor
{
    Q_OBJECT

    Q_PROPERTY(int indexMoreCaches READ indexMoreCaches WRITE setIndexMoreCaches NOTIFY indexMoreCachesChanged)

public:
    explicit  CachesRetriever(Requestor *parent = nullptr);
    ~CachesRetriever() override;

    virtual void moreCaches() = 0;

    Q_INVOKABLE void sendRequest(QString token);
    Q_INVOKABLE void updateFilterCaches(QList <bool> types , QList <bool> Sizes , QList <double > difficultyTerrain ,bool found , bool archived ,
                                        QList <QString > keyWordDiscoverOwner ,QString userName);
    Q_INVOKABLE void listCachesObject(CachesSingleList *listCaches);

    void parseJson(const QJsonDocument &dataJsonDoc) override;
    int indexMoreCaches();
    void setIndexMoreCaches(int indexMoreCaches);

protected:
    virtual void addGetRequestParameters(QString& parameters) = 0;

signals:
    void clearMapRequested();
    void indexMoreCachesChanged();

protected:
    int m_indexMoreCaches;
    QString m_tokenTemp ;
    QString m_referenceCode   ; // used for loading pockets queries
    QString m_userName;
    QList<int> m_filterTypes;
    QList<int> m_filterSizes;
    QList<double> m_filterDifficultyTerrain;
    QList<QString> m_keyWordDiscoverOwner;

    bool m_filterExcludeFound;
    bool m_filterExcludeArchived;
    CachesSingleList *m_listCaches;
};

#endif // CACHESRETRIEVER_H
