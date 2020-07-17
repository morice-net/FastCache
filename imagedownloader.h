#ifndef IMAGEDOWNLOADER_H
#define IMAGEDOWNLOADER_H

#include <QObject>

class ImageDownloader : public QObject
{    
    Q_OBJECT

public:
    explicit ImageDownloader(QObject *parent = nullptr);
    ~ImageDownloader() ;
};

#endif // IMAGEDOWNLOADER_H
