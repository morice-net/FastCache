#include "connector.h"
#include <QDebug>
#include <QNetworkAccessManager>
#include <QMessageAuthenticationCode>

Connector::Connector(QObject *parent) : QObject(parent), m_consumerKey("CF2B186B-0DD2-4E45-93B1-FAD7DF5593D4"), m_consumerSecret("7D0E212A-ADF8-4798-906E-9E6099B68E79")
{
    m_networkManager = new QNetworkAccessManager(this);
    QObject::connect(m_networkManager, SIGNAL(finished(QNetworkReply*)),
                     this, SLOT(replyFinished(QNetworkReply*)));
}

Connector::~Connector()
{
    delete m_networkManager;
}

void Connector::connect()
{
    qDebug() << "Component connect.";

    // Building getRequest
    QString callback = "http://oauth.callback/callback/geocaching";
    addGetParam("oauth_callback", callback, true);
    addGetParam("oauth_consumer_key", m_consumerKey);
    QString oauthTimestamp = QString::number(QDateTime::currentMSecsSinceEpoch()/1000);
    // QString::number(QDateTime::currentDateTimeUtc().toTime_t()).toLatin1();
    addGetParam("oauth_nonce", nonce());
    addGetParam("oauth_signature_method", "HMAC-SHA1");
    addGetParam("oauth_timestamp", oauthTimestamp);
    addGetParam("oauth_version", "1.0");

    m_requestString = "https://www.geocaching.com/oauth/mobileoauth.ashx?" + joinParams();    
    QString oauthSignature = buildGetSignature(m_requestString);
    addGetParam("oauth_signature", oauthSignature, true);

    QNetworkRequest request;
    qDebug() << "request string" << m_requestString;
    request.setUrl(QUrl(m_requestString));
    m_networkManager->get(request);
}

void Connector::replyFinished(QNetworkReply *reply)
{
    if (reply->error() == QNetworkReply::NoError) {
        QString returns = QUrl::fromPercentEncoding(reply->readAll());
        qDebug() << "Reply finished:" << returns;
        QStringList params = returns.split("&");
        foreach (QString param, params) {
            QStringList splitedParam = param.split("=");
            if (splitedParam.size() >= 2) {
                QString paramName = splitedParam.at(0);
                QString paramValue = param.right(param.size() - paramName.length() - 1);
                if (paramName == "oauth_token") {
                    m_tokenKey = paramValue;
                    addGetParam(paramName, paramValue);
                    QString webUrl("https://www.geocaching.com/oauth/mobileoauth.ashx?oauth_token=" + QUrl::toPercentEncoding(paramValue));
                    qDebug() << "Calling for" << webUrl;
                    emit logOn(webUrl);
                }
                if (paramName == "oauth_token_secret") {
                    m_tokenSecret = paramValue;
                    addGetParam(paramName, paramValue);
                }
            } else {
                qWarning() << "A param is malformed" << param;
            }
        }
    } else {
        qDebug() << "Connection in error:" << reply->errorString();
    }
}

QString Connector::tokenSecret() const
{
    return m_tokenSecret;
}

void Connector::setTokenSecret(const QString &tokenSecret)
{
    m_tokenSecret = tokenSecret;
    emit tokenSecretChanged();
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

QString Connector::consumerKey() const
{
    return m_consumerKey;
}

void Connector::setConsumerKey(const QString &consumerKey)
{
    m_consumerKey = consumerKey;
    emit consumerKeyChanged();
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

QByteArray Connector::buildGetSignature(const QString& request)
{
    int position = request.indexOf("?");

    QString joinedParams = joinParams();
    qDebug() << "joinedParams = " << joinedParams;
    QUrl url(request.left(position));
    QString keysPacked = QUrl::toPercentEncoding(m_consumerSecret) + "&" + QUrl::toPercentEncoding(m_tokenSecret);
    QString baseString = "GET&" + QUrl::toPercentEncoding(url.toString(QUrl::RemoveQuery)) + "&" + QUrl::toPercentEncoding(joinedParams);
    qDebug()<< "base string = " << baseString;
    // GET&https%3A%2F%2Fwww.geocaching.com%2Foauth%2Fmobileoauth.ashx&oauth_callback%3Dx-locus%253A%252F%252Foauth.callback%252Fcallback%252Fgeocaching%26oauth_consumer_key%3DCF2B186B-0DD2-4E45-93B1-FAD7DF5593D4%26oauth_nonce%3D3a5738e3e162c90cfab29567cfdb24b0%26oauth_signature_method%3DHMAC-SHA1%26oauth_timestamp%3D1497791384%26oauth_version%3D1.0
    return QMessageAuthenticationCode::hash(baseString.toUtf8(), keysPacked.toUtf8(), QCryptographicHash::Sha1).toBase64();
}

QByteArray Connector::buildPostSignature(const QUrl &postRequest, const QByteArray &postJoinedParameters)
{
    QString keysPacked = QUrl::toPercentEncoding(m_consumerSecret) + "&" + QUrl::toPercentEncoding(m_tokenSecret);
    QString baseString = "POST&" + QUrl::toPercentEncoding(postRequest.toString(QUrl::RemoveQuery)) + "&" + QUrl::toPercentEncoding(QString(postJoinedParameters));
    // Log for debug
    qDebug() << "keysPacked = " << keysPacked;
    qDebug()<< "base string = " << baseString;

    return QMessageAuthenticationCode::hash(baseString.toUtf8(), keysPacked.toUtf8(), QCryptographicHash::Sha1).toBase64();
}

QByteArray Connector::nonce()
{
    QString u = QString::number(QDateTime::currentMSecsSinceEpoch());
    return QCryptographicHash::hash(u.toLatin1(), QCryptographicHash::Md5).toHex();

}

void Connector::oauthVerifierAndToken(QString url)
{    

    // Building postRequest
    QStringList parameters(url.split("oauth_verifier=").last().split("&"));
    QNetworkRequest requestUrl;
    requestUrl.setUrl(QUrl("https://www.geocaching.com/oauth/mobileoauth.ashx"));
    QByteArray postData;
    postData.append("oauth_consumer_key=" + QUrl::toPercentEncoding(m_consumerKey)+"&");
    postData.append("oauth_nonce=" +nonce()+"&");
    postData.append("oauth_signature_method=" +QUrl::toPercentEncoding( "HMAC-SHA1") + "&");
    QString oauthTimestamp = QString::number(QDateTime::currentMSecsSinceEpoch()/1000);
    postData.append("oauth_timestamp=" +QUrl::toPercentEncoding( oauthTimestamp) + "&");
    postData.append("oauth_token=" +QUrl::toPercentEncoding(m_tokenKey)+ "&");
    postData.append("oauth_verifier=" + parameters.at(0)+ "&");
    postData.append("oauth_version=" +QUrl::toPercentEncoding( "1.0"));
    postData.append( "&oauth_signature=" + QUrl::toPercentEncoding(buildPostSignature(requestUrl.url(), postData)));
    qDebug() << "POST DATA =====>>>>>> " << postData;
    requestUrl.setHeader(QNetworkRequest::ContentTypeHeader, "application/x-www-form-urlencoded");
    m_networkManager->post(requestUrl,postData);
}
