#ifndef TRAVELBUG_H
#define TRAVELBUG_H

#include <QObject>
#include <QDebug>
#include <QJsonObject>
#include <QJsonArray>

class Travelbug : public QObject
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
    Q_PROPERTY(QList<QString > logs READ logs WRITE setLogs NOTIFY logsChanged)
    Q_PROPERTY(QList<QString > logsType READ logsType WRITE setLogsType NOTIFY logsTypeChanged)

public:
    explicit  Travelbug(QObject *parent = nullptr);
    ~Travelbug();

    Q_INVOKABLE void parseTrackable(QString trackableCode, QJsonArray trackables);

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

    QList<QString > logs() const;
    void setLogs(const QList<QString > &logs);

    QList<QString > logsType() const;
    void setLogsType(const QList<QString > &types);

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
    void logsChanged();
    void logsTypeChanged();

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
    QList<QString > m_logs;
    QList<QString > m_logsType;
};

#endif // CACHE_H
