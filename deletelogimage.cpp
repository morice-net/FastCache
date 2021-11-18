#include "deletelogimage.h"

DeleteLogImage::DeleteLogImage(Requestor *parent)
    : Requestor (parent)
{
}

DeleteLogImage::~DeleteLogImage()
{
}

void DeleteLogImage::sendRequest(QString token , QString referenceCode, QString imageGuid)
{
    //Build url
    QString requestName = "geocachelogs/";
    requestName.append(referenceCode);
    requestName.append("/images/");
    requestName.append(imageGuid);

    // Inform QML we are loading
    setState("loading");
    Requestor::sendDeleteRequest(requestName,token);

}

void DeleteLogImage::parseJson(const QJsonDocument &dataJsonDoc)
{
    Q_UNUSED(dataJsonDoc)
}
