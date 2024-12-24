#ifndef GETTRAVELBUGUSER_H
#define GETTRAVELBUGUSER_H

#include "requestor.h"

#include <QNetworkReply>
#include <QObject>
#include <QtQml>

class GetTravelbugUser : public Requestor
{
    Q_OBJECT
    QML_ELEMENT

    Q_PROPERTY(QList<QString> tbsCode READ tbsCode WRITE setTbsCode NOTIFY tbsCodeChanged)
    Q_PROPERTY(QList<QString> tbsName READ tbsName WRITE setTbsName NOTIFY tbsNameChanged)
    Q_PROPERTY(QList<QString> tbsIconUrl READ tbsIconUrl WRITE setTbsIconUrl NOTIFY tbsIconUrlChanged)
    Q_PROPERTY(QList<QString> trackingNumbers READ trackingNumbers WRITE setTrackingNumbers NOTIFY trackingNumbersChanged)

public:
    explicit  GetTravelbugUser(Requestor *parent = nullptr);
    ~GetTravelbugUser() override;

    QList<QString> tbsCode() const;
    void setTbsCode(const QList<QString> &codes);

    QList<QString> tbsName() const;
    void setTbsName(const QList<QString> &names);

    QList<QString> tbsIconUrl() const;
    void setTbsIconUrl(const QList<QString> &icons);

    QList<QString> trackingNumbers() const;
    void setTrackingNumbers(const QList<QString> &trackings);

    Q_INVOKABLE void sendRequest(QString token);

    void parseJson(const QJsonDocument &dataJsonDoc) override;

signals:
    void tbsCodeChanged() ;
    void tbsNameChanged() ;
    void tbsIconUrlChanged() ;
    void trackingNumbersChanged() ;

private:
    QList<QString> m_tbsCode ;
    QList<QString> m_tbsName ;
    QList<QString> m_tbsIconUrl ;
    QList<QString> m_trackingNumbers ;

};

#endif // GETTRAVELBUGUSER_H
