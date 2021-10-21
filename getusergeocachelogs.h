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
    Q_PROPERTY(QList<int> logsType READ logsType WRITE setLogsType NOTIFY logsTypeChanged)
    Q_PROPERTY(QString geocode READ geocode WRITE setGeocode NOTIFY geocodeChanged)

public:
    explicit GetUserGeocacheLogs(Requestor *parent = nullptr);
    ~GetUserGeocacheLogs() ;

    QList<QString> referenceCodes() const;
    void setReferenceCodes(const QList<QString> &codes);

    QList<QString> logs() const;
    void setLogs(const QList<QString> &logs);

    QList<QString> loggedDates() const;
    void setLoggedDates(const QList<QString> &dates);

    QList<int> logsType() const;
    void setLogsType(const QList<int> &types);

    QString geocode() const;
    void setGeocode(const QString &code);

    Q_INVOKABLE void sendRequest(QString token , QString geocode);

    void parseJson(const QJsonDocument &dataJsonDoc) override;

signals:
    void referenceCodesChanged();
    void logsChanged();
    void loggedDatesChanged();
    void logsTypeChanged();
    void geocodeChanged();

private:
    QList<QString> m_referenceCodes;
    QList<QString> m_logs ;
    QList<QString> m_loggedDates ;
    QList<int> m_logsType ;
    QString m_geocode ;

};

#endif // GETUSERGEOCACHELOGS_H
