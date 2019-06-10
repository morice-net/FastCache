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
    Q_PROPERTY(QString redirectUri READ redirectUri WRITE setRedirectUri NOTIFY redirectUriChanged)
    Q_PROPERTY(QString tokenKey READ tokenKey WRITE setTokenKey NOTIFY tokenKeyChanged)
    Q_PROPERTY(QString refreshToken READ refreshToken WRITE setRefreshToken NOTIFY refreshTokenChanged)

public:
    explicit Connector(QObject *parent = nullptr);
    ~Connector();

    Q_INVOKABLE void connect();
    Q_INVOKABLE void oauthRefreshToken(QString url);
    Q_INVOKABLE void oauthRefreshToken();

    /// Getters & Setters - for property QML binding
    QString consumerKey() const;
    void setConsumerKey(const QString &consumerKey);

    QString consumerSecret() const;
    void setConsumerSecret(const QString &consumerSecret);

    QString redirectUri() const;
    void setRedirectUri(const QString &redirectUri);

    QString tokenKey() const;
    void setTokenKey(const QString &tokenKey);

    QString refreshToken() const;
    void setRefreshToken(const QString &refreshToken);

signals:
    void logOn(const QString& url);
    void loginProcedureDone();

    void consumerKeyChanged();
    void consumerSecretChanged();
    void redirectUriChanged();
    void tokenKeyChanged();
    void refreshTokenChanged();

public slots:
    void replyFinished(QNetworkReply* reply);
    void sslErrorsSlot(QNetworkReply *reply, const QList<QSslError> &errors);

private:
    /// The network manager
    QNetworkAccessManager *m_networkManager;

    /// The keys properties
    QString m_consumerKey;
    QString m_consumerSecret;
    QString m_redirectUri;
    QString m_tokenKey;
    QString m_refreshToken;

    /// Privates members
    QString m_requestString;
    QList<Parameter*> m_parameters;
    QList<Parameter*> m_postParameters;

    /// Privates methods
    QString joinParams();
    void addGetParam(QString parameterName, QString parameterValue, bool encoding = false);
};

#endif // CONNECTOR_H
