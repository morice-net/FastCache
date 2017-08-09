#ifndef CONNECTOR_H
#define CONNECTOR_H

#include <QNetworkReply>
#include <QObject>

#include "parameter.h"

class Connector : public QObject
{
    Q_OBJECT

    Q_PROPERTY(QString consumerKey READ consumerKey WRITE setConsumerKey NOTIFY consumerKeyChanged)
    Q_PROPERTY(QString consumerSecret READ consumerSecret WRITE setConsumerSecret NOTIFY consumerSecretChanged)
    Q_PROPERTY(QString tokenKey READ tokenKey WRITE setTokenKey NOTIFY tokenKeyChanged)
    Q_PROPERTY(QString tokenSecret READ tokenSecret WRITE setTokenSecret NOTIFY tokenSecretChanged)

public:
    explicit Connector(QObject *parent = 0);
    ~Connector();

    Q_INVOKABLE void connect();
    Q_INVOKABLE void oauthVerifierAndToken(QString url);

    // Getters & Setters - for property QML binding
    QString consumerKey() const;
    void setConsumerKey(const QString &consumerKey);

    QString consumerSecret() const;
    void setConsumerSecret(const QString &consumerSecret);

    QString tokenKey() const;
    void setTokenKey(const QString &tokenKey);

    QString tokenSecret() const;
    void setTokenSecret(const QString &tokenSecret);

signals:
    void logOn(const QString& url);

    void consumerKeyChanged();
    void consumerSecretChanged();
    void tokenKeyChanged();
    void tokenSecretChanged();

public slots:
    void replyFinished(QNetworkReply* reply);

private:
    /// The network manager
    QNetworkAccessManager *m_networkManager;

    /// The keys properties
    QString m_consumerKey;
    QString m_consumerSecret;
    QString m_tokenKey;
    QString m_tokenSecret;

    /// Privates members
    QString m_requestString;
    QList<Parameter*> m_parameters;
    QList<Parameter*> m_postParameters;
    bool m_postRequest;

    /// Privates methods
    QString joinParams();
    void addGetParam(QString parameterName, QString parameterValue, bool encoding = false);
    QByteArray buildGetSignature(const QString &request);
    QByteArray buildPostSignature(const QUrl &postRequest, const QByteArray &postJoinedParameters);
    QByteArray nonce();
};

#endif // CONNECTOR_H
