#include "cachetype.h"

CacheType::CacheType(QObject *parent)
    :QObject(parent)
    , m_typeId("")
    , m_frenchPattern("")
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

void CacheType::setTypeId(const QString &typeId)
{
    m_typeId = typeId;
    emit typeIdChanged();
}

QString CacheType::frenchPattern() const
{
    return m_frenchPattern;
}

void CacheType::setFrenchPattern(const QString &pattern)
{
    m_frenchPattern = pattern;
    emit frenchPatternChanged();
}

int CacheType::markerId() const
{
    return m_markerId;
}

void CacheType::setMarkerId(const int &markerId)
{
    m_markerId = markerId;
    emit markerIdChanged();
}

int CacheType::typeIdGs() const
{
    return m_typeIdGs;
}

void CacheType::setTypeIdGs(const int &typeIdGs)
{
    m_typeIdGs = typeIdGs;
    emit typeIdGsChanged();
}
