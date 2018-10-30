#include "waypointtype.h"

WaypointType::WaypointType(QObject *parent)
    :QObject(parent)
    , m_icon("")
    , m_name("")
    , m_nameFr("")

{
}

WaypointType::~WaypointType()
{
}

/** Getters & Setters **/

QString WaypointType::icon() const
{
    return m_icon;
}

void WaypointType::setIcon(QString &icon)
{
    m_icon = icon;
    emit iconChanged();
}

QString WaypointType::name() const
{
    return m_name;
}

void WaypointType::setName(QString &name)
{
    m_name = name;
    emit nameChanged();
}

QString WaypointType::nameFr() const
{
    return m_nameFr;
}

void WaypointType::setNameFr(QString &nameFr)
{
    m_nameFr = nameFr;
    emit nameFrChanged();
}
