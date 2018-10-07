#include "cachesize.h"

CacheSize::CacheSize(QObject *parent)
    :QObject(parent)
    , m_frenchPattern("")
    , m_sizeIdGs(-1)

{
}

CacheSize::~CacheSize()
{
}

/** Getters & Setters **/

QString CacheSize::frenchPattern() const
{
    return m_frenchPattern;
}

void CacheSize::setFrenchPattern(const QString &french)
{
    m_frenchPattern = french;
    emit frenchPatternChanged();
}

int CacheSize::sizeIdGs() const
{
    return m_sizeIdGs;
}

void CacheSize::setSizeIdGs(const int &idGs)
{
    m_sizeIdGs = idGs;
    emit sizeIdGsChanged();
}

