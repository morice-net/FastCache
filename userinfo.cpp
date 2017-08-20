#include "userinfo.h"

UserInfo::UserInfo(QString name, qint64 finds, QString avatarUrl, QString premium ,UserInfoStatus status , QObject *parent) : QObject(parent)
{
    m_name = name;
    m_finds = finds;
    m_avatarUrl = avatarUrl;
    m_premium = premium;
    m_status = status;
}

UserInfo::~UserInfo()
{
}


QString UserInfo::name() const {
    return m_name;
}

void UserInfo::setName(QString &name) {
    m_name = name;
    emit nameChanged();
}

int UserInfo::finds() const {
    return m_finds;
}

void UserInfo::setFinds(int &finds) {
    m_finds = finds;
    emit findsChanged();
}


QString UserInfo::avatarUrl() const {
    return m_avatarUrl;
}
void UserInfo::setAvatarUrl(QString &avatarUrl) {
    m_avatarUrl = avatarUrl;
}

QString UserInfo::premium() const {
    return m_premium;
}

void UserInfo::setPremium( QString &premium) {
    m_premium = premium;
}

UserInfo::UserInfoStatus  UserInfo::status() const{
    return m_status;
}

void UserInfo::setStatus(UserInfo::UserInfoStatus  &status) {
    m_status = status;
}
