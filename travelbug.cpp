#include "travelbug.h"
#include "smileygc.h"
#include "constants.h"

Travelbug::Travelbug(Requestor *parent)
    :  Requestor(parent)
    ,  m_name("")
    ,  m_type("")
    ,  m_tbCode("")
    ,  m_iconUrl("")
    ,  m_originalOwner("")
    ,  m_located("")
    ,  m_description("")
    ,  m_originCountry("")
    ,  m_dateCreated("")
    ,  m_goal("")
    , m_imagesName(QList<QString>())
    , m_imagesUrl(QList<QString>())
    , m_logsText(QList<QString>())
    , m_logsType(QList<QString>())
    , m_logsOwnersName(QList<QString>())
    , m_logsOwnersCount(QList<int>())
    , m_logsGeocacheCode(QList<QString>())
    , m_logsGeocacheName(QList<QString>())
    , m_logsDate(QList<QString>())
    , m_tbStatus(0)
    , m_tbIsMissing(false)
    , m_trackingNumber("")
{
}

Travelbug::~Travelbug()
{
}

void Travelbug::sendRequest(QString token , QString trackableCode)
{
    //Build url
    QString requestName = "trackables/";
    requestName.append(trackableCode);

    // Fields
    requestName.append("?fields=referenceCode,name,iconUrl,goal,description,releasedDate,originCountry,ownerCode,holderCode,inHolderCollection,"
                       "currentGeocacheCode,currentGeocacheName,isMissing,trackingNumber,trackableType,owner,holder" );
    // Expand
    requestName.append("&expand=trackablelogs:" + QString::number(TRACKABLE_LOGS_COUNT) + ",images:" + QString::number(IMAGES));

    qDebug() << "URL:" << requestName ;

    // Inform QML we are loading
    setState("loading");

    Requestor::sendGetRequest(requestName , token);
}

void Travelbug::parseJson(const QJsonDocument &dataJsonDoc)
{
    QJsonObject tbJson = dataJsonDoc.object();
    qDebug() << "tbJson:" << tbJson;

    SmileyGc * smileys = new SmileyGc;

    setName(tbJson["name"].toString());
    setTbCode(tbJson["referenceCode"].toString());
    setDateCreated(tbJson["releasedDate"].toString());
    setIconUrl(tbJson["iconUrl"].toString());

    QJsonObject  tbType = tbJson["trackableType"].toObject();
    setType(tbType["name"].toString());

    QJsonObject owner;
    if(!tbJson["owner"].isNull()) {
        owner = tbJson["owner"].toObject();
        setOriginalOwner(owner["username"].toString());
    } else {
        setOriginalOwner("");
        setTbStatus(0);
    }

    if(tbJson["isMissing"].toBool()) {
        setLocated("");
        setTbIsMissing(true);
    }

    if (!tbJson["holder"].isNull()) {
        QJsonObject currentOwner = tbJson["holder"].toObject();
        if(currentOwner["username"].toString() == originalOwner()){
            setLocated("Dans les mains du propriétaire");
            setTbStatus(2);  //travelbug in possession of owner of the trackable
            setTrackingNumber(tbJson["trackingNumber"].toString());
        } else {
            setLocated("En possession de " + currentOwner["username"].toString());
            setTbStatus(3); //travelbug in possession of holder of the trackable
        }
    }
    else if(tbJson["holder"].isNull()){
        if(!tbJson["currentGeocacheCode"].isNull()) {
            setLocated("Dans la cache " + tbJson["currentGeocacheCode"].toString());
            setTbStatus(1);  // travelbug in cache
        } else {
            setLocated("");
            setTbStatus(0);
        }
    }

    if(!tbJson["goal"].isNull()) {
        setGoal(tbJson["goal"].toString());
    } else {
        setGoal("");
    }

    if(!tbJson["originCountry"].isNull()) {
        setOriginCountry(tbJson["originCountry"].toString());
    } else {
        setOriginCountry("");
    }

    if(!tbJson["description"].isNull()) {
        setDescription(tbJson["description"].toString());
    } else {
        setDescription("");
    }

    //images
    m_imagesName.clear();
    m_imagesUrl.clear();

    QJsonArray array = tbJson["images"].toArray();
    for (const QJsonValue &image: qAsConst(array))
    {
        m_imagesName.append(smileys->replaceSmileyTextToImgSrc(image["description"].toString()));
        m_imagesUrl.append(image["url"].toString());
    }
    emit imagesNameChanged();
    emit imagesUrlChanged();

    // Logs
    m_logsText.clear()  ;
    m_logsType.clear();
    m_logsDate.clear()  ;
    m_logsOwnersName.clear();
    m_logsOwnersCount.clear();
    m_logsGeocacheName.clear();
    m_logsGeocacheCode.clear();

    QJsonArray tbLogs = tbJson["trackableLogs"].toArray();
    qDebug() << "tbLogs:" << tbLogs;

    for (QJsonValue tbLog: qAsConst(tbLogs))
    {
        m_logsText.append(smileys->replaceSmileyTextToImgSrc(tbLog["text"].toString()));
        m_logsDate.append(tbLog["loggedDate"].toString());
        m_logsGeocacheCode.append(tbLog["geocacheCode"].toString());
        m_logsGeocacheName.append(tbLog["geocacheName"].toString());

        QJsonObject finder = tbLog.toObject()["owner"].toObject();
        m_logsOwnersName.append(finder["username"].toString());
        m_logsOwnersCount.append(finder["findCount"].toInt());

        QJsonObject type = tbLog["trackableLogType"].toObject();
        m_logsType.append(LOG_TYPE_TB_MAP.key(type["id"].toInt()));
    }

    delete smileys;

    emit logsTextChanged();
    emit logsTypeChanged();
    emit logsDateChanged();
    emit logsOwnersNameChanged();
    emit logsOwnersCountChanged();
    emit logsGeocacheCodeChanged();
    emit logsGeocacheNameChanged();

    // request success
    emit requestReady();
    return ;
}

