#include "travelbug.h"
#include "smileygc.h"

Travelbug::Travelbug(Requestor *parent)
    :  Requestor(parent)
    ,  m_name("")
    ,  m_type("")
    ,  m_tbCode("")
    ,  m_iconUrl("")
    ,  m_originalOwner("")
    ,  m_located("")
    ,  m_description("")
    ,  m_originCountry("")
    ,  m_dateCreated("")
    ,  m_goal("")
    , m_imagesName(QList<QString>())
    , m_imagesUrl(QList<QString>())
    , m_logs(QList<QString>())
    , m_logsType(QList<QString>())
{
}

Travelbug::~Travelbug()
{
}

void Travelbug::sendRequest(QString token ,QString trackableCode)
{
    //Build url
    QString requestName = "trackables/";
    requestName.append(trackableCode);

    // Fields
    requestName.append("?fields=referenceCode,name,iconUrl,goal,description,releasedDate,originCountry,ownerCode,holderCode,inHolderCollection,"
                       "currentGeocacheCode,currentGeocacheName,isMissing,trackingNumber,trackableType,owner,holder" );
    // Expand
    requestName.append("&expand=trackablelogs:" + QString::number(TRACKABLE_LOGS_COUNT) + ",images:" + QString::number(IMAGES));

    qDebug() << "URL:" << requestName ;

    // Inform QML we are loading
    setState("loading");

    Requestor::sendGetRequest(requestName , token);
}

void Travelbug::parseJson(const QJsonDocument &dataJsonDoc)
{
    QJsonObject tbJson = dataJsonDoc.object();
    qDebug() << "tbJson:" << tbJson;

    SmileyGc * smileys = new SmileyGc;

    setName(tbJson["name"].toString());
    setTbCode(tbJson["referenceCode"].toString());

    QJsonObject  tbType = tbJson["trackableType"].toObject();
    setType(tbType["name"].toString());

    QJsonObject owner = tbJson["owner"].toObject();
    setOriginalOwner(owner["username"].toString());

    if(tbJson["isMissing"].toBool())
        setLocated("Inconnu");
    else if (tbJson["inHolderCollection"].toBool()) {
        QJsonObject currentOwner = tbJson["holder"].toObject();
        setLocated("En possession de " + currentOwner["username"].toString());
    } else if(!tbJson["inHolderCollection"].toBool()){
        setLocated("Dans la cache " + tbJson["currentGeocacheCode"].toString());
    }

    setDateCreated(tbJson["releasedDate"].toString());
    setIconUrl(tbJson["iconUrl"].toString());
    setGoal(tbJson["goal"].toString());
    setOriginCountry(tbJson["originCountry"].toString());
    setDescription(tbJson["description"].toString());

    //images
    m_imagesName.clear();
    m_imagesUrl.clear();

    for (QJsonValue image: tbJson["images"].toArray())
    {
        m_imagesName.append(smileys->replaceSmileyTextToImgSrc(image["description"].toString()));
        m_imagesUrl.append(image["url"].toString());
    }
    emit imagesNameChanged();
    emit imagesUrlChanged();

    // request success
    emit requestReady();
    return ;
}

/** Getters & Setters **/

QString Travelbug::name() const
{
    return m_name;
}

void Travelbug::setName(const QString &name)
{
    m_name = name;
    emit nameChanged();
}

QString Travelbug::type() const
{
    return m_type;
}

void Travelbug::setType(const QString &type)
{
    m_type = type;
    emit typeChanged();
}

QString Travelbug::tbCode() const
{
    return m_tbCode;
}

void Travelbug::setTbCode(const QString &code)
{
    m_tbCode = code;
    emit tbCodeChanged();
}

QString Travelbug::iconUrl() const
{
    return m_iconUrl;
}

void Travelbug::setIconUrl(const QString &url)
{
    m_iconUrl = url;
    emit iconUrlChanged();
}

QString Travelbug::originalOwner() const
{
    return m_originalOwner;
}

void Travelbug::setOriginalOwner(const QString &owner)
{
    m_originalOwner = owner;
    emit originalOwnerChanged();
}

QString Travelbug::located() const
{
    return m_located;
}

void Travelbug::setLocated(const QString &location)
{
    m_located = location;
    emit locatedChanged();
}

QString Travelbug::description () const
{
    return m_description;
}

void Travelbug::setDescription(const QString &description)
{
    m_description= description;
    emit descriptionChanged();
}

QString Travelbug::dateCreated() const
{
    return m_dateCreated;
}

void Travelbug::setDateCreated(const QString &date)
{
    m_dateCreated= date;
    emit dateCreatedChanged();
}

QString Travelbug::goal() const
{
    return m_goal;
}

void Travelbug::setGoal(const QString &goal)
{
    m_goal= goal;
    emit goalChanged();
}

QString Travelbug::originCountry() const
{
    return m_originCountry;
}

void Travelbug::setOriginCountry(const QString &country)
{
    m_originCountry= country;
    emit originCountryChanged();
}

QList<QString> Travelbug::imagesName() const
{
    return  m_imagesName;
}

void Travelbug::setImagesName(const QList<QString> &names)
{
    m_imagesName = names;
    emit imagesNameChanged();
}

QList<QString>Travelbug::imagesUrl() const
{
    return  m_imagesUrl;
}

void Travelbug::setImagesUrl(const QList<QString> &urls)
{
    m_imagesUrl = urls;
    emit imagesUrlChanged();
}

QList<QString>Travelbug::logs() const
{
    return  m_logs;
}

void Travelbug::setLogs(const QList<QString> &logs)
{
    m_logs = logs;
    emit logsChanged();
}

QList<QString>Travelbug::logsType() const
{
    return  m_logsType;
}

void Travelbug::setLogsType(const QList<QString> &types)
{
    m_logsType = types;
    emit logsTypeChanged();
}
