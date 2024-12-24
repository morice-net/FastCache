#ifndef CACHESSINGLELIST_H
#define CACHESSINGLELIST_H

#include <QQmlListProperty>
#include <QtQml>

class Cache;
class CachesSingleList : public QObject
{
    Q_OBJECT
    QML_ELEMENT

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
    Q_INVOKABLE void found(QString geocode, bool found);
    Q_INVOKABLE void toDoLog(QString geocode, bool toDoLog);

signals:
    void cachesChanged();

private:
    QList<Cache*> m_caches;
};

#endif // CACHESSINGLELIST_H
