#include "fullcache.h"
#include "smileygc.h"
#include "travelbug.h"

#include <QNetworkAccessManager>
#include <QNetworkRequest>
#include <QJsonDocument>
#include <QJsonObject>
#include <QJsonArray>
#include <QList>
#include <QMap>

FullCache::FullCache(Cache *parent)
    :  Cache (parent)
    ,  m_attributes(QList<int>())
    ,  m_attributesBool(QList<bool>())
    , m_location("")
    , m_favorited(false)
    , m_longDescription("")
    , m_longDescriptionIsHtml(false)
    , m_shortDescription("")
    , m_shortDescriptionIsHtml(false)
    , m_hints("")
    , m_note("")
    , m_imagesName(QList<QString>())
    , m_imagesUrl(QList<QString>())
    , m_findersName(QList<QString>())
    , m_logs(QList<QString>())
    , m_logsType(QList<QString>())
    , m_findersCount(QList<int>())
    , m_findersDate(QList<QString>())
    , m_cacheImagesIndex(QList<int>())
    , m_listVisibleImages(QList<bool>())
    , m_wptsDescription(QList<QString>())
    , m_wptsName(QList<QString>())
    , m_wptsLat(QList<double>())
    , m_wptsLon(QList<double>())
    , m_wptsComment(QList<QString>())
    , m_trackableNames(QList<QString>())
    , m_trackableCodes(QList<QString>())
    , m_trackablesJson(QJsonArray())
    , m_mapLogType({{"Trouvée",2},
{"Non trouvée", 3},
{"Note", 4},
{"Publiée", 1003},
{"Activée", 23},
{"Désactivée", 22},
{"Participera", 9},
{"A participé", 10},
{"Récupéré", 13},
{"Déposé", 14},
{"Pris ailleurs", 19},
{"Ajouté à une collection", 69},
{"Ajouté à l\'inventaire", 70},
{"Maintenance effectuée", 46},
{"Nécessite une maintenance", 45},
{"Coordonnées mises à jour", 47},
{"Archivée", 5},
{"Désarchivée", 12},
{"Nécessite d\'être archivée", 7},
{"Découverte", 48},
{"Note du relecteur", 18},
{"Soumettre pour examen", 76},
{"Visite retirée", 25},
{"Marquer comme absente", 16},
{"Photo prise par la webcam", 11}})
    , m_networkManager(new QNetworkAccessManager(this))
{
    // Object name is used for storage, it's also a good practise to name the objects
    setObjectName("fullcache");

    connect(m_networkManager, &QNetworkAccessManager::finished, this, &FullCache::onReplyFinished);
}

void FullCache::sendRequest(QString token)
{
    if (readFromStorage()) {
        // We're done by retrieving the cache from storage
        qDebug() << "\nCache retrieved from database";
        return;
    }
    else {
        qDebug() << "\nCache cannot been retrieved from database, making a query to groundspeak.";

    }
    // Inform QML we are loading

    QUrl uri("https://api.groundspeak.com/LiveV6/geocaching.svc//SearchForGeocaches?format=json");

    QJsonObject parameters;
    QJsonObject geocacheCode;
    QJsonArray geocachesCodes;

    geocachesCodes.append(FullCache::geocode());
    geocacheCode.insert("CacheCodes",QJsonValue(geocachesCodes));

    parameters.insert("AccessToken", QJsonValue(token));
    parameters.insert("IsLite", QJsonValue(false));
    parameters.insert("MaxPerPage", QJsonValue(MAX_PER_PAGE));
    parameters.insert("GeocacheLogCount", QJsonValue(GEOCACHE_LOG_COUNT));
    parameters.insert("TrackableLogCount", QJsonValue(TRACKABLE_LOG_COUNT));
    parameters.insert("CacheCode", QJsonValue(geocacheCode));

    QNetworkRequest request;
    request.setUrl(uri);
    request.setHeader(QNetworkRequest::ContentTypeHeader, "application/json");
    qDebug() <<"cacheJson:" <<QJsonDocument(parameters).toJson(QJsonDocument::Indented);
    m_networkManager->post(request, QJsonDocument(parameters).toJson(QJsonDocument::Compact));
}

bool FullCache::readFromStorage()
{
    return m_storage->readObject(this, "geocode", m_geocode);
}

void FullCache::writeToStorage()
{
    setRegistered(true);
    m_storage->insertObject(this, "geocode");
}

