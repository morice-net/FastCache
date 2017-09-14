#include "cachetype.h"

CacheType::CacheType(QObject *parent):QObject(parent)

  , m_typeId("")
  , m_pattern("")
  , m_markerId(-1)
  , m_typeIdGs(-1)

{
}

CacheType::~CacheType()
{
}

/** Getters & Setters **/

QString CacheType::typeId() const
{
    return m_typeId;
}

void CacheType::setTypeId(QString &id)
{
    m_typeId = id;
    emit typeIdChanged();
}

QString CacheType::pattern() const
{
    return m_pattern;
}

void CacheType::setPattern(QString &pattern)
{
    m_pattern = pattern;
    emit patternChanged();
}

int CacheType::markerId() const
{
    return m_markerId;
}

void CacheType::setMarkerId(int &markerId)
{
    m_markerId = markerId;
    emit markerIdChanged();
}

int CacheType::typeIdGs() const
{
    return m_typeIdGs;
}

void CacheType::setTypeIdGs(int &typeIdGs)
{
    m_typeIdGs = typeIdGs;
    emit typeIdGsChanged();
}
