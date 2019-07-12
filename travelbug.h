#ifndef TRAVELBUG_H
#define TRAVELBUG_H

#include "requestor.h"
#include <QMap>

#include <QObject>
#include <QDebug>
#include <QJsonObject>
#include <QJsonArray>

class Travelbug : public Requestor
{
    Q_OBJECT

    Q_PROPERTY(QString name READ name WRITE setName NOTIFY nameChanged)
    Q_PROPERTY(QString type READ type WRITE setType NOTIFY typeChanged)
    Q_PROPERTY(QString tbCode READ tbCode WRITE setTbCode NOTIFY tbCodeChanged)
    Q_PROPERTY(QString iconUrl READ iconUrl WRITE setIconUrl NOTIFY iconUrlChanged)
    Q_PROPERTY(QString originalOwner READ originalOwner WRITE setOriginalOwner NOTIFY originalOwnerChanged)
    Q_PROPERTY(QString located READ located WRITE setLocated NOTIFY locatedChanged)
    Q_PROPERTY(QString originCountry READ originCountry  WRITE setOriginCountry  NOTIFY originCountryChanged)
    Q_PROPERTY(QString description READ description  WRITE setDescription  NOTIFY descriptionChanged)
    Q_PROPERTY(QString dateCreated READ dateCreated  WRITE setDateCreated NOTIFY dateCreatedChanged)
    Q_PROPERTY(QString goal READ goal WRITE setGoal NOTIFY goalChanged)
    Q_PROPERTY(QList<QString > imagesName READ imagesName WRITE setImagesName NOTIFY imagesNameChanged)
    Q_PROPERTY(QList<QString > imagesUrl READ imagesUrl WRITE setImagesUrl NOTIFY imagesUrlChanged)
    Q_PROPERTY(QList<QString > logsText READ logsText WRITE setLogsText NOTIFY logsTextChanged)
    Q_PROPERTY(QList<QString > logsType READ logsType WRITE setLogsType NOTIFY logsTypeChanged)
    Q_PROPERTY(QList<QString > logsOwnersName READ logsOwnersName WRITE setLogsOwnersName NOTIFY logsOwnersNameChanged)
    Q_PROPERTY(QList<QString > logsDate READ logsDate WRITE setLogsDate NOTIFY logsDateChanged)

public:
    explicit  Travelbug(Requestor *parent = nullptr);
    ~Travelbug() override;

    Q_INVOKABLE void sendRequest(QString token, QString trackableCode );

    void parseJson(const QJsonDocument &dataJsonDoc) override;

    QString name() const;
    void setName(const QString &name);

    QString  type() const;
    void setType(const QString &type);

    QString  originCountry() const;
    void setOriginCountry(const QString &country);

    QString tbCode() const;
    void setTbCode(const QString &code);

    QString iconUrl() const;
    void setIconUrl(const QString &url);

    QString originalOwner() const;
    void setOriginalOwner(const QString &owner);

    QString located() const;
    void setLocated(const QString &location);

    QString description () const;
    void setDescription (const QString &description);

    QString dateCreated () const;
    void setDateCreated (const QString &release);

    QString goal() const;
    void setGoal(const QString &goal);

    QList<QString > imagesName() const;
    void setImagesName(const QList<QString > &names);

    QList<QString > imagesUrl() const;
    void setImagesUrl(const QList<QString > &urls);

    QList<QString > logsText() const;
    void setLogsText(const QList<QString > &logsText);

    QList<QString > logsType() const;
    void setLogsType(const QList<QString > &types);

    QList<QString > logsOwnersName() const;
    void setLogsOwnersName(const QList<QString > &names);

    QList<QString > logsDate() const;
    void setLogsDate(const QList<QString > &dates);

signals:
    void nameChanged();
    void typeChanged();
    void tbCodeChanged();
    void iconUrlChanged();
    void originalOwnerChanged();
    void locatedChanged();
    void descriptionChanged();
    void dateCreatedChanged();
    void originCountryChanged();
    void goalChanged();
    void imagesNameChanged();
    void imagesUrlChanged();
    void logsTextChanged();
    void logsTypeChanged();
    void logsOwnersNameChanged();
    void logsDateChanged();

protected:

    QString m_name;
    QString m_type;
    QString m_tbCode;
    QString m_iconUrl;
    QString m_originalOwner;
    QString m_located;
    QString m_description;
    QString m_originCountry;
    QString m_dateCreated;
    QString m_goal;
    QList<QString > m_imagesName;
    QList<QString > m_imagesUrl;
    QList<QString > m_logsText;
    QList<QString > m_logsType;
    QList<QString > m_logsOwnersName;
    QList<QString > m_logsDate;

    // Type of logs falitator
    const QMap<QString, int> m_mapLogType;
};

#endif // CACHE_H
