cmake_minimum_required(VERSION 3.16)
project(FastCache LANGUAGES CXX)

set(CMAKE_CXX_STANDARD_REQUIRED ON)

find_package(Qt6 REQUIRED COMPONENTS Core  Quick WebView Sensors Svg Location Sql Bluetooth  Qml)
if(NOT ANDROID)
    find_package(Qt6WebEngineQuick REQUIRED )
endif()

qt_standard_project_setup(REQUIRES 6.5)

qt_add_executable(appFastCache WIN32 MACOSX_BUNDLE
    main.cpp
    adventurelabcachesretriever.cpp
    adventurelabcachesretriever.h
    allrequest.cpp
    allrequest.h
    bluetoothgps.cpp
    bluetoothgps.h
    cache.cpp
    cache.h
    cacheattribute.cpp
    cacheattribute.h
    cachemaptiles.cpp
    cachemaptiles.h
    cachesbbox.cpp
    cachesbbox.h
    cachesnear.cpp
    cachesnear.h
    cachespocketqueries.cpp
    cachespocketqueries.h
    cachesrecorded.cpp
    cachesrecorded.h
    cachesretriever.cpp
    cachesretriever.h
    cachessinglelist.cpp
    cachessinglelist.h
    connector.cpp
    connector.h
    constants.h
    deletelogimage.cpp
    deletelogimage.h
    downloador.cpp
    downloador.h
    fullcache.cpp
    fullcache.h
    fullcacheretriever.cpp
    fullcacheretriever.h
    fullcachesrecorded.cpp
    fullcachesrecorded.h
    fulllabcacheretriever.cpp
    fulllabcacheretriever.h
    fulllabcachesrecorded.cpp
    fulllabcachesrecorded.h
    getgeocachelogimages.cpp
    getgeocachelogimages.h
    getpocketsquerieslist.cpp
    getpocketsquerieslist.h
    gettravelbuguser.cpp
    gettravelbuguser.h
    getusergeocachelogs.cpp
    getusergeocachelogs.h
    main.cpp
    nmeaparsing.cpp
    nmeaparsing.h
    parameter.cpp
    parameter.h
    replaceimageintext.cpp
    replaceimageintext.h
    requestor.cpp
    requestor.h
    sendcachelog.cpp
    sendcachelog.h
    sendcachenote.cpp
    sendcachenote.h
    sendedituserlog.cpp
    sendedituserlog.h
    sendimageslog.cpp
    sendimageslog.h
    sendtravelbuglog.cpp
    sendtravelbuglog.h
    senduserwaypoint.cpp
    senduserwaypoint.h
    smileygc.cpp
    smileygc.h
    sqlitestorage.cpp
    sqlitestorage.h
    tilesdownloader.cpp
    tilesdownloader.h
    travelbug.cpp
    travelbug.h
    userinfo.cpp
    userinfo.h
)

