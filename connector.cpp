#include "connector.h"

#include <QDebug>
#include <QNetworkAccessManager>

Connector::Connector(QObject *parent) : QObject(parent), m_consumerKey("90C7F340-7998-477D-B4D3-AC48A9A0F560"), m_consumerSecret("55BBC3C1-24CF-4D1B-B7EC-7A8E75DAB7D1")
{
}

void Connector::onConnect(QString login, QString pass)
{
    qDebug() << "Component connect:" <<  login << pass;
    QNetworkAccessManager *manager = new QNetworkAccessManager(this);
    connect(manager, SIGNAL(finished(QNetworkReply*)),
            this, SLOT(replyFinished(QNetworkReply*)));

    // Building request
    m_requestString = "https://www.geocaching.com/oauth/mobileoauth.ashx?";

    QString callback = "x-locus://oauth.callback/callback/geocaching";
    addGetParam("oauth_callback", callback, true);

    //addGetParam("consumerSecret", m_consumerSecret);

    addGetParam("oauth_consumer_key", m_consumerKey);

    qlonglong nonceNumber = qrand() * 100000000000000000000000 + qrand() * 10000000000000000 + qrand() * 100000000 + qrand();
    QString nonce = QString::number( nonceNumber );

    qDebug() << "#############" << nonce << nonceNumber;
    addGetParam("oauth_nonce", nonce/*"8bbf43b453f89a860c6107082fd18618"QString::number(encoded.toLong())*/);

    addGetParam("oauth_signature_method", "HMAC-SHA1");

    QString oauthTimestamap = QString::number(QDateTime::currentDateTimeUtc().toTime_t());
    addGetParam("oauth_timestamp", oauthTimestamap);

    addGetParam("oauth_version", "1.0");

    QString oauthSignature = buildSignature(m_requestString);
    qDebug() << oauthSignature;
    addGetParam("oauth_signature", oauthSignature);

    QNetworkRequest request;
    qDebug() << m_requestString;
    request.setUrl(QUrl(m_requestString));
    manager->get(request);
}

void Connector::replyFinished(QNetworkReply *reply)
{
    if (reply->error() == QNetworkReply::NoError) {
        qDebug() << QByteArray::fromPercentEncoding(reply->readAll());
    } else {
        qDebug() << reply->errorString();
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

QString Connector::buildSignature(QString request)
{
    QString keysPacked = QUrl::toPercentEncoding(m_consumerSecret) + "&" + QUrl::toPercentEncoding(m_tokenSecret);
    int position = request.indexOf("?");

    QStringList paramsEncoded;
    foreach (Parameter *param, m_parameters) {

        qDebug() << param->name() << "=" << param->value();
        if (param->encoded()) {
            paramsEncoded.append(param->name() + "=" + param->value());
        } else {
            paramsEncoded.append(param->name() + "=" + QUrl::toPercentEncoding(param->value()));
        }
    }
    QString joinedParams = paramsEncoded.join("&");
    QString url = request.left(position);
    QString encodedUrl = "GET&" + QUrl::toPercentEncoding(url) + "&" + QUrl::toPercentEncoding(joinedParams);

    QString signature = hmacSha1(keysPacked.toUtf8(),encodedUrl.toUtf8());

    return QString(QUrl::toPercentEncoding(signature));
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

