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

    Q_INVOKABLE void correctedCoordinates(QString geocode, double lat , double lon , bool isCorrectedCoordinates , double correctedLat ,
                                          double correctedLon);
    Q_INVOKABLE void registered(QString geocode, bool recorded);

signals:
    void cachesChanged();

private:
    QList<Cache*> m_caches;
};

#endif // CACHESSINGLELIST_H
