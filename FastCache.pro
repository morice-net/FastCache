TEMPLATE = app

QT += qml quick location svg sql

linux:!android {
    QT += webengine
}

SOURCES += main.cpp \
    connector.cpp \
    parameter.cpp \
    tools.cpp \
    cachesretriever.cpp \
    userinfo.cpp \
    cachesbbox.cpp \
    cache.cpp \
    cachetype.cpp \
    cachesize.cpp \
    cachesnear.cpp \
    fullcache.cpp \
    cacheattribute.cpp \
    sendcachenote.cpp \
    smileygc.cpp \
    waypointtype.cpp \
    objectstorage.cpp \
    sqlitestorage.cpp \
    sendcachelog.cpp

RESOURCES += qml.qrc

# Additional import path used to resolve QML modules in Qt Creator's code model
QML_IMPORT_PATH =

# Default rules for deployment.
include(deployment.pri)

HEADERS += \
    connector.h \
    parameter.h \
    tools.h \
    cachesretriever.h \
    userinfo.h \
    cachesbbox.h \
    cache.h \
    cachetype.h \
    cachesize.h \
    cachesnear.h \
    fullcache.h \
    cacheattribute.h \
    sendcachenote.h \
    smileygc.h \
    waypointtype.h \
    objectstorage.h \
    sqlitestorage.h \
    sendcachelog.h

DISTFILES += \
    android/AndroidManifest.xml \
    android/gradle/wrapper/gradle-wrapper.jar \
    android/gradlew \
    android/res/values/libs.xml \
    android/build.gradle \
    android/gradle/wrapper/gradle-wrapper.properties \
    android/gradlew.bat \
    android/AndroidManifest.xml \
    android/gradle/wrapper/gradle-wrapper.jar \
    android/gradlew \
    android/res/values/libs.xml \
    android/build.gradle \
    android/gradle/wrapper/gradle-wrapper.properties \
    android/gradlew.bat \
    android/libcrypto.so \
    android/libssl.so

ANDROID_PACKAGE_SOURCE_DIR = $$PWD/android

contains(ANDROID_TARGET_ARCH,armeabi-v7a) {
    ANDROID_EXTRA_LIBS = \
        $$PWD/android/libcrypto.so \
        $$PWD/android/libssl.so
}
