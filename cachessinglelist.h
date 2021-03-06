#ifndef CACHESSINGLELIST_H
#define CACHESSINGLELIST_H

#include <QQmlListProperty>

class Cache;
class CachesSingleList : public QObject
{
    Q_OBJECT

    Q_PROPERTY ( QQmlListProperty<Cache> caches READ caches NOTIFY cachesChanged)

public:
    explicit CachesSingleList(QObject *parent = nullptr);
    ~CachesSingleList() ;

    QQmlListProperty<Cache> caches();

    QList<Cache*> getCaches();
    void  setCaches(const QList<Cache*> &caches);
    void  clear();
    void  append(Cache &cache);
    void  deleteAll();
    int  length();

signals:
    void cachesChanged();

private:
    QList<Cache*> m_caches;
};

#endif // CACHESSINGLELIST_H
