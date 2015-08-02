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

    void addGetParam(QString parameterName, QString parameterValue, bool encoding = false);
    QString buildSignature(QString request);
    //QString hmacSha1(const QString &message, const QString &key);
    QString hmacSha1(QByteArray key, QByteArray baseString);
signals:

public slots:
    void onConnect(QString login, QString pass);
    void replyFinished(QNetworkReply* reply);

private:
    QString m_requestString;
    QString m_consumerKey;
    QString m_consumerSecret;
    QString m_tokenKey;
    QString m_tokenSecret;
    QList<Parameter*> m_parameters;

};

#endif // CONNECTOR_H
