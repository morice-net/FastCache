#include "connector.h"
#include <QDebug>
#include <QNetworkAccessManager>
#include <QMessageAuthenticationCode>
#include <QJsonObject>
#include <QJsonDocument>

Connector::Connector(QObject *parent)
    : QObject(parent)
    , m_consumerKey(QByteArray::fromBase64("QjMxMkE3N0EtQkEyNS00NUQ0LUJDMTItOTM3MTE0NzUxNTEy"))
    , m_consumerSecret(QByteArray::fromBase64("ODk0QjY4OTMtQzY1MS00NEZCLTgzRTEtRTVFOEFFQjU4MDFD"))
    , m_redirectUri("https://geocaching4locus.eu/oauth")
    , m_tokenKey()
    , m_refreshToken()
    , m_codeVerifier("")
    , m_codeChallenge("")
{
    m_networkManager = new QNetworkAccessManager(this);
    QObject::connect(m_networkManager, &QNetworkAccessManager::finished,
                     this, &Connector::replyFinished);
    QObject::connect(m_networkManager, &QNetworkAccessManager::sslErrors,
                     this, &Connector::sslErrorsSlot);
}

Connector::~Connector()
{
    delete m_networkManager;
}

void Connector::createCodes_verifier_challenge()
{
    m_codeVerifier = (QUuid::createUuid().toString(QUuid::WithoutBraces) + QUuid::createUuid().toString(QUuid::WithoutBraces)).toLatin1();
    m_codeChallenge = QCryptographicHash::hash(m_codeVerifier, QCryptographicHash::Sha256).toBase64(
        QByteArray::Base64UrlEncoding | QByteArray::OmitTrailingEquals);
}

void Connector::connect()
{
    if(m_expiresAt == 0)
    {
        createCodes_verifier_challenge();

        // Building parameters of the request(oauth2)
        m_requestString.clear();
        m_parameters.clear();
        addGetParam("client_id", m_consumerKey , false);
        addGetParam("response_type", "code", false);
        addGetParam("scope", "*", false);
        addGetParam("redirect_uri", m_redirectUri, false);
        addGetParam("code_challenge_method", "S256", false);
        addGetParam("code_challenge", m_codeChallenge, false);

        m_requestString = "https://www.geocaching.com/oauth/Authorize.aspx?" + joinParams();

        // Building getRequest
        emit logOn(m_requestString);
        qDebug() << "GET Request string" << m_requestString;
        return;
    }

    // In case a simple refresh token is necessary
    if (m_expiresAt <= QDateTime::currentSecsSinceEpoch())
    {
        oauthRefreshToken();
        return;
    }

    // nothing
    emit loginProcedureDone();
    return ;
}

void Connector::replyFinished(QNetworkReply *reply)
{
    QByteArray replyValue(reply->readAll());
    qDebug() << "Reply finished:" << replyValue;
    QJsonDocument dataJsonDoc;
    QJsonObject JsonObj;
    if (reply->error() == QNetworkReply::NoError) {
        dataJsonDoc = QJsonDocument::fromJson(replyValue);
        JsonObj = dataJsonDoc.object();

        // Check if this the second step
        setTokenKey( JsonObj["access_token"].toString());
        setRefreshToken( JsonObj["refresh_token"].toString());
        setExpiresAt(QDateTime::currentSecsSinceEpoch() + JsonObj["expires_in"].toInt());
        qDebug() << "TokenKey:" << m_tokenKey;
        qDebug() << "RefreshToken:" << m_refreshToken;
        qDebug() << "Expires At:" <<QDateTime::fromSecsSinceEpoch(m_expiresAt);

        emit loginProcedureDone();

    } else {
        qDebug() << "Connection in error:" << reply->errorString();
        setExpiresAt(0);
        connect();
    }
}

