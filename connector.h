#ifndef CONNECTOR_H
#define CONNECTOR_H

#include <QNetworkReply>
#include <QObject>

#include "parameter.h"

class Connector : public QObject
{
    Q_OBJECT
public:
    explicit Connector(QObject *parent = 0);
    ~Connector();

    Q_INVOKABLE void connect();
    Q_INVOKABLE void oauthVerifierAndToken(QString url);
    Q_INVOKABLE bool beginsWith(QString obj, QString value);

	void addGetParam(QString parameterName, QString parameterValue, bool encoding = false);
    QByteArray buildSignature(const QString &request);
    QByteArray nonce();

signals:
    void logOn(const QString& url);

public slots:
	void replyFinished(QNetworkReply* reply);

private:
    QNetworkAccessManager *m_networkManager;

    QString m_requestString;
    QString m_consumerKey;
    QString m_consumerSecret;
    QString m_tokenKey;
    QString m_tokenSecret;
    QList<Parameter*> m_parameters;
    QList<Parameter*> m_postParameters;

    QString joinParams();
};

#endif // CONNECTOR_H
