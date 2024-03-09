TEMPLATE = app

QT +=  qml quick svg location sql core core5compat bluetooth serialport

!android {
    QT += webenginequick
}

!win32 {
    QMAKE_LFLAGS += -fuse-ld=gold
}

SOURCES += main.cpp \
    adventurelabcachesretriever.cpp \
    bluetoothgps.cpp \
    cachemaptiles.cpp \
    cachespocketqueries.cpp \
    cachesrecorded.cpp \
    cachessinglelist.cpp \
    connector.cpp \
    constants.cpp \
    deletelogimage.cpp \
    downloador.cpp \
    fullcacheretriever.cpp \
    fullcachesrecorded.cpp \
    fulllabcacheretriever.cpp \
    fulllabcachesrecorded.cpp \
    getgeocachelogimages.cpp \
    getpocketsquerieslist.cpp \
    gettravelbuguser.cpp \
    getusergeocachelogs.cpp \
    nmeaparsing.cpp \
    parameter.cpp \
    replaceimageintext.cpp \
    sendedituserlog.cpp \
    sendimageslog.cpp \
    sendtravelbuglog.cpp \
    senduserwaypoint.cpp \
    tilesdownloader.cpp \
    cachesretriever.cpp \
    travelbug.cpp \
    userinfo.cpp \
    cachesbbox.cpp \
    cache.cpp \
    cachesnear.cpp \
    fullcache.cpp \
    cacheattribute.cpp \
    sendcachenote.cpp \
    smileygc.cpp \
    sqlitestorage.cpp \
    sendcachelog.cpp \
    requestor.cpp \
    allrequest.cpp

RESOURCES += qml.qrc

# Additional import path used to resolve QML modules in Qt Creator's code model
QML_IMPORT_PATH =

# Default rules for deployment.
include(deployment.pri)

HEADERS += \
    adventurelabcachesretriever.h \
    bluetoothgps.h \
    cachemaptiles.h \
    cachespocketqueries.h \
    cachesrecorded.h \
    cachessinglelist.h \
    connector.h \
    deletelogimage.h \
    downloador.h \
    fullcacheretriever.h \
    fullcachesrecorded.h \
    fulllabcacheretriever.h \
    fulllabcachesrecorded.h \
    getgeocachelogimages.h \
    getpocketsquerieslist.h \
    gettravelbuguser.h \
    getusergeocachelogs.h \
    nmeaparsing.h \
    parameter.h \
    replaceimageintext.h \
    sendedituserlog.h \
    sendimageslog.h \
    sendtravelbuglog.h \
    senduserwaypoint.h \
    tilesdownloader.h \
    cachesretriever.h \
    travelbug.h \
    userinfo.h \
    cachesbbox.h \
    cache.h \
    cachesnear.h \
    fullcache.h \
    cacheattribute.h \
    sendcachenote.h \
    smileygc.h \
    sqlitestorage.h \
    sendcachelog.h \
    requestor.h \
    constants.h \
    allrequest.h

DISTFILES += \
    android/AndroidManifest.xml \
    android/build.gradle \
    android/gradle.properties \
    android/gradle/wrapper/gradle-wrapper.jar \
    android/gradle/wrapper/gradle-wrapper.properties \
    android/gradlew \
    android/gradlew.bat \
    android/res/values/libs.xml

ANDROID_PACKAGE_SOURCE_DIR = $$PWD/android
ANDROID_ABIS = armeabi-v7a
#ANDROID_ABIS = arm64-v8a

android: include(/home/artaud/Android/Sdk/android_openssl/openssl.pri)
