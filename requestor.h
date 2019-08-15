#ifndef REQUESTOR_H
#define REQUESTOR_H

#include <QObject>
#include <QNetworkReply>
#include <QJsonDocument>

class Requestor : public QObject
{
    Q_OBJECT

    Q_PROPERTY(QString state READ state WRITE setState NOTIFY stateChanged)

public:
    explicit Requestor(QObject *parent = nullptr);

    virtual void sendPostRequest(const QString &requestName, const QJsonObject &parameters , QString token);
    virtual void sendGetRequest(const QString &requestName , QString token);
    virtual void sendPutRequest(const QString &requestName ,const QByteArray &data, QString token);
    virtual void sendDeleteRequest(const QString &requestName, QString token);

    virtual void parseJson(const QJsonDocument &dataJsonDoc) = 0;

    QString state() const;
    void setState(const QString &state);

signals:
    void requestReady();
    void stateChanged();

public slots:
    void onReplyFinished(QNetworkReply* reply);

protected:
    //  network manager
    QNetworkAccessManager *m_networkManager;

private:
    QString m_state;
};

#endif // REQUESTOR_H
