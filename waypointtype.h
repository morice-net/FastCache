#ifndef WAYPOINTTYPE_H
#define WAYPOINTTYPE_H

#include <QObject>

class WaypointType: public QObject{

    Q_OBJECT

    Q_PROPERTY(QString icon READ icon WRITE setIcon NOTIFY iconChanged)
    Q_PROPERTY(QString name READ name WRITE setName NOTIFY nameChanged)
    Q_PROPERTY(QString nameFr READ nameFr WRITE setNameFr NOTIFY nameFrChanged)

public:

    explicit  WaypointType(QObject *parent = nullptr);
    ~WaypointType();

    QString  icon() const;
    void  setIcon(QString &m_icon);

    QString  name() const;
    void  setName(QString &m_name);

    QString  nameFr() const;
    void  setNameFr(QString &m_nameFR);

signals:
    void iconChanged();
    void nameChanged();
    void nameFrChanged();

private:
    QString m_icon;
    QString m_name;
    QString m_nameFr;
};

#endif // WAYPOINTTYPE_H
