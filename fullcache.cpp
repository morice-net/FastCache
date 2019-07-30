#include "fullcache.h"

FullCache::FullCache(Cache *parent)
    :  Cache (parent)
    ,  m_attributes(QList<int>())
    ,  m_attributesBool(QList<bool>())
    , m_note("")
    , m_imagesName(QList<QString>())
    , m_imagesUrl(QList<QString>())
    , m_cacheImagesIndex(QList<int>())
    , m_findersName(QList<QString>())
    , m_logs(QList<QString>())
    , m_logsType(QList<QString>())
    , m_findersCount(QList<int>())
    , m_listVisibleImages(QList<bool>())
    , m_wptsDescription(QList<QString>())
    , m_wptsName(QList<QString>())
    , m_wptsLat(QList<double>())
    , m_wptsLon(QList<double>())
    , m_wptsComment(QList<QString>())
    , m_trackableNames(QList<QString>())
    , m_trackableCodes(QList<QString>())
    , m_findersDate(QList<QString>())
    , m_location("")
    , m_favorited(false)
    , m_longDescription("")
    , m_longDescriptionIsHtml(false)
    , m_shortDescription("")
    , m_shortDescriptionIsHtml(false)
    , m_hints("")
    , m_userWptsDescription(QList<QString>())
    , m_userWptsLat(QList<double>())
    , m_userWptsLon(QList<double>())
    , m_userWptsCode(QList<QString>())
    , m_isCorrectedCoordinates(false)
    , m_correctedLat(0.0)
    , m_correctedLon(0.0)
    , m_correctedCode("")
{
}

void FullCache::removeUserWpt(int index)
{
    m_userWptsLat.removeAt(index);
    m_userWptsLon.removeAt(index);
    m_userWptsCode.removeAt(index);
    m_userWptsDescription.removeAt(index);

    emit userWptsLatChanged();
    emit userWptsLonChanged();
    emit userWptsCodeChanged();
    emit userWptsDescriptionChanged();
}

void FullCache::removeCorrectedcoordinates()
{
    setIsCorrectedCoordinates(false);
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

QList<QString>FullCache::userWptsDescription() const
{
    return  m_userWptsDescription;
}

void FullCache::setUserWptsDescription(const QList<QString> &descriptions)
{
    m_userWptsDescription = descriptions;
    emit userWptsDescriptionChanged();
}

QList<double>FullCache::userWptsLat() const
{
    return  m_userWptsLat;
}

void FullCache::setUserWptsLat(const QList<double> &lats){
    m_userWptsLat = lats;
    emit userWptsLatChanged();
}

QList<double>FullCache::userWptsLon() const
{
    return  m_userWptsLon;
}

void FullCache::setUserWptsLon(const QList<double> &lons){
    m_userWptsLon = lons;
    emit userWptsLonChanged();
}

QList<QString>FullCache::userWptsCode() const
{
    return  m_userWptsCode;
}

void FullCache::setUserWptsCode(const QList<QString> &codes){
    m_userWptsCode = codes;
    emit userWptsCodeChanged();
}


bool FullCache::isCorrectedCoordinates() const
{
    return m_isCorrectedCoordinates;
}

void FullCache::setIsCorrectedCoordinates(const bool &corrected)
{
    m_isCorrectedCoordinates = corrected ;
    emit isCorrectedCoordinatesChanged();
}

double FullCache::correctedLat() const
{
    return m_correctedLat;
}

void FullCache::setCorrectedLat(const double &lat)
{
    m_correctedLat = lat ;
    emit correctedLatChanged();
}

double FullCache::correctedLon() const
{
    return m_correctedLon;
}

void FullCache::setCorrectedLon(const double &lon)
{
    m_correctedLon = lon ;
    emit correctedLonChanged();
}

QString FullCache::correctedCode() const
{
    return m_correctedCode;
}

void FullCache::setCorrectedCode(const QString &code)
{
    m_correctedCode = code ;
    emit correctedCodeChanged();
}