void FullCache::onReplyFinished(QNetworkReply *reply)
{
    QJsonDocument dataJsonDoc;
    QJsonObject JsonObj;
    QJsonObject  statusJson;

    if (reply->error() == QNetworkReply::NoError) {
        dataJsonDoc = QJsonDocument::fromJson(reply->readAll());
        qDebug() << "*** Cache ***\n" <<dataJsonDoc ;
        JsonObj = dataJsonDoc.object();
        statusJson = JsonObj["Status"].toObject();

        int status = statusJson["StatusCode"].toInt();
        if (status != 0) {
            // Inform the QML that there is an error
            //     setState("error");
            return ;
        }
    } else {
        qDebug() << "*** Cache ERROR ***\n" <<reply->errorString();
        return;
    }
    // Inform the QML that there is no loading error
    //  setState("noError");

    QJsonValue value = JsonObj.value("Geocaches");
    QJsonArray caches = value.toArray();

    int lengthCaches = caches.size();
    if (lengthCaches == 0) {
        return ;
    }

    for (QJsonValue cacheJson: caches)
    {
        SmileyGc * smileys = new SmileyGc;
        setArchived(cacheJson.toObject().value("Archived").toBool());
        setDisabled(cacheJson.toObject().value("Available").toBool());

        QJsonObject v1 = cacheJson.toObject().value("Owner").toObject();
        QString owner = v1.value("UserName").toString();
        setOwner(owner);

        QString date(cacheJson.toObject().value("DateCreated").toString());
        setDate(date);

        QJsonObject v2 = cacheJson.toObject().value("CacheType").toObject();
        int cacheTypeId= v2.value("GeocacheTypeId").toInt();
        setType(cacheTypeId);

        QString code(cacheJson.toObject().value("Code").toString());
        setGeocode(code);

        QJsonObject v3 = cacheJson.toObject().value("ContainerType").toObject();
        int cacheSizeId= v3.value("ContainerTypeId").toInt();
        setSize(cacheSizeId);

        setDifficulty(cacheJson.toObject().value("Difficulty").toDouble());
        setFavoritePoints(cacheJson.toObject().value("FavoritePoints").toInt());
        setLat(cacheJson.toObject().value("Latitude").toDouble());
        setLon(cacheJson.toObject().value("Longitude").toDouble());

        setName(cacheJson.toObject().value("Name").toString());

        setTrackableCount(cacheJson.toObject().value("TrackableCount").toInt());
        setFound(cacheJson.toObject().value("HasbeenFoundbyUser").toBool());
        setTerrain(cacheJson.toObject().value("Terrain").toDouble());

        // Attributes of cache.
        m_attributes.clear();
        m_attributesBool.clear();

        QJsonArray  atts = cacheJson.toObject().value("Attributes").toArray();
        foreach ( const QJsonValue & att, atts)
        {
            m_attributes.append(att.toObject().value("AttributeTypeID").toInt());
            m_attributesBool.append(att.toObject().value("IsOn").toBool());
        }
        qDebug() << "*** attributs**\n" <<m_attributes ;
        qDebug() << "*** attributsBool**\n" <<m_attributesBool ;
        emit attributesChanged();
        emit attributesBoolChanged();

        // State
        setLocation(cacheJson.toObject().value("State").toString());

        // Favorited
        setFavorited(cacheJson.toObject().value("HasbeenFavoritedbyUser").toBool());

        // Short description
        setShortDescriptionIsHtml(cacheJson.toObject().value("ShortDescriptionIsHtml").toBool());
        setShortDescription(cacheJson.toObject().value("ShortDescription").toString());

        // Long description
        setLongDescriptionIsHtml(cacheJson.toObject().value("LongDescriptionIsHtml").toBool());
        setLongDescription(cacheJson.toObject().value("LongDescription").toString());

        // Hints
        setHints(cacheJson.toObject().value("EncodedHints").toString());

        // Note
        m_note = "";
        if (!cacheJson.toObject().value("GeocacheNote").toString().isNull()) {
            setNote(cacheJson.toObject().value("GeocacheNote").toString());
        }

        // Images
        m_imagesName.clear();
        m_imagesUrl.clear();
        m_cacheImagesIndex.clear();

        for (QJsonValue image: cacheJson.toObject().value("Images").toArray())
        {
            m_imagesName.append(smileys->replaceSmileyTextToImgSrc(image.toObject().value("Name").toString()));
            m_imagesUrl.append(image.toObject().value("MobileUrl").toString());
        }
        m_cacheImagesIndex.append(m_imagesName.size());

        qDebug() << "*** imagesName**\n" <<m_imagesName ;
        qDebug() << "*** imagesUrl**\n" <<m_imagesUrl ;

        // Logs
        m_findersCount.clear();
        m_findersDate.clear();
        m_findersName.clear();
        m_logs.clear()  ;
        m_logsType.clear();
        m_listVisibleImages.clear();

        QJsonArray geocacheLogs = cacheJson.toObject().value("GeocacheLogs").toArray();
        for (QJsonValue geocacheLog: geocacheLogs)
        {
            m_logs.append(smileys->replaceSmileyTextToImgSrc(geocacheLog.toObject().value("LogText").toString()));
            m_findersDate.append(geocacheLog.toObject().value("VisitDateIso").toString());

            QJsonObject finder = geocacheLog.toObject().value("Finder").toObject();
            m_findersName.append(finder.value("UserName").toString());
            m_findersCount.append(finder.value("FindCount").toInt());

            QJsonObject type = geocacheLog.toObject().value("LogType").toObject();
            m_logsType.append(m_mapLogType.key(type.value("WptLogTypeId").toInt()));

            QJsonArray logsImage = geocacheLog.toObject().value("Images").toArray();
            for (QJsonValue logImage: logsImage)
            {
                m_imagesName.append(smileys->replaceSmileyTextToImgSrc(logImage.toObject().value("Name").toString()));
                m_imagesUrl.append(logImage.toObject().value("MobileUrl").toString());
            }
            m_cacheImagesIndex.append(m_imagesName.size());
        }

        for(int i = 0; i < m_imagesName.size(); ++i)
        {
            m_listVisibleImages.append(true);
        }
        emit imagesNameChanged();
        emit imagesUrlChanged();
        emit logsChanged();
        emit logsTypeChanged();
        emit findersCountChanged();
        emit findersDateChanged();
        emit findersNameChanged();
        emit cacheImagesIndexChanged();
        emit listVisibleImagesChanged();

        // Waypoints
        m_wptsDescription.clear();
        m_wptsName.clear();
        m_wptsLat.clear();
        m_wptsLon.clear()  ;
        m_wptsComment.clear();

        for (QJsonValue waypoint: cacheJson.toObject().value("AdditionalWaypoints").toArray())
        {
            m_wptsDescription.append(waypoint.toObject().value("UrlName").toString());
            m_wptsName.append(waypoint.toObject().value("Name").toString());
            if(waypoint.toObject().value("Latitude").isNull()) {
                m_wptsLat.append(200) ;
            } else{
                m_wptsLat.append(waypoint.toObject().value("Latitude").toDouble());
            }
            m_wptsLon.append(waypoint.toObject().value("Longitude").toDouble());
            m_wptsComment.append(waypoint.toObject().value("Comment").toString());
        }
        emit wptsDescriptionChanged();
        emit wptsNameChanged();
        emit wptsLatChanged();
        emit wptsLonChanged();
        emit wptsCommentChanged();

        // Trackables: list of names and codes.
        m_trackableNames.clear();
        m_trackableCodes.clear();

        for (QJsonValue travel: cacheJson.toObject().value("Trackables").toArray())
        {
            m_trackableNames.append(travel.toObject().value("Name").toString());
            m_trackableCodes.append(travel.toObject().value("Code").toString());
        }
        emit trackableNamesChanged();
        emit trackableCodesChanged();

        // Trackables managed by travelbug class.
        setTrackablesJson( cacheJson.toObject().value("Trackables").toArray());
    }
    emit registeredChanged();
}

