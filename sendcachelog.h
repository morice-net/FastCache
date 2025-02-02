#ifndef SENDCACHELOG_H
#define SENDCACHELOG_H

#include "requestor.h"

#include <QNetworkReply>
#include <QObject>
#include <QJsonDocument>
#include <QtQml>

class SendCacheLog : public Requestor
{
    Q_OBJECT
    QML_ELEMENT

    Q_PROPERTY(int founds READ founds WRITE setFounds NOTIFY foundsChanged)
    Q_PROPERTY(QString codeLog READ codeLog WRITE setCodeLog NOTIFY codeLogChanged)
    Q_PROPERTY(int logTypeResponse READ logTypeResponse WRITE setLogTypeResponse NOTIFY logTypeResponseChanged)
    Q_PROPERTY(bool parsingCompleted READ parsingCompleted WRITE setParsingCompleted NOTIFY parsingCompletedChanged)
    Q_PROPERTY(bool favorited READ favorited WRITE setFavorited NOTIFY favoritedChanged)

public:

    explicit SendCacheLog(Requestor *parent = nullptr);
    ~SendCacheLog() override;

    int founds() const;
    void setFounds(const int &count);
    QString codeLog() const;
    void setCodeLog(const QString &code);
    int logTypeResponse() const;
    void setLogTypeResponse(const int &type);
    bool parsingCompleted() const;
    void setParsingCompleted(const bool &completed);
    bool favorited() const;
    void setFavorited(const bool &favorite);

    void parseJson(const QJsonDocument &dataJsonDoc) override;

    Q_INVOKABLE QJsonDocument makeJsonLog(int logType , QString date , QString log , bool favorite);
    Q_INVOKABLE void sendRequest(QString token , QString cacheCode, int logType , QString date , QString log , bool favorite);
    Q_INVOKABLE QVariant readJsonProperty(const QJsonDocument &jsonDoc, QString propertyName);

signals:
    void foundsChanged();
    void codeLogChanged();
    void logTypeResponseChanged();
    void parsingCompletedChanged();
    void favoritedChanged();

private:
    int m_count;
    QString m_codeLog;
    int m_logTypeResponse;
    bool m_parsingCompleted;
    bool m_favorited;
};

#endif // SENDCACHELOG_H
