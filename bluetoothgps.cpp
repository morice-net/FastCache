#include "bluetoothgps.h"
#include "qdir.h"
#include "qobjectdefs.h"

BluetoothGps::BluetoothGps(QObject *parent) : QObject(parent)
    ,m_altitude(0)
    ,m_precision(0)
    ,m_speed(0)
    ,m_lat(0)
    ,m_lon(0)
{
    socketBuffer = new QString;
    m_gps = new NMEAPARSING;  
}

BluetoothGps::~BluetoothGps()
{
}

void BluetoothGps::searchBluetooth() {
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
    socket = new QBluetoothSocket(QBluetoothServiceInfo::RfcommProtocol);}

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

    connect(this, SIGNAL(socketReadyRead(QByteArray)), this, SLOT(showGPS(QByteArray)));
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

void BluetoothGps::socketRead(){
    socketBuffer->append(socket->readAll());
    if(socketBuffer->size()) {
        this->parseSocketBuffer();
    }
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
}

void BluetoothGps::parseSocketBuffer() {
    if(socketBuffer->left(6).compare("$GPGGA") == 0) {
        unsigned char subPackages = 0;
        for(int index = 0; index < socketBuffer->size(); index++) {
            if(socketBuffer->at(index) == '\n') {
                subPackages++;
                if(subPackages == 6) {
                    emit socketReadyRead(socketBuffer->left(index + 1).toLocal8Bit());
                    socketBuffer->remove(0, index + 1);
                }
            }
        }
    } else {
        qDebug() << "Removing incomplete package from socket buffer!";
        while(socketBuffer->left(6).compare("$GPGGA") && socketBuffer->size()) {
            socketBuffer->remove(0, 1);
        }
    }
}

void BluetoothGps::showGPS(QByteArray gpsPackage) {
    QList<QGeoSatelliteInfo> *satellitesInView = new QList<QGeoSatelliteInfo>();
    QList<QGeoSatelliteInfo> *satellitesInUse = new QList<QGeoSatelliteInfo>();

    m_gps->parseGPS(gpsPackage);

    if(m_gps->_gpgga != NULL) {
        setLat(m_gps->_gpgga->_latitude);
        setLon(m_gps->_gpgga->_longitude);
        setAltitude( m_gps->_gpgga->_altitude);
        setPrecision(m_gps->_gpgga->_hdop);
    }
    if(m_gps->_gprmc != NULL) {
        setSpeed(m_gps->_gprmc->_speed);
    }    
    if(m_gps->_gpgsv != NULL) {
        for(int index = 0; index < m_gps->_gpgsv->_satellites->size(); index++) {
            QGeoSatelliteInfo *satelliteInView = new QGeoSatelliteInfo();
            QGeoSatelliteInfo *satelliteInUse = new QGeoSatelliteInfo();

            satelliteInView->setSatelliteIdentifier(m_gps->_gpgsv->_satellites->at(index)._id);
            satelliteInView->setSignalStrength(m_gps->_gpgsv->_satellites->at(index)._snr);
            satelliteInView->setAttribute(QGeoSatelliteInfo::Azimuth, m_gps->_gpgsv->_satellites->at(index)._azimuth);
            satelliteInView->setAttribute(QGeoSatelliteInfo::Elevation, m_gps->_gpgsv->_satellites->at(index)._elevation);

            satellitesInView->append(*satelliteInView);
            if(m_gps->_gpgsa != NULL) {
                for(int i = 0; i < m_gps->_gpgsa->_satellites->size(); i++) {
                    if(m_gps->_gpgsa->_satellites->at(i) == m_gps->_gpgsv->_satellites->at(index)._id ) {
                        satellitesInUse->append(*satelliteInView);
                        break;
                    }
                }
            }
            delete satelliteInView;
            delete satelliteInUse;
        }
    }
    setSatellitesInView(*satellitesInView);
    setSatellitesInUse(*satellitesInUse);

    delete satellitesInView;
    delete satellitesInUse;    
}

/** Getters & Setters **/

QList<QGeoSatelliteInfo> BluetoothGps::satellitesInView() const
{
    return m_satellitesInView;
}

void BluetoothGps::setSatellitesInView(const QList<QGeoSatelliteInfo> &satellitesInView)
{
    m_satellitesInView = satellitesInView;
    emit satellitesInViewChanged();
}

QList<QGeoSatelliteInfo> BluetoothGps::satellitesInUse() const
{
    return m_satellitesInUse;
}

void BluetoothGps::setSatellitesInUse(const QList<QGeoSatelliteInfo> &satellitesInUse)
{
    m_satellitesInUse = satellitesInUse;
    emit satellitesInUseChanged();
}

float BluetoothGps::altitude() const
{
    return m_altitude;
}

void BluetoothGps::setAltitude(const float &altitude)
{
    m_altitude = altitude;
    emit altitudeChanged();
}

float BluetoothGps::precision() const
{
    return m_precision;
}

void BluetoothGps::setPrecision(const float &precision)
{
    m_precision = precision;
    emit precisionChanged();
}

float BluetoothGps::speed() const
{
    return m_speed;
}

void BluetoothGps::setSpeed(const float &speed)
{
    m_speed = speed;
    emit speedChanged();
}

float BluetoothGps::lat() const
{
    return m_lat;
}

void BluetoothGps::setLat(const float &lat)
{
    m_lat = lat;
    emit latChanged();
}

float BluetoothGps::lon() const
{
    return m_lon;
}

void BluetoothGps::setLon(const float &lon)
{
    m_lon = lon;
    emit lonChanged();
}


















