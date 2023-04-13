#ifndef FULLCACHE_H
#define FULLCACHE_H

#include "cache.h"

class FullCache : public Cache
{
    Q_OBJECT

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
    Q_PROPERTY(QList<QString > wptsIcon READ wptsIcon WRITE setWptsIcon NOTIFY wptsIconChanged)
    Q_PROPERTY(QList<double > wptsLat READ wptsLat WRITE setWptsLat NOTIFY wptsLatChanged)
    Q_PROPERTY(QList<double > wptsLon READ wptsLon WRITE setWptsLon NOTIFY wptsLonChanged)
    Q_PROPERTY(QList<QString > wptsComment READ wptsComment WRITE setWptsComment NOTIFY wptsCommentChanged)
    Q_PROPERTY(QList<QString > trackableNames READ trackableNames WRITE setTrackableNames NOTIFY trackableNamesChanged)
    Q_PROPERTY(QList<QString > trackableCodes READ trackableCodes WRITE setTrackableCodes NOTIFY trackableCodesChanged)
    Q_PROPERTY(QList<QString > userWptsDescription READ userWptsDescription WRITE setUserWptsDescription NOTIFY userWptsDescriptionChanged)
    Q_PROPERTY(QList<double > userWptsLat READ userWptsLat WRITE setUserWptsLat NOTIFY userWptsLatChanged)
    Q_PROPERTY(QList<double > userWptsLon READ userWptsLon WRITE setUserWptsLon NOTIFY userWptsLonChanged)
    Q_PROPERTY(QList<QString > userWptsCode READ userWptsCode WRITE setUserWptsCode NOTIFY userWptsCodeChanged)
    Q_PROPERTY(bool isCorrectedCoordinates READ isCorrectedCoordinates WRITE setIsCorrectedCoordinates NOTIFY isCorrectedCoordinatesChanged)
    Q_PROPERTY(double correctedLat READ correctedLat WRITE setCorrectedLat NOTIFY correctedLatChanged)
    Q_PROPERTY(double correctedLon READ correctedLon WRITE setCorrectedLon NOTIFY correctedLonChanged)
    Q_PROPERTY(QString correctedCode READ correctedCode WRITE setCorrectedCode NOTIFY correctedCodeChanged)

public:
    explicit FullCache(Cache *parent = nullptr);

    Q_INVOKABLE void removeUserWpt(int index);
    Q_INVOKABLE void removeCorrectedcoordinates();

    QList<int> attributes() const;
    void setAttributes(const QList<int> &attributes);

    QList<bool> attributesBool() const;
    void setAttributesBool(const  QList<bool> &attributesBool);

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
    void setImagesName(const QList<QString> &trackableNames);

    QList<QString> imagesUrl() const;
    void setImagesUrl(const QList<QString> &urls);

    QList<QString> findersName() const;
    void setFindersName(const QList<QString> &trackableNames);

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

    QList<QString> wptsIcon() const;
    void setWptsIcon(const QList<QString> &icons);

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

    QList<QString > trackableNames() const;
    void setTrackableNames(const QList<QString > &trackableNames);

    QList<QString > trackableCodes() const;
    void setTrackableCodes(const QList<QString > &codes);

    QList<QString > userWptsDescription() const;
    void setUserWptsDescription(const QList<QString > &descriptions);

    QList<double >  userWptsLat() const;
    void setUserWptsLat(const QList<double > &lats);

    QList<double >  userWptsLon() const;
    void setUserWptsLon(const QList<double > &lons);

    QList<QString >  userWptsCode() const;
    void setUserWptsCode(const QList<QString > &codes);

    bool isCorrectedCoordinates() const;
    void setIsCorrectedCoordinates(const bool &corrected);

    double correctedLat() const;
    void setCorrectedLat(const double &lat);

    double correctedLon() const;
    void setCorrectedLon(const double &lon);

    QString correctedCode() const;
    void setCorrectedCode(const QString &code);

signals:
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
    void imagesUrlChanged();
    void findersNameChanged();
    void logsChanged();
    void logsTypeChanged();
    void findersCountChanged();
    void findersDateChanged();
    void wptsDescriptionChanged();
    void wptsNameChanged();
    void wptsIconChanged();
    void wptsLatChanged();
    void wptsLonChanged();
    void wptsCommentChanged();
    void cacheImagesIndexChanged();
    void listVisibleImagesChanged();
    void trackableNamesChanged();
    void trackableCodesChanged();
    void userWptsDescriptionChanged();
    void userWptsLatChanged();
    void userWptsLonChanged();
    void userWptsCodeChanged();
    void isCorrectedCoordinatesChanged();
    void correctedLatChanged();
    void correctedLonChanged();
    void correctedCodeChanged();

private:
    QList<int> m_attributes;
    QList<bool> m_attributesBool;
    QString m_note;
    QList<QString> m_imagesName;
    QList<QString> m_imagesUrl;
    QList<int> m_cacheImagesIndex;
    QList<QString> m_findersName;
    QList<QString> m_logs;
    QList<QString> m_logsType;
    QList<int> m_findersCount;
    QList<bool> m_listVisibleImages;
    QList<QString> m_wptsDescription;
    QList<QString> m_wptsName;
    QList<QString> m_wptsIcon;
    QList<double> m_wptsLat;
    QList<double> m_wptsLon;
    QList<QString> m_wptsComment;
    QList<QString > m_trackableNames;
    QList<QString > m_trackableCodes;
    QList<QString> m_findersDate;
    QString m_location;
    bool m_favorited;
    QString m_longDescription;
    bool m_longDescriptionIsHtml;
    QString m_shortDescription;
    bool m_shortDescriptionIsHtml;
    QString m_hints;
    QList<QString > m_userWptsDescription;
    QList<double > m_userWptsLat;
    QList<double > m_userWptsLon;
    QList<QString > m_userWptsCode;
    bool m_isCorrectedCoordinates;
    double m_correctedLat;
    double m_correctedLon;
    QString m_correctedCode;
};
#endif // FULLCACHE_H
