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

void UserInfo::sendRequest(QString token)
{
    m_status = UserInfoStatus::Connection;
    Requestor::sendGetRequest("users?referenceCode=me" , token);
}

void UserInfo::parseJson(const QJsonDocument &dataJsonDoc)
{
    QJsonObject JsonObj = dataJsonDoc.object();
    QJsonObject obj1 = JsonObj["Profile"].toObject();
    QJsonObject obj2 = obj1["User"].toObject();
    QJsonObject obj3 = obj2["MemberType"].toObject();

    if (obj2.isEmpty()) {
        return;
    }

    m_name = obj2["UserName"].toString();
    m_finds = obj2["FindCount"].toInt();
    m_avatarUrl = obj2["AvatarUrl"].toString();
    m_premium = obj3["MemberTypeName"].toString();
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

    // request success
    emit requestReady();
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
