#pragma once

#include <QString>

class AppConfig
{
public:
    static void load();

    static QString googleTranslateApiKey();
    static QString googleMapsApiKey();
    static QString googleGeocodeApiKey();

    static QString consumerKey();
    static QString consumerSecret();
    static QString redirectUri();

private:
    static QString m_googleTranslateApiKey;
    static QString m_googleMapsApiKey;
    static QString m_googleGeocodeApiKey;

    static QString m_consumerKey;
    static QString m_consumerSecret;
    static QString m_redirectUri;
};
