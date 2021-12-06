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
    Q_PROPERTY(bool timeOutRequest READ timeOutRequest WRITE setTimeOutRequest NOTIFY timeOutRequestChanged)

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

    bool timeOutRequest() const;
    void setTimeOutRequest(const bool &timeOut);

signals:
    void requestReady();
    void stateChanged();
    void requestsLengthChanged();
    void timeOutRequestChanged();

public slots:
    void onReplyFinished(QNetworkReply* reply);
    void disconnect ();

protected:
    //  network manager
    QNetworkAccessManager *m_networkManager;

    QTimer *timer = new QTimer(this);

private:
    QString m_state;
    QList<AllRequest> m_requests;
    int m_requestsLength;
    bool m_timeOutRequest;
};

#endif // REQUESTOR_H