QList<int> FullCache::attributes() const
{
    return  m_attributes;
}

void FullCache::setAttributes(const QList<int> &attributes)
{
    m_attributes = attributes;
    emit attributesChanged();
}

QList<bool> FullCache::attributesBool() const
{
    return  m_attributesBool;
}

void FullCache::setAttributesBool(const QList<bool> &attributesBool)
{
    m_attributesBool = attributesBool;
    emit attributesBoolChanged();
}

QString FullCache::location() const
{
    return m_location;
}

void FullCache::setLocation(const QString &location)
{
    m_location = location;
    emit locationChanged();
}

bool FullCache::favorited() const
{
    return m_favorited;
}

void FullCache::setFavorited(const bool &favor)
{
    m_favorited = favor;
    emit favoritedChanged();
}

QString FullCache::longDescription() const
{
    return m_longDescription;
}

void FullCache::setLongDescription(const QString &description)
{
    m_longDescription = description;
    emit longDescriptionChanged();
}

QString FullCache::shortDescription() const
{
    return m_shortDescription;
}

void FullCache::setShortDescription(const QString &description)
{
    m_shortDescription = description;
    emit shortDescriptionChanged();
}

bool FullCache::longDescriptionIsHtml() const
{
    return m_longDescriptionIsHtml;
}

