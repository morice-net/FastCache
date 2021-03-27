#ifndef GETPOCKETSQUERIESLIST_H
#define GETPOCKETSQUERIESLIST_H

#include "requestor.h"

#include <QNetworkReply>
#include <QObject>

class GetPocketsqueriesList : public Requestor
{
    Q_OBJECT

    Q_PROPERTY(QList<QString> referenceCodes READ referenceCodes WRITE setReferenceCodes NOTIFY referenceCodesChanged)
    Q_PROPERTY(QList<QString> names READ names WRITE setNames NOTIFY namesChanged)
    Q_PROPERTY(QList<QString> descriptions READ descriptions WRITE setDescriptions NOTIFY descriptionsChanged)
    Q_PROPERTY(QList<QString> dates READ dates WRITE setDates NOTIFY datesChanged)
    Q_PROPERTY(QList<int> counts READ counts WRITE setCounts NOTIFY countsChanged)
    Q_PROPERTY(QList<int> findCounts READ findCounts WRITE setFindCounts NOTIFY findCountsChanged)

public:    
    explicit GetPocketsqueriesList(Requestor *parent = nullptr);
    ~GetPocketsqueriesList() override;

    QList<QString> referenceCodes() const;
    void setReferenceCodes(const QList<QString> &codes);

    QList<QString> names() const;
    void setNames(const QList<QString> &names);

    QList<QString> descriptions() const;
    void setDescriptions(const QList<QString> &descriptions);

    QList<QString> dates() const;
    void setDates(const QList<QString> &dates);

    QList<int> counts() const;
    void setCounts(const QList<int> &counts);

    QList<int> findCounts() const;
    void setFindCounts(const QList<int> &findCounts);

    Q_INVOKABLE void sendRequest(QString token);

    void parseJson(const QJsonDocument &dataJsonDoc) override;

signals:
    void referenceCodesChanged();
    void namesChanged();
    void descriptionsChanged();
    void datesChanged();
    void countsChanged();
    void findCountsChanged();

private:
    QList<QString> m_referenceCodes;
    QList<QString> m_names ;
    QList<QString> m_descriptions ;
    QList<QString> m_dates ;
    QList<int> m_counts ;
    QList<int> m_findCounts ;
};

#endif // GETPOCKETSQUERIESLIST_H
