#ifndef FULLCACHESRECORDED_H
#define FULLCACHESRECORDED_H

#include "requestor.h"
#include "sqlitestorage.h"
#include "replaceimageintext.h"

#include <QNetworkReply>

class ReplaceImageInText;

class FullCachesRecorded : public Requestor
{
    Q_OBJECT

    Q_PROPERTY(QString userName READ userName WRITE setUserName NOTIFY userNameChanged)

public:
    explicit  FullCachesRecorded(Requestor *parent = nullptr);
    ~FullCachesRecorded() override;

    Q_INVOKABLE void sendRequest(QString token , QList<QString> geocodes , QList<bool> cachesLists , SQLiteStorage *sqliteStorage);
    Q_INVOKABLE QJsonDocument markFoundInJson(const QJsonDocument &dataJsonDoc, const QString &date, const bool &favorited);

    void parseJson(const QJsonDocument &dataJsonDoc) override;
    QList<QString> extract(const QList<QString> &list, const int &begin, const int &blockLength);

    QString userName() const;
    void  setUserName(QString &m_userName);

signals:
    void userNameChanged();

private:
    ReplaceImageInText* m_replaceImageInText = new ReplaceImageInText;
    QList<bool> m_cachesLists;
    SQLiteStorage *m_sqliteStorage;
    QString m_userName;
};

#endif // FULLCACHESRECORDED_H