void FullCache::setLongDescriptionIsHtml(const bool &html)
{
    m_longDescriptionIsHtml = html;
    emit longDescriptionIsHtmlChanged();
}

bool FullCache::shortDescriptionIsHtml() const
{
    return m_shortDescriptionIsHtml;
}

void FullCache::setShortDescriptionIsHtml(const bool &html)
{
    m_shortDescriptionIsHtml = html;
    emit shortDescriptionIsHtmlChanged();
}

QString FullCache::hints() const
{
    return m_hints;
}

void FullCache::setHints(const QString &hint)
{
    m_hints = hint;
    emit hintsChanged();
}

QString FullCache::note() const
{
    return m_note;
}

void FullCache::setNote(const QString &note)
{
    m_note = note;
    emit noteChanged();
}

QList<QString> FullCache::imagesName() const
{
    return  m_imagesName;
}

void FullCache::setImagesName(const QList<QString> &names)
{
    m_imagesName = names;
    emit imagesNameChanged();
}

QList<QString> FullCache::imagesUrl() const
{
    return  m_imagesUrl;
}

void FullCache::setImagesUrl(const QList<QString> &urls)
{
    m_imagesUrl = urls;
    emit imagesUrlChanged();
}

QList<QString> FullCache::findersName() const
{
    return  m_findersName;
}

void FullCache::setFindersName(const QList<QString> &names)
{
    m_findersName = names;
    emit findersNameChanged();
}

QList<QString> FullCache::findersDate() const
{
    return  m_findersDate;
}

void FullCache::setFindersDate(const QList<QString> &dates)
{
    m_findersDate = dates;
    emit findersDateChanged();
}

QList<int> FullCache::findersCount() const
{
    return  m_findersCount;
}

void FullCache::setFindersCount(const QList<int> &counts)
{
    m_findersCount = counts;
    emit findersCountChanged();
}

QList<QString> FullCache::logs() const
{
    return  m_logs;
}

void FullCache::setLogs(const QList<QString> &logs)
{
    m_logs = logs;
    emit logsChanged();
}

QList<QString> FullCache::logsType() const
{
    return  m_logsType;
}

void FullCache::setLogsType(const QList<QString> &types)
{
    m_logsType = types;
    emit logsTypeChanged();
}

QList<QString> FullCache::wptsDescription() const
{
    return  m_wptsDescription;
}

void FullCache::setWptsDescription(const QList<QString> &descriptions)
{
    m_wptsDescription = descriptions;
    emit wptsDescriptionChanged();
}

QList<QString> FullCache::wptsName() const
{
    return  m_wptsName;
}

void FullCache::setWptsName(const QList<QString> &names)
{
    m_wptsName = names;
    emit wptsNameChanged();
}

QList<double> FullCache::wptsLat() const
{
    return  m_wptsLat;
}

void FullCache::setWptsLat(const QList<double> &lats)
{
    m_wptsLat = lats;
    emit wptsLatChanged();
}

QList<double> FullCache::wptsLon() const
{
    return  m_wptsLon;
}

void FullCache::setWptsLon(const QList<double> &lons)
{
    m_wptsLon = lons;
    emit wptsLonChanged();
}

QList<QString> FullCache::wptsComment() const
{
    return  m_wptsComment;
}

void FullCache::setWptsComment(const QList<QString> &comments)
{
    m_wptsComment = comments;
    emit wptsCommentChanged();
}

QList<int> FullCache::cacheImagesIndex() const
{
    return  m_cacheImagesIndex;
}

void FullCache::setCacheImagesIndex(const QList<int> &ints)
{
    m_cacheImagesIndex = ints;
    emit cacheImagesIndexChanged();
}

QList<bool> FullCache::listVisibleImages() const
{
    return  m_listVisibleImages;
}

void FullCache::setListVisibleImages(const QList<bool> &visibles)
{
    m_listVisibleImages = visibles;
    emit listVisibleImagesChanged();
}

QList<QString>FullCache::trackableNames() const
{
    return  m_trackableNames;
}

void FullCache::setTrackableNames(const QList<QString> &names)
{
    m_trackableNames = names;
    emit trackableNamesChanged();
}

QList<QString>FullCache::trackableCodes() const
{
    return  m_trackableCodes;
}

void FullCache::setTrackableCodes(const QList<QString> &codes)
{
    m_trackableCodes = codes;
    emit trackableCodesChanged();
}

QJsonArray FullCache::trackablesJson() const
{
    return  m_trackablesJson;
}

void FullCache::setTrackablesJson(const QJsonArray &trackablesJson)
{
    m_trackablesJson = trackablesJson;
    emit trackablesJsonChanged();
}
