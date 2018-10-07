#ifndef CACHESIZE_H
#define CACHESIZE_H


#include <QObject>

class CacheSize : public QObject
{
    Q_OBJECT

    Q_PROPERTY(QString frenchPattern READ frenchPattern WRITE setFrenchPattern NOTIFY frenchPatternChanged)
    Q_PROPERTY(int sizeIdGs READ sizeIdGs WRITE setSizeIdGs NOTIFY sizeIdGsChanged)

public:
    explicit  CacheSize(QObject *parent = nullptr);
    ~CacheSize();

    QString frenchPattern() const;
    void  setFrenchPattern(const QString &french);

    int  sizeIdGs()const;
    void    setSizeIdGs(const int &sizeIdGs);


signals:
    void frenchPatternChanged();
    void sizeIdGsChanged();

private:
    QString m_frenchPattern;
    int m_sizeIdGs;

};

#endif // CACHESIZE_H
