#include "gettravelbuguser.h"

#include <QNetworkAccessManager>
#include <QNetworkRequest>
#include <QJsonDocument>
#include <QJsonObject>
#include <QJsonArray>

GetTravelbugUser::GetTravelbugUser(Requestor *parent)
    : Requestor (parent)
    ,  m_tbsCode()
    ,  m_tbsName()
    ,  m_tbsIconUrl()
    ,  m_trackingNumbers()
{
}

void GetTravelbugUser::sendRequest(QString token)
{
    //Build url
    QString requestName = "trackables";
    requestName.append("?fields=name,referenceCode,iconUrl,trackingNumber");
    requestName.append("&take=50");

    // Inform QML we are loading
    setState("loading");
    Requestor::sendGetRequest(requestName,token);
}

void GetTravelbugUser::parseJson(const QJsonDocument &dataJsonDoc)
{
    m_tbsCode.clear();
    m_tbsName.clear();
    m_tbsIconUrl.clear();
    m_trackingNumbers.clear();

    QJsonArray  tbsJson = dataJsonDoc.array();
    qDebug() << "*** tbsUser**\n" << tbsJson;

    int lengthTbs = tbsJson.size();
    if (lengthTbs == 0) {
        return ;
    }

    foreach ( const QJsonValue & tbJson, tbsJson)
    {
        m_tbsCode.append(tbJson["referenceCode"].toString());
        m_tbsName.append(tbJson["name"].toString());
        m_tbsIconUrl.append(tbJson["iconUrl"].toString());
        m_trackingNumbers.append(tbJson["trackingNumber"].toString());
    }
    emit tbsCodeChanged();
    emit tbsNameChanged();
    emit tbsIconUrlChanged();
    emit trackingNumbersChanged();

    qDebug() << "*** tbsCode**\n" << m_tbsCode;
    return ;
}

GetTravelbugUser::~GetTravelbugUser()
{
}

/** Getters & Setters **/

QList<QString> GetTravelbugUser::tbsCode() const
{
    return m_tbsCode;
}

void GetTravelbugUser::setTbsCode(const QList<QString> &codes)
{
    m_tbsCode = codes;
    emit tbsCodeChanged();
}

QList<QString> GetTravelbugUser::tbsName() const
{
    return m_tbsName;
}

void GetTravelbugUser::setTbsName(const QList<QString> &names)
{
    m_tbsName = names;
    emit tbsNameChanged();
}

QList<QString> GetTravelbugUser::tbsIconUrl() const
{
    return m_tbsIconUrl;
}

void GetTravelbugUser::setTbsIconUrl(const QList<QString> &icons)
{
    m_tbsIconUrl = icons;
    emit tbsIconUrlChanged();
}

QList<QString> GetTravelbugUser::trackingNumbers() const
{
    return m_trackingNumbers;
}

void GetTravelbugUser::setTrackingNumbers(const QList<QString> &trackings)
{
    m_trackingNumbers = trackings;
    emit trackingNumbersChanged();
}