/** Getters & Setters **/

QString Travelbug::name() const
{
    return m_name;
}

void Travelbug::setName(const QString &name)
{
    m_name = name;
    emit nameChanged();
}

QString Travelbug::type() const
{
    return m_type;
}

void Travelbug::setType(const QString &type)
{
    m_type = type;
    emit typeChanged();
}

QString Travelbug::tbCode() const
{
    return m_tbCode;
}

void Travelbug::setTbCode(const QString &code)
{
    m_tbCode = code;
    emit tbCodeChanged();
}

QString Travelbug::iconUrl() const
{
    return m_iconUrl;
}

void Travelbug::setIconUrl(const QString &url)
{
    m_iconUrl = url;
    emit iconUrlChanged();
}

QString Travelbug::originalOwner() const
{
    return m_originalOwner;
}

void Travelbug::setOriginalOwner(const QString &owner)
{
    m_originalOwner = owner;
    emit originalOwnerChanged();
}

QString Travelbug::located() const
{
    return m_located;
}

void Travelbug::setLocated(const QString &location)
{
    m_located = location;
    emit locatedChanged();
}

QString Travelbug::description () const
{
    return m_description;
}

void Travelbug::setDescription(const QString &description)
{
    m_description= description;
    emit descriptionChanged();
}

QString Travelbug::dateCreated() const
{
    return m_dateCreated;
}

void Travelbug::setDateCreated(const QString &date)
{
    m_dateCreated= date;
    emit dateCreatedChanged();
}

QString Travelbug::goal() const
{
    return m_goal;
}

void Travelbug::setGoal(const QString &goal)
{
    m_goal= goal;
    emit goalChanged();
}

QString Travelbug::originCountry() const
{
    return m_originCountry;
}

void Travelbug::setOriginCountry(const QString &country)
{
    m_originCountry= country;
    emit originCountryChanged();
}

QList<QString> Travelbug::imagesName() const
{
    return  m_imagesName;
}

void Travelbug::setImagesName(const QList<QString> &names)
{
    m_imagesName = names;
    emit imagesNameChanged();
}

QList<QString>Travelbug::imagesUrl() const
{
    return  m_imagesUrl;
}

void Travelbug::setImagesUrl(const QList<QString> &urls)
{
    m_imagesUrl = urls;
    emit imagesUrlChanged();
}

QList<QString>Travelbug::logsText() const
{
    return  m_logsText;
}

void Travelbug::setLogsText(const QList<QString> &logsText)
{
    m_logsText = logsText;
    emit logsTextChanged();
}

QList<QString>Travelbug::logsType() const
{
    return  m_logsType;
}

void Travelbug::setLogsType(const QList<QString> &types)
{
    m_logsType = types;
    emit logsTypeChanged();
}

QList<QString>Travelbug::logsOwnersName() const
{
    return  m_logsOwnersName;
}

void Travelbug::setLogsOwnersName(const QList<QString> &names)
{
    m_logsOwnersName = names;
    emit logsOwnersNameChanged();
}

QList<int>Travelbug::logsOwnersCount() const
{
    return  m_logsOwnersCount;
}

void Travelbug::setLogsOwnersCount(const QList<int> &counts)
{
    m_logsOwnersCount = counts;
    emit logsOwnersCountChanged();
}

QList<QString>Travelbug::logsGeocacheCode() const
{
    return  m_logsGeocacheCode;
}

void Travelbug::setLogsGeocacheCode(const QList<QString> &code)
{
    m_logsGeocacheCode = code;
    emit logsGeocacheCodeChanged();
}

QList<QString>Travelbug::logsGeocacheName() const
{
    return  m_logsGeocacheName;
}

void Travelbug::setLogsGeocacheName(const QList<QString> &name)
{
    m_logsGeocacheName = name;
    emit logsGeocacheNameChanged();
}

QList<QString>Travelbug::logsDate() const
{
    return  m_logsDate;
}

void Travelbug::setLogsDate(const QList<QString> &dates)
{
    m_logsDate = dates;
    emit logsDateChanged();
}

int Travelbug::tbStatus() const
{
    return  m_tbStatus;
}

void Travelbug::setTbStatus(const int &status)
{
    m_tbStatus = status;
    emit tbStatusChanged();
}

bool Travelbug::tbIsMissing() const
{
    return  m_tbIsMissing;
}

void Travelbug::setTbIsMissing(const bool &missing)
{
    m_tbIsMissing = missing;
    emit tbIsMissingChanged();
}

QString Travelbug::trackingNumber() const
{
    return  m_trackingNumber;
}

void Travelbug::setTrackingNumber(const QString &number)
{
    m_trackingNumber = number;
    emit trackingNumberChanged();
}
