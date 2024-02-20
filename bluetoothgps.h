#ifndef BLUETOOTHGPS_H
#define BLUETOOTHGPS_H

#include <QObject>
#include <QBluetoothDeviceDiscoveryAgent>
#include <QBluetoothAddress>
#include <QBluetoothLocalDevice>
#include <QDebug>
#include <QFile>

#include <QtBluetooth/qbluetoothsocket.h>

class BluetoothGps : public QObject
{
    Q_OBJECT
public:
    explicit BluetoothGps(QObject *parent = nullptr);

    Q_INVOKABLE void searchBluetooth();
    Q_INVOKABLE void quitBluetooth();

public slots:
    void requestPairing(QString address);

private slots:
    void deviceDiscovered(const QBluetoothDeviceInfo &device);
    void deviceDiscoveryFinished();

    void pairingDone(const QBluetoothAddress &address, QBluetoothLocalDevice::Pairing pairing);

    void scanError(QBluetoothDeviceDiscoveryAgent::Error error);

    void socketConnected();
    void socketError(QBluetoothSocket::SocketError error);
    void socketRead();
    void socketDisconnected();

private:
    QBluetoothDeviceDiscoveryAgent *discoveryAgent{nullptr};
    QBluetoothLocalDevice *localDevice{nullptr};
    QBluetoothSocket *socket = nullptr;
    QString m_dirNmea = "./NmeaGps/";
    QFile *m_fileNmea ;
    int m_nmeaFrames;
    int MAX_FRAMES = 40;
};

#endif // BLUETOOTHGPS_H
