#ifndef FULLLABCACHERETRIEVER_H
#define FULLLABCACHERETRIEVER_H

#include "requestor.h"
#include "fullcache.h"
#include "cachessinglelist.h"
#include "sqlitestorage.h"
#include "replaceimageintext.h"

#include <QNetworkReply>

class FullCache;
class FullLabCacheRetriever : public Requestor
{
    Q_OBJECT

public:
    explicit  FullLabCacheRetriever(Requestor *parent = nullptr);
    ~FullLabCacheRetriever() override;

    Q_INVOKABLE void sendRequest(QString token);
    Q_INVOKABLE void updateFullCache(FullCache *fullCache);
    Q_INVOKABLE  void parseJson(const QJsonDocument &dataJsonDoc) override;
    Q_INVOKABLE void listCachesObject(CachesSingleList *listCaches);
    Q_INVOKABLE void writeToStorage(SQLiteStorage *sqliteStorage);
    Q_INVOKABLE void deleteToStorage(SQLiteStorage *sqliteStorage);
    Q_INVOKABLE void updateReplaceImageInText(ReplaceImageInText *replace);

private slots:
    void setDescription(QString value);

private: signals:
    void descriptionChanged(QString newValue);

private:
    FullCache *m_fullCache;
    QJsonDocument m_dataJson;
    CachesSingleList *m_listCaches;
    ReplaceImageInText* m_replaceImageInText ;

    void descriptionLabCache(QString url, QString imageUrl , QString name);
};

#endif // FULLLABCACHERETRIEVER_H
