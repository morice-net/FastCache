#include "getgeocachelogimages.h"

#include <QJsonArray>
#include <QJsonObject>

GetGeocacheLogImages::GetGeocacheLogImages(Requestor *parent)
    : Requestor (parent)
    , m_descriptions()
    , m_urls()
    , m_guids()
{
}

GetGeocacheLogImages:: ~GetGeocacheLogImages()
{
}

void GetGeocacheLogImages::sendRequest(QString token , QString referenceCode)
{
    // empty lists
    setDescriptions(QStringList());
    setUrls(QStringList());
    setGuids(QStringList());

    //Build url
    QString requestName = "geocachelogs/";
    requestName.append(referenceCode + "/images");
    requestName.append("?fields=referenceCode,description,url,guid");
    requestName.append("&take=50");

    // Inform QML we are loading
    setState("loading");
    Requestor::sendGetRequest(requestName,token);
}

void GetGeocacheLogImages::parseJson(const QJsonDocument &dataJsonDoc)
{
    QJsonArray  logImages = dataJsonDoc.array();
    qDebug() << "*** log images**\n" << logImages;

    if (logImages.size() == 0) {
        emit requestReady();
        return ;
    }

    foreach ( const QJsonValue & logImage, logImages)
    {
        m_descriptions.append(logImage["description"].toString());
        m_urls.append(logImage["url"].toString());
        m_guids.append(logImage["guid"].toString());
    }

    emit descriptionsChanged();
    emit urlsChanged();
    emit guidsChanged();

    qDebug() << "*** descriptions**\n" << m_descriptions;
    qDebug() << "*** urls**\n" << m_urls;
    qDebug() << "*** guids**\n" << m_guids;

    // request success
    emit requestReady();
    return ;
}

/** Getters & Setters **/

QList<QString> GetGeocacheLogImages::descriptions() const
{
    return m_descriptions;
}

void GetGeocacheLogImages::setDescriptions(const QList<QString> &descriptions)
{
    m_descriptions = descriptions;
    emit descriptionsChanged();
}

QList<QString> GetGeocacheLogImages::urls() const
{
    return m_urls;
}

void GetGeocacheLogImages::setUrls(const QList<QString> &urls)
{
    m_urls = urls;
    emit urlsChanged();
}

QList<QString> GetGeocacheLogImages::guids() const
{
    return m_guids;
}

void GetGeocacheLogImages::setGuids(const QList<QString> &guids)
{
    m_guids = guids;
    emit guidsChanged();
}






