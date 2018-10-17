#ifndef FULLCACHE_H
#define FULLCACHE_H

#include <QNetworkReply>
#include <QObject>

#include "cache.h"

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

public:
    explicit FullCache(Cache *parent = nullptr);

    Q_INVOKABLE void sendRequest(QString token);

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

protected:
    const int MAX_PER_PAGE=40;
    const int GEOCACHE_LOG_COUNT=30;
    const int TRACKABLE_LOG_COUNT=30;

    QList<int> m_attributes;
    QList<bool> m_attributesBool;

private:    
    //  network manager

    QNetworkAccessManager *m_networkManager;

    QString m_state;
    QString m_location;
    bool m_favorited;
    QString m_longDescription;
    QString m_shortDescription;
    bool m_longDescriptionIsHtml;
    bool m_shortDescriptionIsHtml;
    QString m_hints;
};

#endif // FULLCACHE_H
