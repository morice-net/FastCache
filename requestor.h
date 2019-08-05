#ifndef REQUESTOR_H
#define REQUESTOR_H

#include <QObject>
#include <QNetworkReply>
#include <QJsonDocument>

class Requestor : public QObject
{
    Q_OBJECT

    Q_PROPERTY(QString state READ state WRITE setState NOTIFY stateChanged)

public:
    explicit Requestor(QObject *parent = nullptr);

    virtual void sendPostRequest(const QString &requestName, const QJsonObject &parameters , QString token);
    virtual void sendGetRequest(const QString &requestName , QString token);
    virtual void sendPutRequest(const QString &requestName ,const QByteArray &data, QString token);
    virtual void sendDeleteRequest(const QString &requestName, QString token);

    virtual void parseJson(const QJsonDocument &dataJsonDoc) = 0;

    QString state() const;
    void setState(const QString &state);

signals:
    void requestReady();
    void stateChanged();

public slots:
    void onReplyFinished(QNetworkReply* reply);

public:
    // Type of caches facilitator
    const QMap<QString, int> CACHE_TYPE_MAP = {{"Traditionnelle",2},
                                               {"Multiple", 3},
                                               {"Virtuelle", 4},
                                               {"Boîte aux lettres hybride", 5},
                                               {"Evènement", 6},
                                               {"Mystère", 8},
                                               {"Project ape cache", 9},
                                               {"Webcam", 11},
                                               {"Locationless (Reverse) Cache", 12},
                                               {"Cito", 13},
                                               {"Earthcache", 137},
                                               {"Méga-Evènement", 453},
                                               {"GPS Adventures Exhibit", 1304},
                                               {"Wherigo", 1858 },
                                               {"Community Celebration Event", 3653},
                                               {"Siège de Groundspeak", 3773},
                                               {"Geocaching HQ Celebration", 3774 },
                                               {"fête locale Groundspeak", 4738},
                                               {"Giga-Evènement", 7005}, };

    // Type of caches (index in cacheList.png)
    const QMap<QString, int> CACHE_TYPE_INDEX_MAP = {{"0",2},
                                                     {"2", 3},
                                                     {"10", 4},
                                                     {"8", 5},
                                                     {"6", 6},
                                                     {"1", 8},
                                                     {"5", 9},
                                                     {"11", 11},
                                                     {"14", 12},
                                                     {"4", 13},
                                                     {"3", 137},
                                                     {"9", 453},
                                                     {"6", 1304},
                                                     {"12", 1858 },
                                                     {"6", 3653},
                                                     {"13", 3773},
                                                     {"14", 3774 },
                                                     {"6", 4738},
                                                     {"7", 7005}, };

    // Size of caches facilitator
    const QMap<QString, int> CACHE_SIZE_MAP = {{"Inconnue"  , 1},
                                               {"Micro" , 2},
                                               {"Petite" , 8},
                                               {"Normale" , 3},
                                               {"Grande" , 4},
                                               {"Virtuelle" , 5},
                                               {"Non renseignée" , 6}, };

    // Size of caches
    const QMap<QString, int> CACHE_SIZE_INDEX_MAP = {{"6"  , 1},
                                                     {"0" , 2},
                                                     {"1" , 8},
                                                     {"2" , 3},
                                                     {"3" , 4},
                                                     {"5" , 5},
                                                     {"4" , 6}, };

protected:
    const int MAX_PER_PAGE = 40;
    const int GEOCACHE_LOGS_COUNT = 20;
    const int GEOCACHE_LOG_IMAGES_COUNT = 10;
    const int TRACKABLE_LOGS_COUNT = 20;
    const int TRACKABLE_LOG_IMAGES_COUNT = 5;
    const int IMAGES = 10;
    const int USER_WAYPOINTS = 15;

    //  network manager
    QNetworkAccessManager *m_networkManager;

private:
    QString m_state;
};

#endif // REQUESTOR_H
