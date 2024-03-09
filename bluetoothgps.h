#ifndef BLUETOOTHGPS_H
#define BLUETOOTHGPS_H

#include <QObject>
#include <QBluetoothDeviceDiscoveryAgent>
#include <QBluetoothAddress>
#include <QBluetoothLocalDevice>
#include <QDebug>
#include <QGeoSatelliteInfo>

#include <QtBluetooth/qbluetoothsocket.h>
#include "nmeaparsing.h"

class BluetoothGps : public QObject
{
    Q_OBJECT

    Q_PROPERTY(QList<QGeoSatelliteInfo> satellitesInView READ satellitesInView WRITE setSatellitesInView NOTIFY satellitesInViewChanged)
    Q_PROPERTY(QList<QGeoSatelliteInfo> satellitesInUse READ satellitesInUse WRITE setSatellitesInUse NOTIFY satellitesInUseChanged)    
    Q_PROPERTY(float altitude READ altitude WRITE setAltitude NOTIFY altitudeChanged)
    Q_PROPERTY(float precision READ precision WRITE setPrecision NOTIFY precisionChanged)
    Q_PROPERTY(float speed READ speed WRITE setSpeed NOTIFY speedChanged)
    Q_PROPERTY(float lat READ lat WRITE setLat NOTIFY latChanged)
    Q_PROPERTY(float lon READ lon WRITE setLon NOTIFY lonChanged)


public:
    explicit BluetoothGps(QObject *parent = nullptr);
    ~BluetoothGps() override;

    Q_INVOKABLE void searchBluetooth();
    Q_INVOKABLE void quitBluetooth();

    QList<QGeoSatelliteInfo> satellitesInView() const;
    void setSatellitesInView(const QList<QGeoSatelliteInfo> &satellitesInView);
    QList<QGeoSatelliteInfo> satellitesInUse() const;
    void setSatellitesInUse(const QList<QGeoSatelliteInfo> &satellitesInUse);
    float altitude() const;
    void setAltitude(const float &altitude);
    float precision() const;
    void setPrecision(const float &precision);
    float speed() const;
    void setSpeed(const float &speed);
    float lat() const;
    void setLat(const float &lat);
    float lon() const;
    void setLon(const float &lon);

signals:
    void socketReadyRead(QByteArray gpsPackage);    
    void satellitesInViewChanged();
    void satellitesInUseChanged();
    void altitudeChanged();
    void precisionChanged();
    void speedChanged();
    void latChanged();
    void lonChanged();

private slots:
    void deviceDiscovered(const QBluetoothDeviceInfo &device);
    void deviceDiscoveryFinished();

    void pairingDone(const QBluetoothAddress &address, QBluetoothLocalDevice::Pairing pairing);
    void requestPairing(QString address);

    void scanError(QBluetoothDeviceDiscoveryAgent::Error error);

    void socketConnected();
    void socketError(QBluetoothSocket::SocketError error);
    void socketRead();
    void socketDisconnected();
    void showGPS(QByteArray gpsPackage);    

private:
    QBluetoothDeviceDiscoveryAgent *discoveryAgent{nullptr};
    QBluetoothLocalDevice *localDevice{nullptr};
    QBluetoothSocket *socket = nullptr;
    QString *socketBuffer;
    NMEAPARSING *m_gps;    
    QList<QGeoSatelliteInfo> m_satellitesInView;
    QList<QGeoSatelliteInfo> m_satellitesInUse;
    float m_altitude;
    float m_precision;
    float m_speed;
    float m_lat;
    float m_lon;

    void parseSocketBuffer();    
};

#endif // BLUETOOTHGPS_H
