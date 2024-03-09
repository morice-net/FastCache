#include "nmeaparsing.h"

GPGGA::GPGGA(){}
GPGSA::GPGSA(){}
SATELLITE::SATELLITE(){}
GPGSV::GPGSV(){}
GPRMC::GPRMC(){}
NMEAPARSING::NMEAPARSING(){}

bool NMEAPARSING::checkSum(QByteArray package, int checksum) {
    int sum = 0;
    if(package.size() && package.at(0) == '$') {
        for(int index = 1; package.at(index) != '*' && index < package.size(); index++) {
            sum ^= package.at(index);
        }
        if(sum == checksum) {
            return true;
        }
    }
    return false;
}

QList<QByteArray> *NMEAPARSING::splitPackage(QByteArray package, QString packageName) {
    QList<QByteArray> splitChecksum = package.split('*');
    if(splitChecksum.size() < 2 || splitChecksum.at(1).size() < 2) {
        qDebug() << packageName << " parse failed!";
        return NULL;
    }
    int checksum = splitChecksum.at(1).left(2).toInt(0, 16);
    if(!checkSum(package, checksum)) {
        qDebug() << packageName << "checksum failed!";
        return NULL;
    }
    return new QList<QByteArray>(splitChecksum.at(0).split(','));
}

void NMEAPARSING::parseGPS(QByteArray gpsPackage) {
    QList<QByteArray> splitPackages = gpsPackage.split('\n');
    if(_gpgsv != NULL)
        delete _gpgsv;
    _gpgsv = new GPGSV;
    _gpgsv->_satellites = new QList<SATELLITE>;
    for(int index = 0; index < splitPackages.size(); index++) {
        QByteArray package = splitPackages.at(index);
        if(package.size() >= 6) {
            if(package.left(6).compare("$GPGGA") == 0) {
                if(_gpgga != NULL)
                    delete _gpgga;
                _gpgga = parseGPGGA(package);                
            } else if (package.left(6).compare("$GPGSA") == 0) {
                if(_gpgsa != NULL)
                    delete _gpgsa;
                _gpgsa = parseGPGSA(package);
            } else if (package.left(6).compare("$GPGSV") == 0) {
                GPGSV *gpgsv = parseGPGSV(package);
                if(gpgsv != NULL) {
                    for(int index = 0; index < gpgsv->_satellites->size(); index++) {
                        _gpgsv->_satellites->append(gpgsv->_satellites->at(index));
                    }
                    delete gpgsv;
                }
            } else if(package.left(6).compare("$GPRMC") == 0) {
                if(_gprmc != NULL)
                    delete _gprmc;
                _gprmc = parseGPRMC(package);
            }
        }
    }
}

GPGGA *NMEAPARSING::parseGPGGA(QByteArray gpggaPackage) {
    GPGGA *gpgga = new GPGGA;
    QList<QByteArray> *splitedPackage = splitPackage(gpggaPackage, "GPGGA");
    if(splitedPackage == NULL) {
        delete(gpgga);
        return NULL;
    }
    gpgga->_utcTime = splitedPackage->at(1).toFloat();
    float latitude = splitedPackage->at(2).toFloat(), longitude = splitedPackage->at(4).toFloat();
    char ns = splitedPackage->at(3)[0], ew = splitedPackage->at(5)[0];
    int msbLatitude = latitude / 100, msbLongitude = longitude / 100;
    gpgga->_latitude = ((latitude - msbLatitude * 100) / 60 + msbLatitude);
    if(ns == 'S') gpgga->_latitude *= -1;
    gpgga->_longitude = ((longitude - msbLongitude * 100) / 60 + msbLongitude);
    if(ew == 'W') gpgga->_longitude *= -1;
    gpgga->_quality = splitedPackage->at(6).toInt();
    gpgga->_satellites = splitedPackage->at(7).toInt();
    gpgga->_hdop = splitedPackage->at(8).toFloat();
    gpgga->_altitude = splitedPackage->at(9).toFloat();
    gpgga->_geoildalSeparation = splitedPackage->at(11).toFloat();
    delete splitedPackage;
    return gpgga;
}

