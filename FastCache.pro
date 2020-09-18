TEMPLATE = app

QT += qml quick location svg sql

linux:!android {
    QT += webengine
}

win32 {
    QT += webengine
}

SOURCES += main.cpp \
    cachesrecorded.cpp \
    connector.cpp \
    fullcacheretriever.cpp \
    fullcachesrecorded.cpp \
    gettravelbuguser.cpp \
    imagedownloader.cpp \
    parameter.cpp \
    replaceimageintext.cpp \
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
    cachesrecorded.h \
    connector.h \
    fullcacheretriever.h \
    fullcachesrecorded.h \
    gettravelbuguser.h \
    imagedownloader.h \
    parameter.h \
    replaceimageintext.h \
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
    android/AndroidManifest.xml \
    android/build.gradle \
    android/gradle/wrapper/gradle-wrapper.jar \
    android/gradle/wrapper/gradle-wrapper.jar \
    android/gradle/wrapper/gradle-wrapper.properties \
    android/gradlew \
    android/gradlew \
    android/gradlew.bat \
    android/libcrypto.so \
    android/libssl.so \
    android/res/values/libs.xml \
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
    android/gradlew.bat

ANDROID_PACKAGE_SOURCE_DIR = $$PWD/android

contains(ANDROID_TARGET_ARCH,armeabi-v7a) {
    ANDROID_EXTRA_LIBS = \
        $$PWD/android/libcrypto.so \
        $$PWD/android/libssl.so
}

ANDROID_EXTRA_LIBS = $$PWD/android/libcrypto.so $$PWD/android/libssl.so