void Connector::oauthAuthorizeCode(const QString &url)
{
    QString codeParameter(url.split("code=").last());
    QNetworkRequest requestUrl;
    requestUrl.setUrl(QUrl("https://oauth.geocaching.com/token"));
    requestUrl.setHeader(QNetworkRequest::ContentTypeHeader, "application/x-www-form-urlencoded");

    // Adding parameters to the request POST
    QByteArray postData;
    postData.append("client_id=" + QUrl::toPercentEncoding(m_consumerKey) + "&");
    postData.append("client_secret=" + QUrl::toPercentEncoding(m_consumerSecret) + "&");
    postData.append("grant_type=authorization_code&" );
    postData.append("redirect_uri=" + QUrl::toPercentEncoding( redirectUri()) + "&");
    postData.append("code=" + codeParameter.toLocal8Bit() + "&");
    postData.append("code_verifier=" + m_codeVerifier);

    qDebug() << "POST DATA with the code =====>>>>>> " << postData;

    // Sending post request
    m_networkManager->post(requestUrl,postData);
}

void Connector::oauthRefreshToken()
{
    QNetworkRequest requestUrl;
    requestUrl.setUrl(QUrl("https://oauth.geocaching.com/token"));
    requestUrl.setHeader(QNetworkRequest::ContentTypeHeader, "application/x-www-form-urlencoded");

    // Adding parameters to the request
    QByteArray postData;
    postData.append("client_id=" + QUrl::toPercentEncoding(m_consumerKey)+"&");
    postData.append("client_secret=" + QUrl::toPercentEncoding(m_consumerSecret)+"&");
    postData.append("grant_type=refresh_token&" );
    postData.append("redirect_uri=" +QUrl::toPercentEncoding( redirectUri()) + "&");
    postData.append("refresh_token=" + m_refreshToken.toLocal8Bit());

    qDebug() << "POST DATA second POST step =====>>>>>> " << postData;

    // Sending post request
    m_networkManager->post(requestUrl,postData);
}

void Connector::addGetParam(QString parameterName, QString parameterValue, bool encoding)
{
    if (!m_requestString.endsWith("?")) {
        m_requestString.append("&");
    }
    Parameter *param = new Parameter();
    param->setName(parameterName);
    param->setValue( encoding ? QString(QUrl::toPercentEncoding(parameterValue)) : parameterValue );
    param->setEncoded(encoding);
    m_requestString.append(param->name()).append("=").append(param->value());
    m_parameters << param;
}

QString Connector::joinParams() {
    QStringList paramsEncoded;
    foreach (Parameter *param, m_parameters) {
        paramsEncoded << param->name() + "=" + param->value();
    }
    return paramsEncoded.join("&");
}

void Connector::sslErrorsSlot(QNetworkReply *reply, const QList<QSslError> &errors)
{
    Q_UNUSED(errors)
    qDebug() <<"SSL Error:" << reply->errorString();
    reply->ignoreSslErrors();
}

/** Getters & Setters **/

qint64 Connector::expiresAt() const
{
    return m_expiresAt;
}

void Connector::setExpiresAt(const qint64 &expiresAt)
{
    m_expiresAt = expiresAt;
    emit expiresAtChanged();
}

QString Connector::refreshToken() const
{
    return m_refreshToken;
}

void Connector::setRefreshToken(const QString &refreshToken)
{
    m_refreshToken = refreshToken;
    emit refreshTokenChanged();
}

QString Connector::tokenKey() const
{
    return m_tokenKey;
}

void Connector::setTokenKey(const QString &tokenKey)
{
    m_tokenKey = tokenKey;
    emit tokenKeyChanged();
}

QString Connector::consumerSecret() const
{
    return m_consumerSecret;
}

void Connector::setConsumerSecret(const QString &consumerSecret)
{
    m_consumerSecret = consumerSecret;
    emit consumerSecretChanged();
}

QString Connector::redirectUri() const
{
    return m_redirectUri;
}

void Connector::setRedirectUri(const QString &redirectUri)
{
    m_redirectUri = redirectUri;
    emit redirectUriChanged();
}

QString Connector::consumerKey() const
{
    return m_consumerKey;
}

void Connector::setConsumerKey(const QString &consumerKey)
{
    m_consumerKey = consumerKey;
    emit consumerKeyChanged();
}
