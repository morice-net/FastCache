#ifndef SENDIMAGESLOG_H
#define SENDIMAGESLOG_H

#include "requestor.h"

#include <QNetworkReply>
#include <QObject>

class SendImagesLog : public Requestor
{
    Q_OBJECT

public:
    explicit SendImagesLog(Requestor *parent = nullptr);
    ~SendImagesLog() override;

    void parseJson(const QJsonDocument &dataJsonDoc) override;

    Q_INVOKABLE  void sendRequest(QString token , QString codeLog, QString description  , QString filUrl);

private:
    QString imageToBase64(const QString &fileUrl);
};

#endif // SENDIMAGESLOG_H
