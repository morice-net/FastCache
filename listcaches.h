#ifndef LISTCACHES_H
#define LISTCACHES_H

#include <QQmlListProperty>

class Cache;
class ListCaches : public QObject
{
    Q_OBJECT

    Q_PROPERTY ( QQmlListProperty<Cache> caches READ caches NOTIFY cachesChanged)

public:
    explicit ListCaches(QObject *parent = nullptr);
    ~ListCaches() ;

    QQmlListProperty<Cache> caches();

signals:
    void cachesChanged();

protected:
    QList<Cache*> m_caches;
};

#endif // LISTCACHES_H
