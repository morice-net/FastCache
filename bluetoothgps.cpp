#include "bluetoothgps.h"
#include "qdir.h"

#include <QtSerialPort/QSerialPortInfo>

BluetoothGps::BluetoothGps(QObject *parent) : QObject(parent)
    , m_nmeaFrames(0)
{
    QDir dir(m_dirNmea);
    if (!dir.exists())
        dir.mkpath(".");
    m_fileNmea = new QFile(m_dirNmea + "nmealog.txt", this);
}

void BluetoothGps::searchBluetooth() {
    m_nmeaFrames = 0;
    if(!m_fileNmea->open(QIODevice::ReadWrite))
    {
        return;
    }
    m_fileNmea->resize(0);

    qDebug() << "Bluetooth Searcher Starting";
    if (localDevice == nullptr) {
        localDevice = new QBluetoothLocalDevice(this);
        connect(localDevice, &QBluetoothLocalDevice::pairingFinished,
                this, &BluetoothGps::pairingDone);
    }
    QString localDeviceName;
    if (localDevice->isValid()) {
        localDevice->powerOn();
        localDeviceName = localDevice->name();
        qDebug()<<localDeviceName <<localDevice->address();
    } else
        qDebug() << "invalid bluetooth";

    QBluetoothDeviceDiscoveryAgent *discoveryAgent = new QBluetoothDeviceDiscoveryAgent(this);
    connect(discoveryAgent, &QBluetoothDeviceDiscoveryAgent::deviceDiscovered,
            this, &BluetoothGps::deviceDiscovered);
    connect(discoveryAgent, &QBluetoothDeviceDiscoveryAgent::finished,
            this, &BluetoothGps::deviceDiscoveryFinished);

#if defined (Q_OS_ANDROID) || defined (Q_OS_WINDOWS)
    discoveryAgent->start(QBluetoothDeviceDiscoveryAgent::ClassicMethod);
#else
    qWarning() << "Must Implement The Ble Communication for IOS";
#endif    
    if (socket)
        return;
    socket = new QBluetoothSocket(QBluetoothServiceInfo::RfcommProtocol);
}

void BluetoothGps::deviceDiscovered(const QBluetoothDeviceInfo &device)
{
    qDebug() << device.name();
    qDebug() << device.address();
    if (device.name().contains("_C") || device.name().contains("_V")) {
        qDebug() << "Found new device:" << device.name() << '(' << device.address().toString() << ')';
        QBluetoothLocalDevice::Pairing pairingStatus = localDevice->pairingStatus(device.address());
        qDebug() << "Pairing Status:" << pairingStatus << device.address();
        bool paired = true;
        if (pairingStatus != QBluetoothLocalDevice::Paired && pairingStatus != QBluetoothLocalDevice::AuthorizedPaired )
            paired = false;

#ifdef Q_OS_WIN
        /* this is because the windows bt api on Qt 5.15.2 shows only previously paired device from windows */
        paired = true;
#endif
        qDebug()<<"paired"<< paired;
    }
    qDebug() << "Create socket";
    socket->connectToService(QBluetoothAddress(device.address()), QBluetoothUuid(QBluetoothUuid::ServiceClassUuid::SerialPort) , QIODevice::ReadWrite);
    qDebug() << "ConnectToService done";

    connect(socket, &QBluetoothSocket::readyRead,   this, &BluetoothGps::socketRead);
    connect(socket, &QBluetoothSocket::connected,   this, QOverload<>::of(&BluetoothGps::socketConnected));
    connect(socket, &QBluetoothSocket::disconnected,this, &BluetoothGps::socketDisconnected);
    connect(socket,&QBluetoothSocket::errorOccurred,this, &BluetoothGps::socketError);
}

void BluetoothGps::deviceDiscoveryFinished()
{    
    qDebug() << "Device Discovery Finished";
}

void BluetoothGps::pairingDone(const QBluetoothAddress &address, QBluetoothLocalDevice::Pairing pairing)
{
    qDebug() << "Pairing Result:" << pairing << " for device " << address.toString();    
}

void BluetoothGps::requestPairing(QString address)
{
    QBluetoothLocalDevice::Pairing pairingStatus = localDevice->pairingStatus(QBluetoothAddress(address));
    qDebug() << "Pairing Status:" << pairingStatus << address;
    if (pairingStatus != QBluetoothLocalDevice::Paired && pairingStatus != QBluetoothLocalDevice::AuthorizedPaired )
        localDevice->requestPairing(QBluetoothAddress(address), QBluetoothLocalDevice::Paired);
}

void BluetoothGps::scanError(QBluetoothDeviceDiscoveryAgent::Error error)
{
    QBluetoothDeviceDiscoveryAgent *deviceAgent = static_cast<QBluetoothDeviceDiscoveryAgent*>(QObject::sender());
    if (error == QBluetoothDeviceDiscoveryAgent::PoweredOffError)
        qInfo() << "The Bluetooth adaptor is powered off.";
    else if (error == QBluetoothDeviceDiscoveryAgent::InputOutputError) {
        qInfo() << "Writing or reading from the device resulted in an error." << deviceAgent->errorString();        
    } else {
        qInfo() << "An unknown error has occurred." << error << deviceAgent->errorString();        
    }
}

void BluetoothGps::socketConnected()
{
    qDebug() << "Socket connected";
    qDebug() << "Local: "
             << socket->localName()
             << socket->localAddress().toString()
             << socket->localPort();
    qDebug() << "Peer: "
             << socket->peerName()
             << socket->peerAddress().toString()
             << socket->peerPort();    
}

void BluetoothGps::socketError(QBluetoothSocket::SocketError error)
{
    qDebug() << "Socket error: " << error;
}

void BluetoothGps::socketRead()
{
    m_nmeaFrames = m_nmeaFrames + 1;
    if(m_nmeaFrames == MAX_FRAMES) {
        m_fileNmea->resize(0);
        m_nmeaFrames = 0;
    }
    QByteArray receivedData = socket->readAll();       
    receivedData.chop(2);
    qDebug()<<"Read socket"<<receivedData;
    m_fileNmea->write(receivedData);    
}

void BluetoothGps::socketDisconnected()
{
    qDebug() << "Socket disconnected";
    socket->close();
}

void BluetoothGps::quitBluetooth()
{
    qDebug() << "quit bluetooth";
    socket->close();
    m_fileNmea->resize(0);
    m_fileNmea->close();
}







