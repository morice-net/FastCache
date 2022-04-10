#include "userinfo.h"

#include <QJsonDocument>
#include <QJsonObject>

UserInfo::UserInfo(Requestor *parent)
    : Requestor (parent)
    , m_name("")
    , m_finds(0)
    , m_avatarUrl("")
    , m_premium("")
    , m_status(UserInfoStatus::Erreur)

{
}

UserInfo::~UserInfo()
{
}

/** Data retriever using the requestor **/

void UserInfo::sendRequest(QString token, GetTravelbugUser* tbGetter)
{
    m_status = UserInfoStatus::Connection;
    Requestor::sendGetRequest("users/me?fields=username,findCount,avatarUrl,membershipLevelId" , token);

    m_token = token;
    m_tbGetter = tbGetter;
}

void UserInfo::parseJson(const QJsonDocument &dataJsonDoc)
{    
    QJsonObject userInfoJson = dataJsonDoc.object();
    qDebug() << "userInfoJson:" << userInfoJson ;
    m_name = userInfoJson["username"].toString();
    m_finds = userInfoJson["findCount"].toInt();
    m_avatarUrl = userInfoJson["avatarUrl"].toString();

    switch(userInfoJson["membershipLevelId"].toInt()){
    case 0:
        m_premium = "Inconnu";
        break;
    case 1:
        m_premium = "Basic";
        break;
    case 2:
        m_premium = "Charter";
        break;
    case 3:
        m_premium = "Premium";
        break;
    default:
        break;
    }
    m_status = UserInfoStatus::Ok;

    qDebug() << "name:" << m_name;
    qDebug() << "finds:" << m_finds;
    qDebug() << "avatarUrl:" << m_avatarUrl;
    qDebug() << "premium:" << m_premium;
    qDebug() << "status:" << m_status;

    emit nameChanged();
    emit findsChanged();
    emit avatarUrlChanged();
    emit premiumChanged();

    // now we have user info, we need to find the user tb list
    m_tbGetter->sendRequest(m_token);
}

/** Getters & Setters **/

QString UserInfo::name() const
{
    return m_name;
}

void UserInfo::setName(QString &name)
{
    m_name = name;
    emit nameChanged();
}

int UserInfo::finds() const
{
    return m_finds;
}

void UserInfo::setFinds(int &finds)
{
    m_finds = finds;
    emit findsChanged();
}


QString UserInfo::avatarUrl() const
{
    return m_avatarUrl;
}
void UserInfo::setAvatarUrl(QString &avatarUrl)
{
    m_avatarUrl = avatarUrl;
    emit avatarUrlChanged();
}

QString UserInfo::premium() const
{
    return m_premium;
}

void UserInfo::setPremium( QString &premium)
{
    m_premium = premium;
    emit premiumChanged();
}

UserInfo::UserInfoStatus  UserInfo::status() const
{
    return m_status;
}

void UserInfo::setStatus(UserInfo::UserInfoStatus  &status)
{
    m_status = status;
}
