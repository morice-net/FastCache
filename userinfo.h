#ifndef USERINFO_H
#define USERINFO_H

#include "requestor.h"
#include"gettravelbuguser.h"

class UserInfo : public Requestor
{
    Q_OBJECT
    Q_ENUMS(UserInfoStatus)

    Q_PROPERTY(QString name READ name WRITE setName NOTIFY nameChanged)
    Q_PROPERTY(int finds READ finds WRITE setFinds NOTIFY findsChanged)
    Q_PROPERTY(QString avatarUrl READ avatarUrl WRITE setAvatarUrl NOTIFY avatarUrlChanged)
    Q_PROPERTY(QString premium READ premium WRITE setPremium NOTIFY premiumChanged)

public:
    enum UserInfoStatus {
        Connection,
        Ok,
        Erreur
    };

    explicit  UserInfo(Requestor *parent = nullptr);
    ~UserInfo() override;

    Q_INVOKABLE void sendRequest(QString token, GetTravelbugUser* tbGetter);
    void parseJson(const QJsonDocument &dataJsonDoc) override;

    QString name() const;
    void  setName(QString &m_name);

    int  finds()const;
    void    setFinds(int &m_finds);

    QString avatarUrl()const ;
    void    setAvatarUrl(QString &m_avatarUrl);

    QString premium()const;
    void    setPremium(QString &m_avatarUrl);

    UserInfoStatus status()const;
    void    setStatus(UserInfo::UserInfoStatus &status);

signals:
    void nameChanged();
    void findsChanged();
    void avatarUrlChanged();
    void premiumChanged();

private:
    QString m_name;
    qint64 m_finds;
    QString m_avatarUrl;
    QString m_premium;
    UserInfoStatus m_status;

    QString m_token;
    GetTravelbugUser* m_tbGetter;
};
#endif // USERINFO_H
