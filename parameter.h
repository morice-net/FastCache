#ifndef PARAMETER_H
#define PARAMETER_H

#include <QObject>

class Parameter : public QObject
{
    Q_OBJECT
public:
    Parameter(QObject *parent = nullptr);

    QString name() const;
    void setName(const QString &name);

    QString value() const;
    void setValue(const QString &value);

    bool encoded() const;
    void setEncoded(bool encoded);

    bool operator <(const Parameter &other) const {
        return (m_name == other.name())? (m_value < other.value()): (m_name < other.name());
    }

private:
    QString m_name;
    QString m_value;
    bool m_encoded;
};

#endif // PARAMETER_H
