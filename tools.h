#ifndef TOOLS_H
#define TOOLS_H

#include <QObject>

class Tools : public QObject
{
    Q_OBJECT
public:
    explicit Tools(QObject *parent = 0);

    Q_INVOKABLE bool beginsWith(QString obj, QString value);
};

#endif // TOOLS_H
