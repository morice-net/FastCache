#ifndef USERINFO_H
#define USERINFO_H
#include <QObject>


class UserInfo : public QObject
{
    Q_OBJECT
    Q_ENUMS(UserInfoStatus)

public:
    enum UserInfoStatus { Connection, Ok, Erreur };   

    explicit  UserInfo(QString name, qint64 finds, QString avatarUrl, QString premium , UserInfoStatus status, QObject *parent = 0);
    ~UserInfo();

    QString getName() const;
    void  setName(QString &name);
    qint64  getFinds()const;
    void    setFinds( qint64 &finds);
    QString getAvatarUrl()const ;
    void    setAvatarUrl( QString &avatarUrl);
    QString getPremium()const;
    void    setPremium( QString &avatarUrl);
    UserInfoStatus getStatus()const;
    void    setStatus( UserInfo::UserInfoStatus &status);

private:
    QString name;
    qint64 finds;
    QString avatarUrl;
    QString premium;
    UserInfoStatus status;
};
#endif // USERINFO_H
