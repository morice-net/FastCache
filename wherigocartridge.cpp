#include "wherigocartridge.h"

#include <QNetworkAccessManager>
#include <QNetworkRequest>
#include <QJsonDocument>
#include <QJsonObject>

WherigoCartridge::WherigoCartridge(Requestor *parent)
    : Requestor (parent)    
{
}

WherigoCartridge:: ~WherigoCartridge()
{
}

void WherigoCartridge::downloadCartridge(QString token , QString cartridgeGuid , QString geocode) {

    m_geocode = geocode;
    m_cartridgeGuid =cartridgeGuid;

    //Build url    
    QString requestName = "wherigo/" + cartridgeGuid + "/cartridge";
    qDebug() << "*** request name**\n" << requestName;

    // Inform QML we are loading
    setState("loading");
    Requestor::sendGetRequest(requestName,token);
}

void WherigoCartridge::parseJson(const QJsonDocument &dataJsonDoc)
{
    QJsonObject cartridgeJson;
    cartridgeJson = dataJsonDoc.object();
    QString cartridgeBase64 = cartridgeJson["gwcFile"].toString();
    QByteArray cartridge = QByteArray::fromBase64(cartridgeBase64.toUtf8());

    QDir dir(m_dir + m_geocode);
    if (!dir.exists())
        dir.mkpath(".");

    QString path = dir.absolutePath() +"/" + m_cartridgeGuid + ".gwc";
    QFile *file = new QFile(path, this);
    if(!file->open(QIODevice::WriteOnly))
    {
        qDebug() << "impossible d'ouvrir le fichier" << path;
        return;
    }
    QTextStream out(file);
    out << cartridge;
    file->close();
    qDebug() << "fichier sauvagardé" << path;
    return;
}










