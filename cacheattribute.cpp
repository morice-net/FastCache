#include "cacheattribute.h"

CacheAttribute::CacheAttribute(QObject *parent):QObject(parent)

  , m_gcId(0)
  , m_textYes("")
  , m_textNo("")
  , m_icon("")

{
}

CacheAttribute::~CacheAttribute()
{
}

/** Getters & Setters **/

int CacheAttribute::gcId() const
{
    return m_gcId;
}

void CacheAttribute::setGcId(int &id)
{
    m_gcId = id;
    emit gcIdChanged();
}

QString CacheAttribute::textYes() const
{
    return m_textYes;
}

void CacheAttribute::setTextYes(QString &yes)
{
    m_textYes = yes;
    emit textYesChanged();
}

QString CacheAttribute::textNo() const
{
    return m_textNo;
}

void CacheAttribute::setTextNo(QString &no)
{
    m_textNo = no;
    emit textNoChanged();
}

QString CacheAttribute::icon() const
{
    return m_icon;
}

void CacheAttribute::setIcon(QString &ico)
{
    m_icon = ico;
    emit iconChanged();
}

