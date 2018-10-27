#include "fullcache.h"

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
    ,  m_state()
    , m_location("")
    , m_favorited(false)
    , m_longDescription("")
    , m_shortDescription("")
    , m_longDescriptionIsHtml(false)
    , m_shortDescriptionIsHtml(false)
    , m_hints("")
    , m_note("")
    , m_imagesName(QList<QString>())
    , m_imagesDescription(QList<QString>())
    , m_imagesUrl(QList<QString>())
    , m_findersName(QList<QString>())
    , m_findersDate(QList<QString>())
    , m_findersCount(QList<int>())
    , m_logsType(QList<QString>())
    , m_logs(QList<QString>())

{
    m_networkManager = new QNetworkAccessManager(this);
    connect( m_networkManager, &QNetworkAccessManager::finished, this, &FullCache::onReplyFinished);

    m_mapLogType.insert("Trouvée",2);
    m_mapLogType.insert("Non trouvée",3);
    m_mapLogType.insert("Note",4);
    m_mapLogType.insert("Publiée",1003);
    m_mapLogType.insert("Activée",23 );
    m_mapLogType.insert("Désactivée",22 );
    m_mapLogType.insert("Participera",9 );
    m_mapLogType.insert("A participé",10);
    m_mapLogType.insert("Récupéré",13 );
    m_mapLogType.insert("Déposé", 14 );
    m_mapLogType.insert("Pris ailleurs",19 );
    m_mapLogType.insert("Ajouté à une collection",69);
    m_mapLogType.insert("Ajouté à l\'inventaire",70);
    m_mapLogType.insert("Maintenance effectuée",46  );
    m_mapLogType.insert("Nécessite une maintenance",45 );
    m_mapLogType.insert("Coordonnées mises à jour",47 );
    m_mapLogType.insert("Archivée",5  );
    m_mapLogType.insert("Désarchivée",12  );
    m_mapLogType.insert("Nécessite d\'être archivée",7 );
    m_mapLogType.insert("Découverte",48 );
    m_mapLogType.insert("Note du relecteur",18);
    m_mapLogType.insert("Soumettre pour examen",76  );
    m_mapLogType.insert("Visite retirée",25 );
    m_mapLogType.insert("Marquer comme absente",16 );
    m_mapLogType.insert("Photo prise par la webcam", 11);

}

