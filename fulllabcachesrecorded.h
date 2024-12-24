#ifndef FULLLABCACHESRECORDED_H
#define FULLLABCACHESRECORDED_H

#include "requestor.h"
#include "sqlitestorage.h"
#include "replaceimageintext.h"

#include <QtQml>

class FullLabCachesRecorded : public Requestor
{
    Q_OBJECT
    QML_ELEMENT

public:
    explicit  FullLabCachesRecorded(Requestor *parent = nullptr);
    ~FullLabCachesRecorded() override;

    Q_INVOKABLE void sendRequest(QString token , QList<QString> geocodes , QList<double> latitudes, QList<double> longitudes
                                 , QList<bool> cachesLists , SQLiteStorage *sqliteStorage);
    Q_INVOKABLE void updateReplaceImageInText(ReplaceImageInText *replace);
    void parseJson(const QJsonDocument &dataJsonDoc) override;

private slots:
    void parseHtml();

private :
    void getHtml(QString url , QString id);

    ReplaceImageInText* m_replaceImageInText;
    QList<bool> m_cachesLists;    
    SQLiteStorage *m_sqliteStorage;   
    QString m_tokenTemp;  
    QJsonDocument m_dataJson;   // json for get adventure lab
    QNetworkAccessManager *m_manager{nullptr};
    QMap<QNetworkReply*, QString> m_replytoid;
    const QByteArray userAgent = "Mozilla/5.0 (Windows NT 6.1; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/62.0.3202.94 Safari/537.36";
};

#endif // FULLLABCACHESRECORDED_H
