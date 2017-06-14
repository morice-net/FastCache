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
    addGetParam("oauth_callback", callback);
    addGetParam("oauth_consumer_key", m_consumerKey);
    addGetParam("oauth_nonce", nonce());
    QString oauthTimestamap = QString::number(QDateTime::currentDateTimeUtc().toTime_t());
    addGetParam("oauth_timestamp", oauthTimestamap);
    addGetParam("oauth_version", "1.0");
    addGetParam("oauth_signature_method", "HMAC-SHA1");

    m_requestString = "https://www.geocaching.com/oauth/mobileoauth.ashx?";
    QString oauthSignature = buildSignature(m_requestString);
    addGetParam("oauth_signature", oauthSignature);

    QNetworkRequest request;
    qDebug() << m_requestString;
    request.setUrl(QUrl(m_requestString));
    manager->get(request);
}

void Connector::replyFinished(QNetworkReply *reply)
{
    if (reply->error() == QNetworkReply::NoError) {
        QString returns = QUrl::fromPercentEncoding(reply->readAll());
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

QByteArray Connector::buildSignature(QString request)
{
    int position = request.indexOf("?");

    QStringList paramsEncoded;
    foreach (Parameter *param, m_parameters) {
        qDebug() << "\t*" << param->name() << "=" << param->value();
        if (param->encoded()) {
            paramsEncoded.append(param->name() + "=" + param->value());
        } else {
            paramsEncoded.append(param->name() + "=" + QUrl::toPercentEncoding(param->value()));
        }
    }

    QString joinedParams = paramsEncoded.join("&");
    QUrl url(request.left(position));
    QString keysPacked = QUrl::toPercentEncoding(m_consumerSecret) + "&" + QUrl::toPercentEncoding(m_tokenSecret);
    QString baseString = "GET&" + QUrl::toPercentEncoding(url.toString(QUrl::RemoveQuery)) + "&" + joinedParams;

    return QMessageAuthenticationCode::hash(baseString.toUtf8(), keysPacked.toUtf8(), QCryptographicHash::Sha1).toBase64();
}

QString Connector::hmacSha1(QByteArray key, QByteArray baseString)
{
    int blockSize = 64; // HMAC-SHA-1 block size, defined in SHA-1 standard
    if (key.length() > blockSize) { // if key is longer than block size (64), reduce key length with SHA-1 compression
        key = QCryptographicHash::hash(key, QCryptographicHash::Sha1);
    }

    QByteArray innerPadding(blockSize, char(0x36)); // initialize inner padding with char "6"
    QByteArray outerPadding(blockSize, char(0x5c)); // initialize outer padding with char "quot;
    // ascii characters 0x36 ("6") and 0x5c ("quot;) are selected because they have large
    // Hamming distance (http://en.wikipedia.org/wiki/Hamming_distance)

    for (int i = 0; i < key.length(); i++) {
        innerPadding[i] = innerPadding[i] ^ key.at(i); // XOR operation between every byte in key and innerpadding, of key length
        outerPadding[i] = outerPadding[i] ^ key.at(i); // XOR operation between every byte in key and outerpadding, of key length
    }

    // result = hash ( outerPadding CONCAT hash ( innerPadding CONCAT baseString ) ).toBase64
    QByteArray total = outerPadding;
    QByteArray part = innerPadding;
    part.append(baseString);
    total.append(QCryptographicHash::hash(part, QCryptographicHash::Sha1));
    QByteArray hashed = QCryptographicHash::hash(total, QCryptographicHash::Sha1);
    return hashed.toBase64();
}

QByteArray Connector::nonce()
{
    static bool firstTime = true;
    if (firstTime) {
        firstTime = false;
        qsrand(QTime::currentTime().msec());
    }
    QString u = QString::number(QDateTime::currentDateTimeUtc().toTime_t());
    u.append(QString::number(qrand()));
    return u.toLatin1();
}

