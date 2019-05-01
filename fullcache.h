#ifndef FULLCACHE_H
#define FULLCACHE_H

#include <QNetworkReply>
#include <QObject>

#include "cache.h"
#include "sqlitestorage.h"

static constexpr int MAX_PER_PAGE = 40;
static constexpr int GEOCACHE_LOG_COUNT = 30;
static constexpr int TRACKABLE_LOG_COUNT = 30;

class FullCache : public Cache
{
    Q_OBJECT

    Q_PROPERTY(QString state READ state WRITE setState NOTIFY stateChanged)
    Q_PROPERTY(QList<int> attributes READ attributes WRITE setAttributes NOTIFY attributesChanged)
    Q_PROPERTY(QList<bool> attributesBool READ attributesBool WRITE setAttributesBool NOTIFY attributesBoolChanged)
    Q_PROPERTY(QString location READ location WRITE setLocation NOTIFY locationChanged)
    Q_PROPERTY(bool favorited READ favorited WRITE setFavorited NOTIFY favoritedChanged)
    Q_PROPERTY(QString longDescription READ longDescription WRITE setLongDescription NOTIFY longDescriptionChanged)
    Q_PROPERTY(bool longDescriptionIsHtml READ longDescriptionIsHtml WRITE setLongDescriptionIsHtml NOTIFY longDescriptionIsHtmlChanged)
    Q_PROPERTY(QString shortDescription READ shortDescription WRITE setShortDescription NOTIFY shortDescriptionChanged)
    Q_PROPERTY(bool shortDescriptionIsHtml READ shortDescriptionIsHtml WRITE setShortDescriptionIsHtml NOTIFY shortDescriptionIsHtmlChanged)
    Q_PROPERTY(QString hints READ hints WRITE setHints NOTIFY hintsChanged)
    Q_PROPERTY(QString note READ note WRITE setNote NOTIFY noteChanged)
    Q_PROPERTY(QList<QString > imagesName READ imagesName WRITE setImagesName NOTIFY imagesNameChanged)
    Q_PROPERTY(QList<QString > imagesDescription READ imagesDescription WRITE setImagesDescription NOTIFY imagesDescriptionChanged)
    Q_PROPERTY(QList<QString > imagesUrl READ imagesUrl WRITE setImagesUrl NOTIFY imagesUrlChanged)
    Q_PROPERTY(QList<QString > findersName READ findersName WRITE setFindersName NOTIFY findersNameChanged)
    Q_PROPERTY(QList<QString > logs READ logs WRITE setLogs NOTIFY logsChanged)
    Q_PROPERTY(QList<QString > logsType READ logsType WRITE setLogsType NOTIFY logsTypeChanged)
    Q_PROPERTY(QList<int > findersCount READ findersCount WRITE setFindersCount NOTIFY findersCountChanged)
    Q_PROPERTY(QList<QString > findersDate READ findersDate WRITE setFindersDate NOTIFY findersDateChanged)
    Q_PROPERTY(QList<int > cacheImagesIndex READ cacheImagesIndex WRITE setCacheImagesIndex NOTIFY cacheImagesIndexChanged)
    Q_PROPERTY(QList<bool > listVisibleImages READ listVisibleImages WRITE setListVisibleImages NOTIFY listVisibleImagesChanged)
    Q_PROPERTY(QList<QString > wptsDescription READ wptsDescription WRITE setWptsDescription NOTIFY wptsDescriptionChanged)
    Q_PROPERTY(QList<QString > wptsName READ wptsName WRITE setWptsName NOTIFY wptsNameChanged)
    Q_PROPERTY(QList<double > wptsLat READ wptsLat WRITE setWptsLat NOTIFY wptsLatChanged)
    Q_PROPERTY(QList<double > wptsLon READ wptsLon WRITE setWptsLon NOTIFY wptsLonChanged)
    Q_PROPERTY(QList<QString > wptsComment READ wptsComment WRITE setWptsComment NOTIFY wptsCommentChanged)

public:
    explicit FullCache(Cache *parent = nullptr);

    Q_INVOKABLE void sendRequest(QString token);
    Q_INVOKABLE void writeToStorage();
    bool readFromStorage();

    QList<int> attributes() const;
    void setAttributes(const QList<int> &attributes);

