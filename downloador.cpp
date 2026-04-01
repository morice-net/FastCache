#include "downloador.h"

Downloador::Downloador(QObject *parent)
    : QObject(parent)
    , m_state()
{
    webCtrl = new QNetworkAccessManager(this);
    webCtrl->setTransferTimeout(m_timeOut);
}

Downloador::~Downloador()
{    
}

void Downloador::downloadFile(const QUrl &url, const QString &id, const QString &path)
{
    auto file = new QFile(path, this);
    if (!file->open(QIODevice::WriteOnly)) {
        setState("unableOpenFile");
        return;
    }
    QNetworkRequest request(url);
    request.setAttribute(QNetworkRequest::RedirectPolicyAttribute, QNetworkRequest::NoLessSafeRedirectPolicy);
    request.setRawHeader("User-Agent", userAgent);
    setState("loading");

    QNetworkReply *reply = webCtrl->get(request);
    replytofile.insert(reply, file);
    replytopathid.insert(reply, {path, id});

    connect(reply, &QNetworkReply::readyRead, this, &Downloador::onReadyRead);
    connect(reply, &QNetworkReply::finished, this, &Downloador::fileDownloaded);
}

void Downloador::fileDownloaded()
{
    if (auto reply = qobject_cast<QNetworkReply*>(sender())) {
        QFile *file = replytofile.take(reply);
        auto pathId = replytopathid.take(reply);

        if (file) {
            if (file->isOpen()) file->close();
            file->deleteLater();
        }

        if (reply->error() == QNetworkReply::NoError) {
            setState("OK");
            downloaded(reply);
        } else {
            setState(reply->errorString());
        }

        reply->deleteLater();
    }
}

void Downloador::onReadyRead()
{
    if (auto reply = qobject_cast<QNetworkReply*>(sender())) {
        if (auto file = replytofile.value(reply, nullptr)) {
            file->write(reply->readAll());
        }
    }
}

void Downloador::downloaded(QNetworkReply* reply)
{
    (void) reply;
}

/** Getters & Setters **/

QString Downloador::state() const
{
    return m_state;
}

void Downloador::setState(const QString &state)
{
    m_state = state;
    emit stateChanged();
}















