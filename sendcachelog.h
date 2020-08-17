#ifndef SENDCACHELOG_H
#define SENDCACHELOG_H

#include "requestor.h"

#include <QNetworkReply>
#include <QObject>
#include <QJsonDocument>

class SendCacheLog : public Requestor
{
    Q_OBJECT

    Q_PROPERTY(int founds READ founds WRITE setFounds NOTIFY foundsChanged)

public:

    explicit SendCacheLog(Requestor *parent = nullptr);
    ~SendCacheLog() override;

    int founds() const;
    void setFounds(const int &count);
    void parseJson(const QJsonDocument &dataJsonDoc) override;

    Q_INVOKABLE QJsonDocument makeJsonLog(int logType , QString date , QString log , bool favorite);
    Q_INVOKABLE void sendRequest(QString token , QString cacheCode, int logType , QString date , QString log , bool favorite);
    Q_INVOKABLE QVariant readJsonProperty(const QJsonDocument &jsonDoc, QString propertyName);

signals:
    void foundsChanged() ;

private:
    int m_count ;
};

#endif // SENDCACHELOG_H
