#include "appconfig.h"
#include <QCoreApplication>
#include <QFile>
#include <QJsonDocument>
#include <QJsonObject>
#include <QDebug>
#include <QStandardPaths>

QString AppConfig::m_googleTranslateApiKey;
QString AppConfig::m_googleMapsApiKey;
QString AppConfig::m_googleGeocodeApiKey;
QString AppConfig::m_consumerKey;
QString AppConfig::m_consumerSecret;
QString AppConfig::m_redirectUri;

void AppConfig::load()
{
#ifdef Q_OS_ANDROID
    QFile file("assets:/config.json");
#else
    QFile file(QCoreApplication::applicationDirPath() + "/config.json");
#endif
    if (!file.open(QIODevice::ReadOnly)) {
        qWarning() << "config.json not found";
        return;
    }
    QJsonDocument doc = QJsonDocument::fromJson(file.readAll());
    QJsonObject obj = doc.object();

    m_googleTranslateApiKey = obj["google_translate_api_key"].toString();
    m_googleMapsApiKey = obj["google_maps_api_key"].toString();
    m_googleGeocodeApiKey = obj["google_geocode_api_key"].toString();

    m_consumerKey = obj["consumer_key"].toString();
    m_consumerSecret = obj["consumer_secret"].toString();
    m_redirectUri = obj["redirect_uri"].toString();
}

QString AppConfig::googleTranslateApiKey() { return m_googleTranslateApiKey; }
QString AppConfig::googleMapsApiKey() { return m_googleMapsApiKey; }
QString AppConfig::googleGeocodeApiKey() { return m_googleGeocodeApiKey; }

QString AppConfig::consumerKey() { return m_consumerKey; }
QString AppConfig::consumerSecret() { return m_consumerSecret; }
QString AppConfig::redirectUri() { return m_redirectUri; }