void FullCache::sendRequest( QString token)
{
    // Inform QML we are loading
    setState("loading");

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

void FullCache::onReplyFinished(QNetworkReply *reply)
{
    QJsonDocument dataJsonDoc;
    if (reply->error() == QNetworkReply::NoError) {
        dataJsonDoc = QJsonDocument::fromJson(reply->readAll());
        qDebug() << "*** Cache ***\n" <<dataJsonDoc ;
        if (dataJsonDoc.isNull()) {
            return;
        }
        QJsonObject JsonObj = dataJsonDoc.object();
        QJsonValue value = JsonObj.value("Geocaches");
        QJsonArray caches = value.toArray();

        int lengthCaches = caches.size();
        if (lengthCaches == 0) {
            return ;
        }

        foreach ( const QJsonValue & v, caches)
        {
            setArchived(v.toObject().value("Archived").toBool());
            setDisabled(v.toObject().value("Available").toBool());

            QJsonObject v1 = v.toObject().value("Owner").toObject();
            QString owner = v1.value("UserName").toString();
            setOwner(owner);

            QString date(v.toObject().value("DateCreated").toString());
            setDate(date);

            QJsonObject v2 = v.toObject().value("CacheType").toObject();
            int cacheTypeId= v2.value("GeocacheTypeId").toInt();
            setType(cacheTypeId);

            QString code(v.toObject().value("Code").toString());
            setGeocode(code);

            QJsonObject v3 = v.toObject().value("ContainerType").toObject();
            int cacheSizeId= v3.value("ContainerTypeId").toInt();
            setSize(cacheSizeId);

            setDifficulty(v.toObject().value("Difficulty").toDouble());
            setFavoritePoints(v.toObject().value("FavoritePoints").toInt());
            setLat(v.toObject().value("Latitude").toDouble());
            setLon(v.toObject().value("Longitude").toDouble());

            setName(v.toObject().value("Name").toString());

            setTrackableCount(v.toObject().value("TrackableCount").toInt());
            setFound(v.toObject().value("HasbeenFoundbyUser").toBool());
            setTerrain(v.toObject().value("Terrain").toDouble());

            // Attributes of cache.
            m_attributes.clear();
            m_attributesBool.clear();

            QJsonArray  atts = v.toObject().value("Attributes").toArray();
            foreach ( const QJsonValue & att, atts)
            {
                m_attributes.append(att.toObject().value("AttributeTypeID").toInt());
                m_attributesBool.append(att.toObject().value("IsOn").toBool());
            }
            qDebug() << "*** attributs**\n" <<m_attributes ;
            qDebug() << "*** attributsBool**\n" <<m_attributesBool ;
            emit attributesChanged();
            emit attributesBoolChanged();

            //State
            setLocation(v.toObject().value("State").toString());

            // Favorited
            setFavorited(v.toObject().value("HasbeenFavoritedbyUser").toBool());

            // Short description
            setShortDescriptionIsHtml(v.toObject().value("ShortDescriptionIsHtml").toBool());
            setShortDescription(v.toObject().value("ShortDescription").toString());

            // Long description
            setLongDescriptionIsHtml(v.toObject().value("LongDescriptionIsHtml").toBool());
            setLongDescription(v.toObject().value("LongDescription").toString());

            // Hints
            setHints(v.toObject().value("EncodedHints").toString());

            // Note
            m_note = "";
            if ( !v.toObject().value("GeocacheNote").toString().isNull()) {
                setNote(v.toObject().value("GeocacheNote").toString());
            }

            // Images
            m_imagesName.clear();
            m_imagesDescription.clear();
            m_imagesUrl.clear();

            QJsonArray  images = v.toObject().value("Images").toArray();
            foreach ( const QJsonValue & image, images)
            {
                m_imagesName.append(image.toObject().value("Name").toString());
                m_imagesDescription.append(image.toObject().value("Description").toString());
                m_imagesUrl.append(image.toObject().value("MobileUrl").toString());

            }
            qDebug() << "*** imagesName**\n" <<m_imagesName ;
            qDebug() << "*** imagesDescription**\n" <<m_imagesDescription ;
            qDebug() << "*** imagesUrl**\n" <<m_imagesUrl ;

            // Logs
            m_findersCount.clear();
            m_findersDate.clear();
            m_findersName.clear();
            m_logs.clear()  ;
            m_logsType.clear();

            QJsonArray  geocacheLogs = v.toObject().value("GeocacheLogs").toArray();
            foreach ( const QJsonValue & geocacheLog, geocacheLogs)
            {
                m_logs.append(geocacheLog.toObject().value("LogText").toString());
                m_findersDate.append(geocacheLog.toObject().value("VisitDateIso").toString());

                QJsonObject finder = geocacheLog.toObject().value("Finder").toObject();
                m_findersName.append(finder.value("UserName").toString());
                m_findersCount.append(finder.value("FindCount").toInt());

                QJsonObject type = geocacheLog.toObject().value("LogType").toObject();
                m_logsType.append(m_mapLogType.key(type.value("WptLogTypeId").toInt()));

                QJsonArray  logsImage = geocacheLog.toObject().value("Images").toArray();
                foreach ( const QJsonValue & logImage, logsImage)
                {
                    m_imagesName.append(logImage.toObject().value("Name").toString());
                    m_imagesDescription.append(logImage.toObject().value("Description").toString());
                    m_imagesUrl.append(logImage.toObject().value("MobileUrl").toString());
                }

            }
            emit imagesNameChanged();
            emit imagesDescriptionChanged();
            emit imagesUrlChanged();

            emit logsChanged();
            emit logsTypeChanged();
            emit findersCountChanged();
            emit findersDateChanged();
            emit findersNameChanged();

        }

    }   else {
        qDebug() << "*** Cache ERROR ***\n" <<reply->errorString() ;
        return;
    }

    // Inform the QML we are loaded
    setState("loaded");
    return;
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

QString FullCache::state() const
{
    return m_state;
}

void FullCache::setState(const QString &state)
{
    m_state = state;
    emit stateChanged();
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

QList<QString> FullCache::imagesDescription() const
{
    return  m_imagesDescription;
}

void FullCache::setImagesDescription(const QList<QString> &descriptions)
{
    m_imagesDescription = descriptions;
    emit imagesDescriptionChanged();
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







