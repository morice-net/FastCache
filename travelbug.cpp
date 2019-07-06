#include "travelbug.h"
#include "smileygc.h"

Travelbug::Travelbug(QObject *parent)
    : QObject(parent)
    ,  m_name("")
    ,  m_type("")
    ,  m_tbCode("")
    ,  m_iconUrl("")
    ,  m_originalOwner("")
    ,  m_located("")
    ,  m_description("")
    ,  m_originCountry("")
    ,  m_goal("")
    ,  m_dateCreated("")
    , m_imagesName(QList<QString>())
    , m_imagesUrl(QList<QString>())
    , m_logs(QList<QString>())
    , m_logsType(QList<QString>())

{
}

Travelbug::~Travelbug()
{
}

void Travelbug::parseTrackable(QString trackableCode , QJsonArray trackables)
{
    SmileyGc * smileys = new SmileyGc;

    for (QJsonValue trackable: trackables)
    {
        if(trackable["referenceCode"].toString() == trackableCode) {
            setName(trackable["name"].toString());
            setTbCode(trackable["referenceCode"].toString());

            QJsonObject  tbType = trackable["trackableType"].toObject();
            setType(tbType["name"].toString());

            QJsonObject owner = trackable["owner"].toObject();
            setOriginalOwner(owner["username"].toString());

            if(trackable["isMissing"].toBool())
                setLocated("Inconnu");
            else if (trackable["inHolderCollection"].toBool()) {
                QJsonObject currentOwner = trackable["holder"].toObject();
                setLocated("En possession de " + currentOwner["username"].toString());
            } else if(!trackable["inHolderCollection"].toBool()){
                setLocated("Dans la cache " + trackable["currentGeocacheCode"].toString());
            }

            setDateCreated(trackable["releasedDate"].toString());
            setIconUrl(trackable["iconUrl"].toString());
            setGoal(trackable["goal"].toString());
            setOriginCountry(trackable["originCountry"].toString());
            setDescription(trackable["description"].toString());

            //images
            m_imagesName.clear();
            m_imagesUrl.clear();

            for (QJsonValue image: trackable["images"].toArray())
            {
                m_imagesName.append(smileys->replaceSmileyTextToImgSrc(image["description"].toString()));
                m_imagesUrl.append(image["url"].toString());
            }
            emit imagesNameChanged();
            emit imagesUrlChanged();
            return ;
        }
    }
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
