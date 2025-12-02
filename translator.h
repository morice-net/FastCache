#ifndef TRANSLATOR_H
#define TRANSLATOR_H

#include <QObject>
#include <QNetworkReply>

#include <QtQml>

class Translator : public QObject
{
    Q_OBJECT
    QML_ELEMENT

    Q_PROPERTY(QString translateText READ translateText WRITE setTranslateText NOTIFY translateTextChanged)

public:
    explicit Translator(QObject *parent = nullptr);
    ~Translator();

    Q_INVOKABLE void translate(const QString &text, const QString &targetLang, const QString &sourceLang);

    QString translateText() const;
    void setTranslateText(const QString &text);

signals:
    void translateTextChanged();

private slots:
    void onTranslationFinished(QNetworkReply *reply);

private:
    QString m_translateText;

    QNetworkAccessManager *manager;
};

#endif // TRANSLATOR_H
