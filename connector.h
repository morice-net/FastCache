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
    Q_INVOKABLE void connect();

	void addGetParam(QString parameterName, QString parameterValue, bool encoding = false);
    QByteArray buildSignature(const QString &request);
    QByteArray nonce();

signals:
    void logOn(const QString& url);

public slots:
	void replyFinished(QNetworkReply* reply);

private:
    QString m_requestString;
    QString m_consumerKey;
    QString m_consumerSecret;
    QString m_tokenKey;
    QString m_tokenSecret;
    QList<Parameter*> m_parameters;

    QString joinParams();
};

#endif // CONNECTOR_H
