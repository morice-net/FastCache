#ifndef NMEAPARSING_H
#define NMEAPARSING_H

#include <QByteArray>
#include <QDebug>
#include <QList>

class GPGGA {
public:
    double _utcTime; //hhmmss.ss
    double _latitude;
    double _longitude;
    int _quality; //0 = Invalid, 1 = GPS fix, 2 = DGPS fix
    int _satellites; //In view
    double _hdop; //Relative accuracy of horizontal position
    double _altitude; //Meters above mean sea level
    double _geoildalSeparation; //Height of geoid above WGS84 ellipsoid

    GPGGA();
};

class GPGSA {
public:
    char _modeType; //M = Manual, A = Automatic
    int _mode; //1 = Fix not available, 2 = 2D, 3 = 3D
    QList<int> *_satellites = NULL; //IDs of SVs used in position fix
    double _pdop;
    double _hdop;
    double _vdop;

    GPGSA();
};

class SATELLITE {
public:
    int _id; //SV PRN number
    int _elevation; //In degrees, 90 maximum
    int _azimuth; //Degrees from true north, 000 to 359
    int _snr; //00-99 dB (null when not tracking)

    SATELLITE();
};

class GPGSV {
public:
    QList<SATELLITE> *_satellites = NULL;

    GPGSV();
};

class GPRMC {
public:
    double _utcTime; //Time Stamp
    char _validity; //A = ok, V = invalid
    double _latitude; //Current Latitude
    double _longitude; //Current Longitude
    double _speed; //Speed in Kilometers per hour
    double _course; //True course
    int _utDate; //Date Stamp

    GPRMC();
};

class NMEAPARSING {
public:
    GPGGA *_gpgga = NULL;
    GPGSA *_gpgsa = NULL;
    GPGSV *_gpgsv = NULL;
    GPRMC *_gprmc = NULL;

    NMEAPARSING();
    void parseGPS(QByteArray gpsPackage);
    GPGGA *parseGPGGA(QByteArray gpggaPackage);
    GPGSA *parseGPGSA(QByteArray gpgsaPackage);
    GPGSV *parseGPGSV(QByteArray gpgsvPackage);
    GPRMC *parseGPRMC(QByteArray gprmcPackage);

private:
    bool checkSum(QByteArray package, int checksum);
    QList<QByteArray> *splitPackage(QByteArray package, QString packageName);
};

#endif // NMEAPARSING_H
