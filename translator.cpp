#include "translator.h"

#include <QCoreApplication>
#include <QNetworkAccessManager>
#include <QNetworkRequest>
#include <QJsonDocument>
#include <QJsonObject>
#include <QJsonArray>
#include <QUrlQuery>
#include <QDebug>

Translator::Translator(QObject *parent)
    : QObject(parent)
{
    manager = new QNetworkAccessManager(this);
    QObject::connect(manager, &QNetworkAccessManager::finished,
                     this, &Translator::onTranslationFinished);
}

Translator::~Translator()
{
    delete manager;
}

void Translator::translate(const QString &text, const QString &targetLang, const QString &sourceLang )
{
    // URL Configuration
    QUrl url("https://translation.googleapis.com/language/translate/v2");
    QUrlQuery query;
    query.addQueryItem("key", "apiKey");
    url.setQuery(query);

    // Preparing JSON data
    QJsonObject requestBody;
    requestBody["q"] = text;
    requestBody["target"] = targetLang;
    if (!sourceLang.isEmpty()) {
        requestBody["source"] = sourceLang;
    }
    requestBody["format"] = "text"; // Text format

    QJsonDocument doc(requestBody);
    QByteArray jsonData = doc.toJson();    
    QNetworkRequest request(url);
    request.setHeader(QNetworkRequest::ContentTypeHeader, "application/json");    
    manager->post(request, jsonData);
}

void Translator::onTranslationFinished(QNetworkReply *reply) {
    if (reply->error() == QNetworkReply::NoError) {        
        QByteArray response = reply->readAll();
        QJsonDocument jsonDoc = QJsonDocument::fromJson(response);
        QJsonObject jsonObj = jsonDoc.object();        
        QJsonArray translations = jsonObj["data"].toObject()["translations"].toArray();
        if (!translations.isEmpty()) {
            QString translatedText = translations[0].toObject()["translatedText"].toString();
            emit Translator::translationComplete(translatedText);
        } else {
            emit Translator::errorOccurred("Aucune traduction trouvée");
        }
    } else {
        emit Translator::errorOccurred("Erreur réseau: " + reply->errorString());
    }
    reply->deleteLater();
}



