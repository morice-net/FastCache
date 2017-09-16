#include "cachesize.h"

CacheSize::CacheSize(QObject *parent):QObject(parent)

  , m_sizeId("")
  , m_sizeIdGs(-1)

{
}

CacheSize::~CacheSize()
{
}

/** Getters & Setters **/

QString CacheSize::sizeId() const
{
    return m_sizeId;
}

void CacheSize::setSizeId(QString &id)
{
    m_sizeId = id;
    emit sizeIdChanged();
}

int CacheSize::sizeIdGs() const
{
    return m_sizeIdGs;
}

void CacheSize::setSizeIdGs(int &idGs)
{
    m_sizeIdGs = idGs;
    emit sizeIdGsChanged();
}

