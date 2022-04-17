#ifndef FULLCACHERETRIEVER_H
#define FULLCACHERETRIEVER_H

#include "requestor.h"
#include "fullcache.h"
#include "sqlitestorage.h"
#include "replaceimageintext.h"

#include <QNetworkReply>

class ReplaceImageInText;
class FullCache;

class FullCacheRetriever : public Requestor
{
    Q_OBJECT

public:
    explicit  FullCacheRetriever(Requestor *parent = nullptr);
    ~FullCacheRetriever() override;

    Q_INVOKABLE void sendRequest(QString token);
    Q_INVOKABLE void updateFullCache(FullCache *fullCache);
    Q_INVOKABLE void writeToStorage(SQLiteStorage *sqliteStorage);
    Q_INVOKABLE void deleteToStorage(SQLiteStorage *sqliteStorage);
    Q_INVOKABLE  void parseJson(const QJsonDocument &dataJsonDoc) override;
    Q_INVOKABLE void updateReplaceImageInText(ReplaceImageInText *replace);

private:
    FullCache *m_fullCache;
    QJsonDocument m_dataJson;
    ReplaceImageInText* m_replaceImageInText ;
};

#endif // FULLCACHERETRIEVER_H
