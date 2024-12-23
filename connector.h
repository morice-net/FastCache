#ifndef CONNECTOR_H
#define CONNECTOR_H

#include <QNetworkReply>
#include <QObject>
#include <QtQml>

#include "parameter.h"

class Connector : public QObject
{
    Q_OBJECT
    QML_ELEMENT

    Q_PROPERTY(QString consumerKey READ consumerKey WRITE setConsumerKey NOTIFY consumerKeyChanged)
    Q_PROPERTY(QString consumerSecret READ consumerSecret WRITE setConsumerSecret NOTIFY consumerSecretChanged)
    Q_PROPERTY(QString redirectUri READ redirectUri WRITE setRedirectUri NOTIFY redirectUriChanged)
    Q_PROPERTY(QString tokenKey READ tokenKey WRITE setTokenKey NOTIFY tokenKeyChanged)
    Q_PROPERTY(QString refreshToken READ refreshToken WRITE setRefreshToken NOTIFY refreshTokenChanged)
    Q_PROPERTY(qint64 expiresAt READ expiresAt WRITE setExpiresAt NOTIFY expiresAtChanged)

public:
    explicit Connector(QObject *parent = nullptr);
    ~Connector();

    Q_INVOKABLE void connect();
    Q_INVOKABLE void oauthAuthorizeCode(QString url);
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

    qint64 expiresAt() const;
    void setExpiresAt(const qint64 &expiresAt);

signals:
    void logOn(const QString& url);
    void loginProcedureDone();

    void consumerKeyChanged();
    void consumerSecretChanged();
    void redirectUriChanged();
    void tokenKeyChanged();
    void refreshTokenChanged();
    void expiresAtChanged();

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
    qint64  m_expiresAt;
    QByteArray m_codeVerifier;
    QString m_codeChallenge;

    /// Privates members
    QString m_requestString;
    QList<Parameter*> m_parameters;
    QList<Parameter*> m_postParameters;    

    /// Privates methods
    QString joinParams();
    void addGetParam(QString parameterName, QString parameterValue, bool encoding = false);
    void createCodes_verifier_challenge();
};

#endif // CONNECTOR_H
