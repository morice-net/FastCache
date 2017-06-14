TEMPLATE = app

QT += qml quick location webengine

SOURCES += main.cpp \
    connector.cpp \
    parameter.cpp

RESOURCES += qml.qrc

# Additional import path used to resolve QML modules in Qt Creator's code model
QML_IMPORT_PATH =

# Default rules for deployment.
include(deployment.pri)

HEADERS += \
    connector.h \
    parameter.h
