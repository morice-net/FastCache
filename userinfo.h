#ifndef USERINFO_H
#define USERINFO_H
#include <QObject>


class UserInfo : public QObject
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

    explicit  UserInfo(QString m_name, qint64 m_finds, QString m_avatarUrl, QString m_premium , UserInfoStatus status, QObject *parent = 0);
    ~UserInfo();

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
};
#endif // USERINFO_H
