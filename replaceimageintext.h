#ifndef REPLACEIMAGEINTEXT_H
#define REPLACEIMAGEINTEXT_H

#include "imagedownloader.h"
#include <QJsonDocument>

class ReplaceImageInText : public ImageDownloader
{
    Q_OBJECT

public:    
    explicit ReplaceImageInText(ImageDownloader *parent = nullptr);
    ~ReplaceImageInText() ;
    QJsonDocument replaceUrlImageToPath(const QString &geocode , const QJsonDocument &dataJsonDoc , const bool &saveImage);
    void removeDir(const QString &geocode);

private:
    QString m_dir = "./ImagesRecorded/";
};

#endif // REPLACEIMAGEINTEXT_H
