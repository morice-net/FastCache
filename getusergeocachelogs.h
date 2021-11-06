#ifndef GETUSERGEOCACHELOGS_H
#define GETUSERGEOCACHELOGS_H

#include "requestor.h"

#include <QNetworkReply>
#include <QObject>

class GetUserGeocacheLogs : public Requestor
{
    Q_OBJECT

    Q_PROPERTY(QList<QString> referenceCodes READ referenceCodes WRITE setReferenceCodes NOTIFY referenceCodesChanged)
    Q_PROPERTY(QList<QString> logs READ logs WRITE setLogs NOTIFY logsChanged)
    Q_PROPERTY(QList<QString> loggedDates READ loggedDates WRITE setLoggedDates NOTIFY loggedDatesChanged)
    Q_PROPERTY(QList<QString> logsType READ logsType WRITE setLogsType NOTIFY logsTypeChanged)
    Q_PROPERTY(QList<int> logsTypeId READ logsTypeId WRITE setLogsTypeId NOTIFY logsTypeIdChanged)
    Q_PROPERTY(QList<int> imagesCount READ imagesCount WRITE setImagesCount NOTIFY imagesCountChanged)

public:
    explicit GetUserGeocacheLogs(Requestor *parent = nullptr);
    ~GetUserGeocacheLogs() ;

    QList<QString> referenceCodes() const;
    void setReferenceCodes(const QList<QString> &codes);

    QList<QString> logs() const;
    void setLogs(const QList<QString> &logs);

    QList<QString> loggedDates() const;
    void setLoggedDates(const QList<QString> &dates);

    QList<QString> logsType() const;
    void setLogsType(const QList<QString> &types);

    QList<int> logsTypeId() const;
    void setLogsTypeId(const QList<int> &typesId);

    QList<int> imagesCount() const;
    void setImagesCount(const  QList<int> &images);

    Q_INVOKABLE void sendRequest(QString token , QString geocode);

    void parseJson(const QJsonDocument &dataJsonDoc) override;

signals:
    void referenceCodesChanged();
    void logsChanged();
    void loggedDatesChanged();
    void logsTypeChanged();
    void logsTypeIdChanged();
    void imagesCountChanged();

private:
    QList<QString> m_referenceCodes;
    QList<QString> m_logs ;
    QList<QString> m_loggedDates ;
    QList<QString> m_logsType ;
    QList<int> m_logsTypeId ;
    QList<int> m_imagesCount;
};

#endif // GETUSERGEOCACHELOGS_H
