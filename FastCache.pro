TEMPLATE = app

QT += qml quick location

linux:!android {
    QT += webengine

}

SOURCES += main.cpp \
    connector.cpp \
    parameter.cpp \
    tools.cpp \
    requestor.cpp \
    userinfo.cpp \
    cachesbbox.cpp

RESOURCES += qml.qrc

# Additional import path used to resolve QML modules in Qt Creator's code model
QML_IMPORT_PATH =

# Default rules for deployment.
include(deployment.pri)

HEADERS += \
    connector.h \
    parameter.h \
    tools.h \
    requestor.h \
    userinfo.h \
    cachesbbox.h

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
    android/gradlew.bat

ANDROID_PACKAGE_SOURCE_DIR = $$PWD/android

contains(ANDROID_TARGET_ARCH,armeabi-v7a) {
    ANDROID_EXTRA_LIBS = \
        /home/artaud/WorkspaceQt/FastCache/../../Android/Sdk/libcrypto.so \
        $$PWD/../../Android/Sdk/libssl.so
}
