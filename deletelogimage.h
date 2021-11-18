#ifndef DELETELOGIMAGE_H
#define DELETELOGIMAGE_H

#include "requestor.h"

class DeleteLogImage : public Requestor
{
    Q_OBJECT

public:

    explicit  DeleteLogImage(Requestor *parent = nullptr);
    ~DeleteLogImage() override;

    Q_INVOKABLE void sendRequest(QString token, QString referenceCode, QString imageGuid);

    void parseJson(const QJsonDocument &dataJsonDoc) override;
};

#endif // DELETELOGIMAGE_H
