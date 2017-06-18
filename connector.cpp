#include "connector.h"

#include <QDebug>
#include <QNetworkAccessManager>
#include <QMessageAuthenticationCode>

Connector::Connector(QObject *parent) : QObject(parent), m_consumerKey("CF2B186B-0DD2-4E45-93B1-FAD7DF5593D4"), m_consumerSecret("7D0E212A-ADF8-4798-906E-9E6099B68E79")
{
}

void Connector::onConnect()
{
    qDebug() << "Component connect.";
    QNetworkAccessManager *manager = new QNetworkAccessManager(this);
    connect(manager, SIGNAL(finished(QNetworkReply*)),
            this, SLOT(replyFinished(QNetworkReply*)));

    // Building request
    QString callback = "x-locus://oauth.callback/callback/geocaching";
    addGetParam("oauth_callback", callback, true);
    addGetParam("oauth_consumer_key", m_consumerKey);
    QString oauthTimestamp = QString::number(QDateTime::currentMSecsSinceEpoch());
    // QString::number(QDateTime::currentDateTimeUtc().toTime_t()).toLatin1();
    addGetParam("oauth_nonce", nonce());
    addGetParam("oauth_signature_method", "HMAC-SHA1");
    addGetParam("oauth_timestamp", oauthTimestamp);
    addGetParam("oauth_version", "1.0");

    m_requestString = "https://www.geocaching.com/oauth/mobileoauth.ashx?" + joinParams();

    qSort(m_parameters);
    QString oauthSignature = buildSignature(m_requestString);
    addGetParam("oauth_signature", oauthSignature, true);

    QNetworkRequest request;
    qDebug() << "request string" << m_requestString;
    request.setUrl(QUrl(m_requestString));
    manager->get(request);
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
                    Parameter *param = new Parameter();
                    param->setName(paramName);
                    param->setValue(paramValue);
                    m_parameters << param;
                    m_tokenKey = paramValue;
                } else if (paramName == "oauth_token_secret") {
                    Parameter *param = new Parameter();
                    param->setName(paramName);
                    param->setValue(paramValue);
                    m_parameters << param;
                    m_tokenSecret = paramValue;
                }
            } else {
                qWarning() << "A param is malformed" << param;
            }
        }

    } else {
        qDebug() << "Connection in error:" << reply->errorString();
    }
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
    qDebug() <<" ------ JOINED PARAMS -----";
    foreach (Parameter *param, m_parameters) {
        qDebug() << "\t*" << param->name() << "=" << param->value();
        paramsEncoded << param->name() + "=" + param->value();
    }
    return paramsEncoded.join("&");
}

QByteArray Connector::buildSignature(const QString& request)
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

QByteArray Connector::nonce()
{
    QString u = QString::number(QDateTime::currentMSecsSinceEpoch());
    return QCryptographicHash::hash(u.toLatin1(), QCryptographicHash::Md5).toHex();

}

