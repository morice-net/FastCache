#include "tools.h"

Tools::Tools(QObject *parent) : QObject(parent)
{

}

bool Tools::beginsWith(QString obj, QString value)
{
    return obj.startsWith(value);
}
