#include "connector.h"
#include <QDebug>
#include <QNetworkAccessManager>
#include <QMessageAuthenticationCode>
#include <QJsonObject>
#include <QJsonDocument>

Connector::Connector(QObject *parent)
    : QObject(parent)
    , m_consumerKey("B312A77A-BA25-45D4-BC12-937114751512")
    , m_consumerSecret("894B6893-C651-44FB-83E1-E5E8AEB5801C")
    , m_redirectUri("https://geocaching4locus.eu/oauth")
    , m_tokenKey()
    , m_refreshToken()
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

void Connector::connect()
{
    // Building parameters of the request(oauth2)
    addGetParam("client_id", m_consumerKey , false);
    addGetParam("response_type", "code", false);
    addGetParam("scope", "*", false);
    addGetParam("redirect_uri", m_redirectUri, false);

    m_requestString = "https://www.geocaching.com/oauth/Authorize.aspx?" + joinParams();

    // Building getRequest
    qDebug() << "GET Request string" << m_requestString;
    emit logOn(m_requestString);
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
        bool refreshNeeded = false;
        // Check if this the second step
        if (m_refreshToken.isEmpty()){
            refreshNeeded = true;
        }
        setTokenKey( JsonObj["access_token"].toString());
        setRefreshToken( JsonObj["refresh_token"].toString());
        qDebug() << "TokenKey:" << m_tokenKey;
        qDebug() << "RefreshToken:" << m_refreshToken;
        if (!m_refreshToken.isEmpty()){
            emit loginProcedureDone();
        }
        // In case of second step send the second POST request
        if (refreshNeeded) {
            oauthRefreshToken();
        }
    } else {
        qDebug() << "Connection in error:" << reply->errorString();
    }
}

void Connector::oauthRefreshToken(QString url)
{
    QString codeParameter(url.split("code=").last());
    QNetworkRequest requestUrl;
    requestUrl.setUrl(QUrl("https://oauth.geocaching.com/token"));
    requestUrl.setHeader(QNetworkRequest::ContentTypeHeader, "application/x-www-form-urlencoded");

    // Adding parameters to the request POST
    QByteArray postData;
    postData.append("client_id=" + QUrl::toPercentEncoding(m_consumerKey)+"&");
    postData.append("client_secret=" + QUrl::toPercentEncoding(m_consumerSecret)+"&");
    postData.append("grant_type=authorization_code&" );
    postData.append("redirect_uri=" +QUrl::toPercentEncoding( redirectUri()) + "&");
    postData.append("code=" + codeParameter );

    qDebug() << "POST DATA =====>>>>>> " << postData;

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
    postData.append("refresh_token=" + m_refreshToken);

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
