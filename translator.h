#ifndef TRANSLATOR_H
#define TRANSLATOR_H

#include <QObject>
#include <QNetworkReply>

class Translator : public QObject
{
    Q_OBJECT

public:
    explicit Translator(QObject *parent = nullptr);
    ~Translator();

    void translate(const QString &text, const QString &targetLang, const QString &sourceLang);

signals:
    void translationComplete(const QString &result);
    void errorOccurred(const QString &error);

private slots:
    void onTranslationFinished(QNetworkReply *reply);

private:
    QNetworkAccessManager *manager;
};

#endif // TRANSLATOR_H
