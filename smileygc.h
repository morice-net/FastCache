#ifndef SMILEYGC_H
#define SMILEYGC_H

#include <QObject>
#include <QMap>

class SmileyGc: public QObject
{    
    Q_OBJECT

public:
    explicit SmileyGc(QObject *parent = nullptr);

    QString replaceSmileyTextToImgSrc(const QString &text) const;

private:
    QMap<QString, QString > m_mapSmileyGc;
};
#endif // SMILEYGC_H
