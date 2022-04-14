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
    delete webCtrl;
}

void Downloador::downloadFile(QUrl url, QString id, QString path)
{
    QFile *file = new QFile(path, this);
    if(!file->open(QIODevice::WriteOnly))
    {
        return;
    }

    QNetworkRequest request(url);
    request.setAttribute(QNetworkRequest::FollowRedirectsAttribute, true);
    request.setRawHeader("User-Agent", userAgent);

    QNetworkReply *reply = webCtrl->get(request);
    replytofile.insert(reply, file);
    replytopathid.insert(reply, QPair<QString, QString>(path, id));

    QObject::connect(reply, &QNetworkReply::finished, this, &Downloador::fileDownloaded);
    QObject::connect(reply, &QNetworkReply::readyRead, this, &Downloador::onReadyRead);
}

void Downloador::fileDownloaded()
{
    QNetworkReply* reply = qobject_cast<QNetworkReply*>(sender());

    if (replytofile[reply]->isOpen())
    {
        replytofile[reply]->close();
        replytofile[reply]->deleteLater();
    }

    switch(reply->error())
    {
    case QNetworkReply::NoError:
        setState("OK");
        downloaded(reply);
        break;
    default:
        setState(reply->errorString().toLatin1());
        break;
    }
    replytofile.remove(reply);
    replytopathid.remove(reply);
    delete reply;
}

void Downloador::onReadyRead()
{
    QNetworkReply* reply = qobject_cast<QNetworkReply*>(sender());
    replytofile[reply]->write(reply->readAll());
}

void Downloador::downloaded(QNetworkReply* reply)
{

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




