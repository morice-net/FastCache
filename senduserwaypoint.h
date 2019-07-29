#ifndef SENDUSERWAYPOINT_H
#define SENDUSERWAYPOINT_H

#include "requestor.h"
#include "fullcache.h"

#include <QNetworkReply>
#include <QObject>

class FullCache;
class SendUserWaypoint : public Requestor
{
    Q_OBJECT

public:
    explicit  SendUserWaypoint(Requestor *parent = nullptr);
    ~SendUserWaypoint() override;

    Q_INVOKABLE void sendRequest(QString token , QString geocacheCode , double lat, double lon ,bool isCorrectedCoordinates , QString description) ;
    Q_INVOKABLE void sendRequest(QString token , QString uwCode) ;
    Q_INVOKABLE void updateFullCache(FullCache *fullCache);

    void parseJson(const QJsonDocument &dataJsonDoc) override;

private:    
    FullCache *m_fullCache;
};

#endif // SENDUSERWAYPOINT_H
