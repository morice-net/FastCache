#ifndef REPLACEIMAGEINTEXT_H
#define REPLACEIMAGEINTEXT_H

#include <QObject>

class ReplaceImageInText : public QObject
{
    Q_OBJECT

public:
    explicit ReplaceImageInText(QObject *parent = nullptr);
    ~ReplaceImageInText() ;
};

#endif // REPLACEIMAGEINTEXT_H
