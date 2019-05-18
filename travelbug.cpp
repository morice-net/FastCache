#include "travelbug.h"

Travelbug::Travelbug(QObject *parent)
    : QObject(parent)
    ,  m_name("")
    ,  m_type()
    ,  m_trackingCode("")
    ,  m_owner("")
    ,  m_located("")
    ,  m_origin("")
    ,  m_released("")
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

int Travelbug::type() const
{
    return m_type;
}

void Travelbug::setType(const int &type)
{
    m_type = type;
    emit typeChanged();
}

QString Travelbug::trackingCode() const
{
    return m_trackingCode;
}

void Travelbug::setTrackingCode(const QString &code)
{
    m_trackingCode = code;
    emit trackingCodeChanged();
}

QString Travelbug::owner() const
{
    return m_owner;
}

void Travelbug::setOwner(const QString &owner)
{
    m_owner = owner;
    emit ownerChanged();
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

QString Travelbug::origin() const
{
    return m_origin;
}

void Travelbug::setOrigin(const QString &origin)
{
    m_origin= origin;
    emit originChanged();
}

QString Travelbug::released() const
{
    return m_released;
}

void Travelbug::setReleased(const QString &release)
{
    m_released= release;
    emit releasedChanged();
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
