TEMPLATE = app

QT += qml quick location svg sql

linux:!android {
    QT += webengine
}

win32 {
    QT += webengine
}

!win32 {
    QMAKE_LFLAGS += -fuse-ld=gold
}

SOURCES += main.cpp \
    cachespocketqueries.cpp \
    cachesrecorded.cpp \
    cachessinglelist.cpp \
    connector.cpp \
    fullcacheretriever.cpp \
    fullcachesrecorded.cpp \
    getpocketsquerieslist.cpp \
    gettravelbuguser.cpp \
    imagedownloader.cpp \
    parameter.cpp \
    replaceimageintext.cpp \
    sendimageslog.cpp \
    sendtravelbuglog.cpp \
    senduserwaypoint.cpp \
    tools.cpp \
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
    cachespocketqueries.h \
    cachesrecorded.h \
    cachessinglelist.h \
    connector.h \
    fullcacheretriever.h \
    fullcachesrecorded.h \
    getpocketsquerieslist.h \
    gettravelbuguser.h \
    imagedownloader.h \
    parameter.h \
    replaceimageintext.h \
    sendimageslog.h \
    sendtravelbuglog.h \
    senduserwaypoint.h \
    tools.h \
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
    android/libcrypto.so \
    android/libssl.so \
    android/res/values/libs.xml \
    android/res/values/libs.xml \
    android/res/values/libs.xml

ANDROID_PACKAGE_SOURCE_DIR = $$PWD/android

contains(ANDROID_TARGET_ARCH,armeabi-v7a) {
    ANDROID_EXTRA_LIBS = \
        $$PWD/android/libcrypto.so \
        $$PWD/android/libssl.so
}

ANDROID_EXTRA_LIBS = $$PWD/android/libcrypto.so $$PWD/android/libssl.so

ANDROID_ABIS = armeabi-v7a

