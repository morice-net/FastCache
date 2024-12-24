#ifndef SENDIMAGESLOG_H
#define SENDIMAGESLOG_H

#include "requestor.h"

#include <QNetworkReply>
#include <QObject>
#include <QtQml>

class SendImagesLog : public Requestor
{
    Q_OBJECT
    QML_ELEMENT

public:
    explicit SendImagesLog(Requestor *parent = nullptr);
    ~SendImagesLog() override;
    void parseJson(const QJsonDocument &dataJsonDoc) override;

    Q_INVOKABLE QJsonDocument makeJsonSendImagesLog(const QList<QString> &list );
    Q_INVOKABLE  void sendRequest(QString token , QString codeLog, QString description  , QString filUrl, int rotation);
    Q_INVOKABLE QList<QString> readJsonArray(const QJsonDocument &jsonDoc);

private:
    QString imageToBase64(const QString &fileUrl, const int &rotation);
};

#endif // SENDIMAGESLOG_H