GPGSA *NMEAPARSING::parseGPGSA(QByteArray gpgsaPackage) {
    GPGSA *gpgsa = new GPGSA;
    QList<QByteArray> *splitedPackage = splitPackage(gpgsaPackage, "GPGSA");
    if(splitedPackage == NULL) {
        delete(gpgsa);
        return NULL;
    }
    gpgsa->_modeType = splitedPackage->at(1)[0];
    gpgsa->_mode = splitedPackage->at(2).toInt();
    gpgsa->_satellites = new QList<int>;
    for(int index = 3; index < 15; index++) {
        if(splitedPackage->at(index).size()) {
            gpgsa->_satellites->append(splitedPackage->at(index).toInt());
        }
    }
    std::sort(gpgsa->_satellites->begin(), gpgsa->_satellites->end());
    gpgsa->_pdop = splitedPackage->at(15).toFloat();
    gpgsa->_hdop = splitedPackage->at(16).toFloat();
    gpgsa->_vdop = splitedPackage->at(17).toFloat();
    delete splitedPackage;
    return gpgsa;
}

GPGSV *NMEAPARSING::parseGPGSV(QByteArray gpgsvPackage) {
    GPGSV *gpgsv = new GPGSV;
    QList<QByteArray> *splitedPackage = splitPackage(gpgsvPackage, "GPGSV");
    if(splitedPackage == NULL) {
        delete(gpgsv);
        return NULL;
    }
    gpgsv->_satellites = new QList<SATELLITE>;    
    int indexMax;
    int sats = splitedPackage->at(3).toInt();
    if(sats != 0) {
        int page = splitedPackage->at(2).toInt();
        if(sats >= 4 * page) {
            indexMax = 12;
        } else {
            indexMax = (3 - (4 * page) + sats) * 4;
        }
        for(int index = 0; index <= indexMax; index += 4) {
            SATELLITE satellite;
            satellite._id = splitedPackage->at(4 + index).size() ? splitedPackage->at(4 + index).toInt() : -1;
            satellite._elevation = splitedPackage->at(5 + index).size() ? splitedPackage->at(5 + index).toInt() : -1;
            satellite._azimuth = splitedPackage->at(6 + index).size() ? splitedPackage->at(6 + index).toInt() : -1;
            satellite._snr = splitedPackage->at(7 + index).size() ? splitedPackage->at(7 + index).toInt() : -1;
            gpgsv->_satellites->append(satellite);
        }
    }
    return gpgsv;
}

GPRMC *NMEAPARSING::parseGPRMC(QByteArray gprmcPackage) {
    GPRMC *gprmc = new GPRMC;
    QList<QByteArray> *splitedPackage = splitPackage(gprmcPackage, "GPRMC");
    if(splitedPackage == NULL) {
        delete(gprmc);
        return NULL;
    }
    gprmc->_utcTime = splitedPackage->at(1).toFloat();
    gprmc->_validity = splitedPackage->at(2)[0];
    float latitude = splitedPackage->at(3).toFloat(), longitude = splitedPackage->at(5).toFloat();
    char ns = splitedPackage->at(4)[0], ew = splitedPackage->at(6)[0];
    int msbLatitude = latitude / 100, msbLongitude = longitude / 100;
    gprmc->_latitude = ((latitude - msbLatitude * 100) / 60 + msbLatitude);
    if(ns == 'S') gprmc->_latitude *= -1;
    gprmc->_longitude = ((longitude - msbLongitude * 100) / 60 + msbLongitude);
    if(ew == 'W') gprmc->_longitude *= -1;
    gprmc->_speed = splitedPackage->at(7).toFloat() * 1.852000;
    gprmc->_course = splitedPackage->at(8).toFloat();
    gprmc->_utDate = splitedPackage->at(9).toInt();    
    return gprmc;
}
