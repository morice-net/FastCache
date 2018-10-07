#ifndef CACHETYPE_H
#define CACHETYPE_H

#include <QObject>

class CacheType : public QObject
{

    Q_OBJECT

    Q_PROPERTY(QString typeId READ typeId WRITE setTypeId NOTIFY typeIdChanged)
    Q_PROPERTY(QString frenchPattern READ frenchPattern WRITE setFrenchPattern NOTIFY frenchPatternChanged)
    Q_PROPERTY(int markerId READ markerId WRITE setMarkerId NOTIFY markerIdChanged)
    Q_PROPERTY(int typeIdGs READ typeIdGs WRITE setTypeIdGs NOTIFY typeIdGsChanged)


public:
    explicit  CacheType(QObject *parent = nullptr);
    ~CacheType();

    QString typeId() const;
    void  setTypeId(const QString &typeId);

    QString  frenchPattern() const;
    void    setFrenchPattern(const QString &pattern);

    int markerId() const ;
    void    setMarkerId(const int &markerId);

    int typeIdGs() const;
    void    setTypeIdGs(const int &typeIdGs);

signals:
    void typeIdChanged();
    void frenchPatternChanged();
    void markerIdChanged();
    void typeIdGsChanged();


private:
    QString m_typeId;
    QString m_frenchPattern;
    int m_markerId;
    int m_typeIdGs;

};

#endif // CACHETYPE_H
