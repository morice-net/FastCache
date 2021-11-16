#ifndef GETGEOCACHELOGIMAGES_H
#define GETGEOCACHELOGIMAGES_H

#include "requestor.h"

#include <QNetworkReply>
#include <QObject>

class GetGeocacheLogImages : public Requestor
{
    Q_OBJECT

    Q_PROPERTY(QList<QString> descriptions READ descriptions WRITE setDescriptions NOTIFY descriptionsChanged)
    Q_PROPERTY(QList<QString> urls READ  urls WRITE setUrls NOTIFY  urlsChanged)
    Q_PROPERTY(QList<QString> guids READ guids WRITE setGuids NOTIFY guidsChanged)

public:
    explicit GetGeocacheLogImages(Requestor *parent = nullptr);
    ~GetGeocacheLogImages() ;

    QList<QString> descriptions() const;
    void setDescriptions(const QList<QString> &descriptions);

    QList<QString> urls() const;
    void setUrls(const QList<QString> &urls);

    QList<QString> guids() const;
    void setGuids(const QList<QString> &guids);

    Q_INVOKABLE void sendRequest(QString token , QString referenceCode);

    void parseJson(const QJsonDocument &dataJsonDoc) override;

signals:
    void descriptionsChanged();
    void urlsChanged();
    void guidsChanged();

private:
    QList<QString> m_descriptions;
    QList<QString> m_urls ;
    QList<QString> m_guids ;
};

#endif // GETGEOCACHELOGIMAGES_H
