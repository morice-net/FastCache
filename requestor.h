#ifndef REQUESTOR_H
#define REQUESTOR_H

#include <QObject>
#include <QNetworkReply>
#include <QJsonDocument>
#include <QTimer>

#include "allrequest.h"

class Requestor : public QObject
{
    Q_OBJECT

    Q_PROPERTY(QString state READ state WRITE setState NOTIFY stateChanged)
    Q_PROPERTY(int requestsLength READ requestsLength WRITE setRequestsLength NOTIFY requestsLengthChanged)

public:
    explicit Requestor(QObject *parent = nullptr);

    virtual void sendPostRequest(const QString &requestName, const QJsonObject &parameters , QString token);
    virtual void sendGetRequest(const QString &requestName , QString token);
    virtual void sendPutRequest(const QString &requestName ,const QByteArray &data, QString token);
    virtual void sendDeleteRequest(const QString &requestName, QString token);
    virtual void parseJson(const QJsonDocument &dataJsonDoc) = 0;

    QString state() const;
    void setState(const QString &state);

    int requestsLength() const;
    void setRequestsLength(const int &requestsLength);

signals:
    void requestReady();
    void stateChanged();
    void requestsLengthChanged();

public slots:
    void onReplyFinished(QNetworkReply* reply);

protected:
    //  network manager
    QNetworkAccessManager *m_networkManager;

private:
    QString m_state;
    QList<AllRequest> m_requests;
    int m_requestsLength;
    int m_timeOut = 20000;
};

#endif // REQUESTOR_H
