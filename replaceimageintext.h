#ifndef REPLACEIMAGEINTEXT_H
#define REPLACEIMAGEINTEXT_H

#include "downloador.h"
#include <QJsonDocument>

class ReplaceImageInText : public Downloador
{
    Q_OBJECT

public:    
    explicit ReplaceImageInText(Downloador *parent = nullptr);
    ~ReplaceImageInText() ;
    QJsonDocument replaceUrlImageToPath(const QString &geocode , const QJsonDocument &dataJsonDoc , const bool &saveImage);
    void removeDir(const QString &geocode);

private:
    QString m_dir = "./ImagesRecorded/";
};

#endif // REPLACEIMAGEINTEXT_H