qt_add_qml_module(appFastCache
    URI FastCache
    VERSION 1.0

    QML_FILES
    Main.qml
    QML/AddTextLog.qml
    QML/BoxSorting.qml
    QML/ButtonTiles.qml
    QML/CacheAttributes.qml
    QML/CacheFilter.qml
    QML/CacheIcon.qml
    QML/CachesRecordedLists.qml
    QML/CompassPage.qml
    QML/CoordinatesBox.qml
    QML/CoordinatesBox1.qml
    QML/CoordinatesBox2.qml
    QML/CoordinatesBox3.qml
    QML/CursorRectangle.qml
    QML/FastButton.qml
    QML/FastButtonIcon.qml
    QML/FastCache.qml
    QML/FastCacheDescriptionPage.qml
    QML/FastCacheDetailsPage.qml
    QML/FastCacheImagesPage.qml
    QML/FastCacheLogPage.qml
    QML/FastCacheLogsPage.qml
    QML/FastCacheTBsPage.qml
    QML/FastCacheUserLogsPage.qml
    QML/FastCacheWaypointsPage.qml
    QML/FastCalendar.qml
    QML/FastDoubleButtonMenu.qml
    QML/FastList.qml
    QML/FastMap.qml
    QML/FastMapItem.qml
    QML/FastMenu.qml
    QML/FastMenuHeader.qml
    QML/FastMenuLevel1.qml
    QML/FastMenuLevel2.qml
    QML/FastPopup.qml
    QML/FastScale.qml
    QML/FastSelectableButtonMenu.qml
    QML/FastSettings.qml
    QML/FastTravelbug.qml
    QML/FastTravelbugDetailsPage.qml
    QML/FastTravelbugLogPage.qml
    QML/FastTravelbugLogsPage.qml
    QML/Filters.qml
    QML/Geocode.qml
    QML/ImagesBrowser.qml
    QML/ListBox.qml
    QML/ListCachesSort.qml
    QML/ListPocketsqueries.qml
    QML/LoadingPage.qml
    QML/LogTypes.qml
    QML/LogTypesTravelbug.qml
    QML/MapBuild.qml
    QML/MapControls.qml
    QML/MapFullCacheItem.qml
    QML/MapUserWaypoint.qml
    QML/MapWaypoint.qml
    QML/MultiPointSlider.qml
    QML/PositionMarker.qml
    QML/RaterField.qml
    QML/SatPositionStatus.qml
    QML/SatRssiView.qml
    QML/SatSkyView.qml
    QML/SatelliteInfo.qml
    QML/SelectableFilter.qml
    QML/SelectableFilterExclude.qml
    QML/SelectableFilterKeyWord.qml
    QML/SelectableFilterLabCache.qml
    QML/SelectableFilterSize.qml
    QML/SelectableFilterType.qml
    QML/SelectedCacheItem.qml
    QML/SureQuit.qml
    QML/TabViewRecordedCaches.qml
    QML/TextField.qml
    QML/Toast.qml
    QML/TravelsbugUser.qml
    QML/UserSettings.qml
    QML/UserSettingsCircle.qml
    QML/UserSettingsMap.qml
    QML/UserWaypoint.qml

    RESOURCES
    Image/add.png
    Image/cache.png
    Image/cacheList.png
    Image/fastCache_icon.png
    Image/filter.png
    Image/filterHeadArrow.png
    Image/forward.png
    Image/goback.png
    Image/heart-green.png
    Image/icon_AdventureLab.png
    Image/icon_addImage.png
    Image/icon_backwards.png
    Image/icon_check.png
    Image/icon_compass.png
    Image/icon_delete.png
    Image/icon_edit.png
    Image/icon_erase.png
    Image/icon_north.png
    Image/icon_photo.png
    Image/icon_update.png
    Image/labCache.png
    Image/magnifying-glass.png
    Image/mapsIcon.png
    Image/marker.png
    Image/marker_found.png
    Image/marker_own.png
    Image/marker_save.png
    Image/menuIcon.png
    Image/minus.png
    Image/not_logged.png
    Image/plus.png
    Image/remove.png
    Image/satellite.png
    Image/saved-off.png
    Image/saved-on.png
    Image/scale.png
    Image/scaleEnd.png
    Image/settings.png
    Image/sort_alphabetically.png
    Image/trackable_travelbug.png
    Image/tracker.png
    Image/update-arrows.png

    Image/Attributes/attribute_abandonedbuilding.png
    Image/Attributes/attribute_available.png
    Image/Attributes/attribute_bicycles.png
    Image/Attributes/attribute_boat.png
    Image/Attributes/attribute_bonuscache.png
    Image/Attributes/attribute_campfires.png
    Image/Attributes/attribute_camping.png
    Image/Attributes/attribute_challengecache.png
    Image/Attributes/attribute_cliff.png
    Image/Attributes/attribute_climbing.png
    Image/Attributes/attribute_cow.png
    Image/Attributes/attribute_danger.png
    Image/Attributes/attribute_dangerousanimals.png
    Image/Attributes/attribute_dogs.png
    Image/Attributes/attribute_fee.png
    Image/Attributes/attribute_field_puzzle.png
    Image/Attributes/attribute_firstaid.png
    Image/Attributes/attribute_flashlight.png
    Image/Attributes/attribute_food.png
    Image/Attributes/attribute_frontyard.png
    Image/Attributes/attribute_fuel.png
    Image/Attributes/attribute_geotour.png
    Image/Attributes/attribute_hike_long.png
    Image/Attributes/attribute_hike_med.png
    Image/Attributes/attribute_hike_short.png
    Image/Attributes/attribute_hiking.png
    Image/Attributes/attribute_horses.png
    Image/Attributes/attribute_hqsolutionchecker.png
    Image/Attributes/attribute_hunting.png
    Image/Attributes/attribute_jeeps.png
    Image/Attributes/attribute_kids.png
    Image/Attributes/attribute_landf.png
    Image/Attributes/attribute_mine.png
    Image/Attributes/attribute_motorcycles.png
    Image/Attributes/attribute_night.png
    Image/Attributes/attribute_nightcache.png
    Image/Attributes/attribute_no.png
    Image/Attributes/attribute_onehour.png
    Image/Attributes/attribute_parking.png
    Image/Attributes/attribute_parkngrab.png
    Image/Attributes/attribute_partnership.png
    Image/Attributes/attribute_phone.png
    Image/Attributes/attribute_picnic.png
    Image/Attributes/attribute_poisonoak.png
    Image/Attributes/attribute_powertrail.png
    Image/Attributes/attribute_public.png
    Image/Attributes/attribute_quads.png
    Image/Attributes/attribute_rappelling.png
    Image/Attributes/attribute_restrooms.png
    Image/Attributes/attribute_rv.png
    Image/Attributes/attribute_s_tool.png
    Image/Attributes/attribute_scenic.png
    Image/Attributes/attribute_scuba.png
    Image/Attributes/attribute_seasonal.png
    Image/Attributes/attribute_skiis.png
    Image/Attributes/attribute_snowmobiles.png
    Image/Attributes/attribute_snowshoes.png
    Image/Attributes/attribute_stealth.png
    Image/Attributes/attribute_stroller.png
    Image/Attributes/attribute_swimming.png
    Image/Attributes/attribute_teamwork.png
    Image/Attributes/attribute_thorn.png
    Image/Attributes/attribute_ticks.png
    Image/Attributes/attribute_touristok.png
    Image/Attributes/attribute_treeclimbing.png
    Image/Attributes/attribute_uv.png
    Image/Attributes/attribute_wading.png
    Image/Attributes/attribute_water.png
    Image/Attributes/attribute_wheelchair.png
    Image/Attributes/attribute_winter.png
    Image/Attributes/attribute_wirelessbeacon.png

    Image/Compass/compassIcon.png
    Image/Compass/compass_arrow.png
    Image/Compass/compass_mini.png
    Image/Compass/compass_rose.png
    Image/Compass/compass_underlay.png

    Image/Waypoints/waypoint_flag.png
    Image/Waypoints/waypoint_pkg.png
    Image/Waypoints/waypoint_puzzle.png
    Image/Waypoints/waypoint_stage.png
    Image/Waypoints/waypoint_trailhead.png
    Image/Waypoints/waypoint_user.png
    Image/Waypoints/waypoint_waypoint.png

    Image/logTypes/marker_archive.png
    Image/logTypes/marker_found_offline.png
    Image/logTypes/marker_maintenance.png
    Image/logTypes/marker_not_found_offline.png
    Image/logTypes/marker_note.png

    QML/JavaScript/MainFunctions.js
    QML/JavaScript/Palette.js
    QML/JavaScript/helper.js

    Ressources/DellaRespira-Regular.ttf
)

