#include "userinfo.h"

UserInfo::UserInfo(QString name, qint64 finds, QString avatarUrl, QString premium ,UserInfoStatus status , QObject *parent) : QObject(parent)
{
            this->name = name;
            this->finds = finds;
            this->avatarUrl = avatarUrl;
            this->premium = premium;
            this->status = status;
}

UserInfo::~UserInfo()
{
}


  QString UserInfo::getName() const {
        return name;
    }

  void UserInfo::setName( QString &name) {
     this->name = name;
 }

   qint64 UserInfo::getFinds() const {
        return finds;
    }

     void UserInfo::setFinds( qint64 &finds) {
        this->finds = finds;
    }


    QString UserInfo::getAvatarUrl() const {
        return avatarUrl;
    }
    void UserInfo::setAvatarUrl( QString &avatarUrl) {
       this->avatarUrl = avatarUrl;
   }

    QString UserInfo::getPremium() const {
        return premium;
    }

    void UserInfo::setPremium( QString &premium) {
       this->premium = premium;
   }

     UserInfo::UserInfoStatus  UserInfo::getStatus() const{
        return status;
    }
     void UserInfo::setStatus(UserInfo::UserInfoStatus  &status) {
        this->status = status;
    }
