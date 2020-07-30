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

    Q_INVOKABLE  QJsonDocument replaceUrlImageToPath(const QString &geocode , const QJsonDocument &dataJsonDoc);
};

#endif // REPLACEIMAGEINTEXT_H
