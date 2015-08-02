#ifndef PARAMETER_H
#define PARAMETER_H

#include <QObject>

class Parameter : public QObject
{
    Q_OBJECT
public:
    Parameter(QObject *parent = 0);

    QString name() const;
    void setName(const QString &name);

    QString value() const;
    void setValue(const QString &value);

    bool encoded() const;
    void setEncoded(bool encoded);

private:
    QString m_name;
    QString m_value;
    bool m_encoded;
};

#endif // PARAMETER_H
