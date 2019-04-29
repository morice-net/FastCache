#ifndef LOGTYPE_H
#define LOGTYPE_H

#include <QObject>

class LogType : public QObject
{
    Q_OBJECT

    Q_PROPERTY(QString typeId READ typeId WRITE setTypeId NOTIFY typeIdChanged)
    Q_PROPERTY(QString frenchPattern READ frenchPattern WRITE setFrenchPattern NOTIFY frenchPatternChanged)
    Q_PROPERTY(int typeIdGs READ typeIdGs WRITE setTypeIdGs NOTIFY typeIdGsChanged)
    Q_PROPERTY(QString icon READ icon WRITE setIcon NOTIFY iconChanged)

public:
    explicit  LogType(QObject *parent = nullptr);
    ~LogType();

    QString typeId() const;
    void  setTypeId(const QString &typeId);

    QString  frenchPattern() const;
    void setFrenchPattern(const QString &pattern);

    int typeIdGs() const;
    void setTypeIdGs(const int &typeIdGs);

    QString  icon() const;
    void setIcon(const QString &icon);

signals:
    void typeIdChanged();
    void frenchPatternChanged();
    void typeIdGsChanged();
    void iconChanged();


private:
    QString m_typeId;
    QString m_frenchPattern;
    int m_typeIdGs;
    QString m_icon;

};
#endif // LOGTYPE_H
