#include "logtype.h"

LogType::LogType(QObject *parent)
    :QObject(parent)
    , m_typeId("")
    , m_frenchPattern("")
    , m_typeIdGs(-1)
    , m_icon("")

{
}

LogType::~LogType()
{
}

/** Getters & Setters **/

QString LogType::typeId() const
{
    return m_typeId;
}

void LogType::setTypeId(const QString &typeId)
{
    m_typeId = typeId;
    emit typeIdChanged();
}

QString LogType::frenchPattern() const
{
    return m_frenchPattern;
}

void LogType::setFrenchPattern(const QString &pattern)
{
    m_frenchPattern = pattern;
    emit frenchPatternChanged();
}

int LogType::typeIdGs() const
{
    return m_typeIdGs;
}

void LogType::setTypeIdGs(const int &typeIdGs)
{
    m_typeIdGs = typeIdGs;
    emit typeIdGsChanged();
}

QString LogType::icon() const
{
    return m_icon;
}

void LogType::setIcon(const QString &icon)
{
    m_icon = icon;
    emit iconChanged();
}
