#include "parameter.h"

Parameter::Parameter(QObject *parent) : QObject(parent)
{

}

QString Parameter::name() const
{
    return m_name;
}

void Parameter::setName(const QString &name)
{
    m_name = name;
}

QString Parameter::value() const
{
    return m_value;
}

void Parameter::setValue(const QString &value)
{
    m_value = value;
}

bool Parameter::encoded() const
{
    return m_encoded;
}

void Parameter::setEncoded(bool encoded)
{
    m_encoded = encoded;
}