if(ANDROID)
    set_target_properties(appFastCache
        PROPERTIES
        QT_ANDROID_PACKAGE_SOURCE_DIR ${CMAKE_CURRENT_SOURCE_DIR}/android
        QT_ANDROID_TARGET_SDK_VERSION "33")
endif()

target_link_libraries(appFastCache
    PRIVATE Qt6::Quick
    Qt6::Svg
    Qt6::Location
    Qt6::Sql
    Qt6::Core
    Qt6::Bluetooth
    Qt6::WebView
    Qt6::Sensors
    Qt6::Qml
)

if(NOT ANDROID)
    target_link_libraries(appFastCache
        PRIVATE Qt6::WebEngineQuick
    )
endif()

include(GNUInstallDirs)
install(TARGETS appFastCache
    BUNDLE DESTINATION .
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
)

# Add googlemaps plugin geoservice in armeabi-v7a
if (QT_ANDROID_ABIS STREQUAL "armeabi-v7a")
    set_target_properties(appFastCache PROPERTIES
        QT_ANDROID_EXTRA_LIBS "${CMAKE_PREFIX_PATH}/plugins/geoservices/libplugins_geoservices_qtgeoservices_googlemaps_armeabi-v7a_armeabi-v7a.so"
    )
    qt_add_executable(libplugins_geoservices_qtgeoservices_googlemaps_armeabi-v7a_armeabi-v7a.so)

#Add openssl in armeabi-v7a
    add_library(ssl_3 SHARED IMPORTED) # or STATIC instead of SHARED
    set_target_properties(ssl_3 PROPERTIES IMPORTED_LOCATION "${CMAKE_SOURCE_DIR}/Ressources/ssl_3/armeabi-v7a/libssl_3.so")
    target_link_libraries(appFastCache PRIVATE ssl_3) # also adds the required include path

    add_library(crypto_3 SHARED IMPORTED) # or STATIC instead of SHARED
    set_target_properties(crypto_3 PROPERTIES IMPORTED_LOCATION "${CMAKE_SOURCE_DIR}/Ressources/ssl_3/armeabi-v7a/libcrypto_3.so")
    target_link_libraries(appFastCache PRIVATE crypto_3) # also adds the required include path
endif()

# Add googlemaps plugin geoservice in arm64-v8a
if (QT_ANDROID_ABIS STREQUAL "arm64-v8a")
    set_target_properties(appFastCache PROPERTIES
        QT_ANDROID_EXTRA_LIBS "${CMAKE_PREFIX_PATH}/plugins/geoservices/libplugins_geoservices_qtgeoservices_googlemaps_arm64-v8a_arm64-v8a.so"
    )
    qt_add_executable(libplugins_geoservices_qtgeoservices_googlemaps_arm64-v8a_arm64-v8a.so)

#Add openssl in arm64-v8a
    add_library(ssl_3 SHARED IMPORTED) # or STATIC instead of SHARED
    set_target_properties(ssl_3 PROPERTIES IMPORTED_LOCATION "${CMAKE_SOURCE_DIR}/Ressources/ssl_3/arm64-v8a/libssl_3.so")
    target_link_libraries(appFastCache PRIVATE ssl_3) # also adds the required include path

    add_library(crypto_3 SHARED IMPORTED) # or STATIC instead of SHARED
    set_target_properties(crypto_3 PROPERTIES IMPORTED_LOCATION "${CMAKE_SOURCE_DIR}/Ressources/ssl_3/arm64-v8a/libcrypto_3.so")
    target_link_libraries(appFastCache PRIVATE crypto_3) # also adds the required include path
endif()
