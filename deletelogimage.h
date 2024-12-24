#ifndef DELETELOGIMAGE_H
#define DELETELOGIMAGE_H

#include "requestor.h"

#include <QtQml>

class DeleteLogImage : public Requestor
{
    Q_OBJECT
    QML_ELEMENT

public:

    explicit  DeleteLogImage(Requestor *parent = nullptr);
    ~DeleteLogImage() override;

    Q_INVOKABLE void sendRequest(QString token, QString referenceCode, QString imageGuid);

    void parseJson(const QJsonDocument &dataJsonDoc) override;
};

#endif // DELETELOGIMAGE_H
