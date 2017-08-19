#include "requestor.h"
#include "userinfo.h"

#include <QJsonDocument>
#include <QJsonObject>
#include <QNetworkAccessManager>
#include <QNetworkRequest>

Requestor::Requestor(QObject *parent) : QObject(parent)
{
    m_networkManager = new QNetworkAccessManager();
    connect( m_networkManager, &QNetworkAccessManager::finished, this, &Requestor::onReplyFinished);
}

void Requestor::retrieveAccountInfo(QString token)
{

    QUrl uri("https://api.groundspeak.com/LiveV6/geocaching.svc//GetYourUserProfile?format=json");

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
    request.setHeader(QNetworkRequest::ContentTypeHeader, "application/json");
    qDebug() << QJsonDocument(parameters).toJson(QJsonDocument::Indented);
    QNetworkReply *reply = m_networkManager->post(request, QJsonDocument(parameters).toJson(QJsonDocument::Compact));
}

void Requestor::onReplyFinished(QNetworkReply *reply)
{

    QJsonDocument dataJsonDoc = QJsonDocument::fromJson(reply->readAll());

    if ( dataJsonDoc.isNull()) {

        UserInfo *info= new UserInfo("", 0, "", false, UserInfo::UserInfoStatus::Erreur);
        return;
            }

    QString name ;
    qint64 finds ;
    QString avatarUrl;
    QString premium;

    QJsonObject JsonObj= dataJsonDoc.object();
    QJsonObject obj1 = JsonObj["Profile"].toObject();
    QJsonObject obj2 = obj1["User"].toObject();
    QJsonObject obj3 = obj2["MemberType"].toObject();

    if (obj2.isEmpty()) {

        UserInfo *info=  new UserInfo("", 0, "", false, UserInfo::UserInfoStatus::Erreur);
        return   ;
    }

    name = obj2["UserName"].toString();
    finds =obj2["FindCount"].toInt();
    avatarUrl = obj2["AvatarUrl"].toString();
    premium = obj3["MemberTypeName"].toString();

    UserInfo *info= new UserInfo(name, finds, avatarUrl, premium, UserInfo::UserInfoStatus::Ok );
    qDebug() << "name:"<< info->getName();
    qDebug() << "finds:"<< info->getFinds();
    qDebug() << "avatarUrl:"<<info->getAvatarUrl();
    qDebug() << "premium:"<< info->getPremium();
     qDebug() << "status:"<< info->getStatus();
    return;
}
