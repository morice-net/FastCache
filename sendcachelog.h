#ifndef SENDCACHELOG_H
#define SENDCACHELOG_H

#include "requestor.h"

#include <QNetworkReply>
#include <QObject>

class SendCacheLog : public Requestor
{
    Q_OBJECT

    Q_PROPERTY(int founds READ founds WRITE setFounds NOTIFY foundsChanged)

public:

    explicit SendCacheLog(Requestor *parent = nullptr);
    ~SendCacheLog() override;

    int founds() const;
    void setFounds(const int &count);

    Q_INVOKABLE void sendRequest(QString token , QString cacheCode, int logType , QString date , QString log , bool favorite) ;

    void parseJson(const QJsonDocument &dataJsonDoc) override;

signals:   
    void foundsChanged() ;

private:
    int m_count ;

    //  network manager

    QNetworkAccessManager *m_networkManager;
};

#endif // SENDCACHELOG_H
