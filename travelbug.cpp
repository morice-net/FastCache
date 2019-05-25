#include "travelbug.h"

Travelbug::Travelbug(QObject *parent)
    : QObject(parent)
    ,  m_name("")
    ,  m_type("")
    ,  m_tbCode("")
    ,  m_iconUrl("")
    ,  m_originalOwner("")
    ,  m_located("")
    ,  m_description("")
    ,  m_dateCreated("")
    ,  m_goal("")
    , m_imagesName(QList<QString>())
    , m_imagesDescription(QList<QString>())
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
    for (QJsonValue trackable: trackables)
    {
        if(trackable.toObject().value("Code").toString() == trackableCode) {
            setName(trackable.toObject().value("Name").toString());
            setType(trackable.toObject().value("TBTypeName").toString());
            setTbCode(trackable.toObject().value("Code").toString());

            QJsonValue owner = trackable["OriginalOwner"].toObject();
            setOriginalOwner(owner.toObject().value("UserName").toString());

            if(trackable.toObject().value("CurrentOwner").isNull() && trackable.toObject().value("CurrentGeocacheCode").isNull())
                setLocated("Inconnu");
            if (trackable.toObject().value("CurrentOwner").isNull()) {
                QJsonValue currentOwner = trackable["CurrentOwner"].toObject();
                setLocated("En possession de " + currentOwner.toObject().value("UserName").toString());
            }else {
                setLocated("Dans la cache " + trackable.toObject().value("CurrentGeocacheCode").toString());
            }

            setDateCreated(trackable.toObject().value("DateCreated").toString());
            setIconUrl(trackable.toObject().value("IconUrl").toString());
            setGoal(trackable.toObject().value("CurrentGoal").toString());
            setDescription(trackable.toObject().value("Description").toString());
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

QList<QString> Travelbug::imagesName() const
{
    return  m_imagesName;
}

void Travelbug::setImagesName(const QList<QString> &names)
{
    m_imagesName = names;
    emit imagesNameChanged();
}

QList<QString> Travelbug::imagesDescription() const
{
    return  m_imagesDescription;
}

void Travelbug::setImagesDescription(const QList<QString> &descriptions)
{
    m_imagesDescription = descriptions;
    emit imagesDescriptionChanged();
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
