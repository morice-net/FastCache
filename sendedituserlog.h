#ifndef SENDEDITUSERLOG_H
#define SENDEDITUSERLOG_H

#include "requestor.h"

#include <QNetworkReply>
#include <QObject>


class SendEditUserLog : public Requestor
{
    Q_OBJECT

    Q_PROPERTY(int founds READ founds WRITE setFounds NOTIFY foundsChanged)
    Q_PROPERTY(QString codeLog READ codeLog WRITE setCodeLog NOTIFY codeLogChanged)
    Q_PROPERTY(int logTypeResponse READ logTypeResponse WRITE setLogTypeResponse NOTIFY logTypeResponseChanged)
    Q_PROPERTY(bool parsingCompleted READ parsingCompleted WRITE setParsingCompleted NOTIFY parsingCompletedChanged)
    Q_PROPERTY(bool favorited READ favorited WRITE setFavorited NOTIFY favoritedChanged)


public:
    explicit  SendEditUserLog(Requestor *parent = nullptr);
    ~SendEditUserLog() override;

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

    Q_INVOKABLE void sendRequest(QString token, QString referenceCode, QString geocode  , int logType , QString date , QString text , bool favorite);
    Q_INVOKABLE void sendRequest(QString token, QString referenceCode);

    void parseJson(const QJsonDocument &dataJsonDoc) override;

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

#endif // SENDEDITUSERLOG_H