    QList<bool> attributesBool() const;
    void setAttributesBool(const  QList<bool> &attributesBool);

    QString state() const;
    void setState(const QString &state);

    QString location() const;
    void setLocation(const QString &location);

    bool favorited() const;
    void setFavorited(const bool &favor);

    QString longDescription() const;
    void setLongDescription(const QString &description);

    QString shortDescription() const;
    void setShortDescription(const QString &description);

    bool longDescriptionIsHtml() const;
    void setLongDescriptionIsHtml(const bool &html);

    bool shortDescriptionIsHtml() const;
    void setShortDescriptionIsHtml(const bool &html);

    QString hints() const;
    void setHints(const QString &hint);

    QString note() const;
    void setNote(const QString &note);

    QList<QString> imagesName() const;
    void setImagesName(const QList<QString> &names);

    QList<QString> imagesDescription() const;
    void setImagesDescription(const QList<QString> &descriptions);

    QList<QString> imagesUrl() const;
    void setImagesUrl(const QList<QString> &urls);

    QList<QString> findersName() const;
    void setFindersName(const QList<QString> &names);

    QList<int> findersCount() const;
    void setFindersCount(const QList<int> &counts);

    QList<QString> findersDate() const;
    void setFindersDate(const QList<QString> &dates);

    QList<QString> logsType() const;
    void setLogsType(const QList<QString> &types);

    QList<QString> logs() const;
    void setLogs(const QList<QString> &logs);

    QList<QString> wptsDescription() const;
    void setWptsDescription(const QList<QString> &descriptions);

    QList<QString> wptsName() const;
    void setWptsName(const QList<QString> &names);

    QList<double> wptsLat() const;
    void setWptsLat(const QList<double> &lats);

    QList<double> wptsLon() const;
    void setWptsLon(const QList<double> &lons);

    QList<QString> wptsComment() const;
    void setWptsComment(const QList<QString> &comments);

    QList<int> cacheImagesIndex() const;
    void setCacheImagesIndex(const QList<int> &ints);

    QList<bool> listVisibleImages() const;
    Q_INVOKABLE   void setListVisibleImages(const QList<bool> &visibles);

public slots:
    void onReplyFinished(QNetworkReply* reply)  ;

signals:
    void stateChanged();
    void attributesChanged();
    void attributesBoolChanged();
    void locationChanged();
    void favoritedChanged();
    void longDescriptionChanged();
    void shortDescriptionChanged();
    void longDescriptionIsHtmlChanged();
    void shortDescriptionIsHtmlChanged();
    void hintsChanged();
    void noteChanged();
    void imagesNameChanged();
    void imagesDescriptionChanged();
    void imagesUrlChanged();
    void findersNameChanged();
    void logsChanged();
    void logsTypeChanged();
    void findersCountChanged();
    void findersDateChanged();
    void wptsDescriptionChanged();
    void wptsNameChanged();
    void wptsLatChanged();
    void wptsLonChanged();
    void wptsCommentChanged();
    void cacheImagesIndexChanged();
    void listVisibleImagesChanged();

private:

    // Properties
    QString m_state;
    QList<int> m_attributes;
    QList<bool> m_attributesBool;
    QString m_location;
    bool m_favorited;
    QString m_longDescription;
    bool m_longDescriptionIsHtml;
    QString m_shortDescription;
    bool m_shortDescriptionIsHtml;
    QString m_hints;
    QString m_note;
    QList<QString> m_imagesName;
    QList<QString> m_imagesDescription;
    QList<QString> m_imagesUrl;
    QList<QString> m_findersName;
    QList<QString> m_logs;
    QList<QString> m_logsType;
    QList<int> m_findersCount;
    QList<QString> m_findersDate;
    QList<int> m_cacheImagesIndex;
    QList<bool> m_listVisibleImages;
    QList<QString> m_wptsDescription;
    QList<QString> m_wptsName;
    QList<double> m_wptsLat;
    QList<double> m_wptsLon;
    QList<QString> m_wptsComment;

    // Type of logs falitator
    const QMap<QString, int> m_mapLogType;

    // Network manager
    QNetworkAccessManager *m_networkManager;

    // Sqlite storage
    SQLiteStorage *m_storage;
};

#endif // FULLCACHE_H
