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
    Q_PROPERTY(int type READ type WRITE setType NOTIFY typeChanged)
    Q_PROPERTY(QString trackingCode READ trackingCode WRITE setTrackingCode NOTIFY trackingCodeChanged)
    Q_PROPERTY(QString owner READ owner WRITE setOwner NOTIFY ownerChanged)
    Q_PROPERTY(QString located READ located WRITE setLocated NOTIFY locatedChanged)
    Q_PROPERTY(QString origin READ origin WRITE setOrigin NOTIFY originChanged)
    Q_PROPERTY(QString released READ released WRITE setReleased NOTIFY releasedChanged)
    Q_PROPERTY(QString goal READ goal WRITE setGoal NOTIFY goalChanged)
    Q_PROPERTY(QList<QString > imagesName READ imagesName WRITE setImagesName NOTIFY imagesNameChanged)
    Q_PROPERTY(QList<QString > imagesDescription READ imagesDescription WRITE setImagesDescription NOTIFY imagesDescriptionChanged)
    Q_PROPERTY(QList<QString > imagesUrl READ imagesUrl WRITE setImagesUrl NOTIFY imagesUrlChanged)
    Q_PROPERTY(QList<QString > logs READ logs WRITE setLogs NOTIFY logsChanged)
    Q_PROPERTY(QList<QString > logsType READ logsType WRITE setLogsType NOTIFY logsTypeChanged)

public:
    explicit  Travelbug(QObject *parent = nullptr);
    ~Travelbug();

    Q_INVOKABLE void parseTrackable(QString trackableCode, QJsonArray trackables);

    QString name() const;
    void setName(const QString &name);

    int  type() const;
    void setType(const int &type);

    QString trackingCode() const;
    void setTrackingCode(const QString &code);

    QString owner() const;
    void setOwner(const QString &owner);

    QString located() const;
    void setLocated(const QString &location);

    QString origin() const;
    void setOrigin(const QString &origin);

    QString released() const;
    void setReleased(const QString &release);

    QString goal() const;
    void setGoal(const QString &goal);

    QList<QString > imagesName() const;
    void setImagesName(const QList<QString > &names);

    QList<QString > imagesUrl() const;
    void setImagesUrl(const QList<QString > &urls);

    QList<QString > imagesDescription() const;
    void setImagesDescription(const QList<QString > &descriptions);

    QList<QString > logs() const;
    void setLogs(const QList<QString > &logs);

    QList<QString > logsType() const;
    void setLogsType(const QList<QString > &types);

signals:
    void nameChanged();
    void typeChanged();
    void trackingCodeChanged();
    void ownerChanged();
    void locatedChanged();
    void originChanged();
    void releasedChanged();
    void goalChanged();
    void imagesNameChanged();
    void imagesDescriptionChanged();
    void imagesUrlChanged();
    void logsChanged();
    void logsTypeChanged();

protected:

    QString m_name;
    int m_type;
    QString m_trackingCode;
    QString m_owner;
    QString m_located;
    QString m_origin;
    QString m_released;
    QString m_goal;
    QList<QString > m_imagesName;
    QList<QString > m_imagesDescription;
    QList<QString > m_imagesUrl;
    QList<QString > m_logs;
    QList<QString > m_logsType;
};

#endif // CACHE_H
