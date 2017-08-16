#include "requestor.h"

#include <QJsonDocument>
#include <QJsonObject>
#include <QNetworkAccessManager>
#include <QNetworkRequest>

Requestor::Requestor(QObject *parent) : QObject(parent)
{

}

void Requestor::retrieveAccountInfo(QString token)
{
    QNetworkAccessManager networkManager;
        connect( &networkManager, &QNetworkAccessManager::finished, this, &Requestor::onReplyFinished);

        QUrl uri("https://staging.api.groundspeak.com/Live/V6Beta/geocaching.svc/GetYourUserProfile?format=json");

        QJsonObject parameters;
        QJsonObject ProfileOptions;
        QJsonObject DeviceInfo;

        parameters.insert("AccessToken", QJsonValue(token));

        ProfileOptions.insert("ChallengesData", QJsonValue(false));
        ProfileOptions.insert("FavoritePointsData", QJsonValue(false));
        ProfileOptions.insert("GeocacheData", QJsonValue(false));
        ProfileOptions.insert("PublicProfileData", QJsonValue(false));
        ProfileOptions.insert("SouvenirData", QJsonValue(false));
        ProfileOptions.insert("TrackableData", QJsonValue(false));
        parameters.insert("ProfileOptions", ProfileOptions);

        DeviceInfo.insert("ApplicationCurrentMemoryUsage", QJsonValue(0));
        DeviceInfo.insert("ApplicationPeakMemoryUsage", QJsonValue(0));
        DeviceInfo.insert("ApplicationSoftwareVersion", QJsonValue("Unknown"));
        DeviceInfo.insert("DeviceManufacturer", QJsonValue("Unknown"));
        DeviceInfo.insert("DeviceName", QJsonValue("Unknown"));
        DeviceInfo.insert("DeviceOperatingSystem", QJsonValue("Unknown"));
        DeviceInfo.insert("DeviceTotalMemoryInMB", QJsonValue(0));
        DeviceInfo.insert("DeviceUniqueId", QJsonValue("Unknown"));
        DeviceInfo.insert("MobileHardwareVersion", QJsonValue("Unknown"));
        DeviceInfo.insert("WebBrowserVersion", QJsonValue("Unknown"));
        parameters.insert("DeviceInfo", DeviceInfo);

        QNetworkRequest request;
        request.setUrl(uri);
        networkManager.post(request, QJsonDocument(parameters).toJson(QJsonDocument::Compact));
}

void Requestor::onReplyFinished(QNetworkReply *reply)
{
    qDebug() << "retrieveAccountInfo " << reply->readAll();
}
