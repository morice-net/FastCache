#ifndef CACHETYPE_H
#define CACHETYPE_H

#include <QObject>

class CacheType : public QObject
{

    Q_OBJECT

    Q_PROPERTY(QString typeId READ typeId WRITE setTypeId NOTIFY typeIdChanged)
    Q_PROPERTY(QString pattern READ pattern WRITE setPattern NOTIFY patternChanged)
    Q_PROPERTY(int markerId READ markerId WRITE setMarkerId NOTIFY markerIdChanged)
    Q_PROPERTY(int typeIdGs READ typeIdGs WRITE setTypeIdGs NOTIFY typeIdGsChanged)


public:
    explicit  CacheType(QObject *parent = nullptr);
    ~CacheType();

    QString typeId() const;
    void  setTypeId(QString &m_typeId);

    QString  pattern()const;
    void    setPattern(QString &m_pattern);

    int markerId()const ;
    void    setMarkerId(int &m_markerId);

    int typeIdGs()const;
    void    setTypeIdGs(int &m_typeIdGs);

signals:
    void typeIdChanged();
    void patternChanged();
    void markerIdChanged();
    void typeIdGsChanged();


private:
    QString m_typeId;
    QString m_pattern;
    int m_markerId;
    int m_typeIdGs;

};

#endif // CACHETYPE_H
