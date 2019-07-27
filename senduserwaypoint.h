#ifndef SENDUSERWAYPOINT_H
#define SENDUSERWAYPOINT_H

#include "requestor.h"

#include <QNetworkReply>
#include <QObject>

class SendUserWaypoint : public Requestor
{
    Q_OBJECT

public:
    explicit  SendUserWaypoint(Requestor *parent = nullptr);
    ~SendUserWaypoint() override;

    Q_INVOKABLE void sendRequest(QString token , QString geocacheCode , double lat, double lon ,bool isCorrectedCoordinates , QString description) ;
    Q_INVOKABLE void sendRequest(QString token , QString uwCode) ;

    void parseJson(const QJsonDocument &dataJsonDoc) override;
};

#endif // SENDUSERWAYPOINT_H
