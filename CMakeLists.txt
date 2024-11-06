cmake_minimum_required(VERSION 3.16)
project(hyprdashboard_qt6 LANGUAGES CXX)

set(CMAKE_AUTOMOC ON)

find_package(Qt6 REQUIRED COMPONENTS Core Gui Widgets QuickWidgets Network Quick QuickControls2)

qt_add_executable(hyprdash WIN32 MACOSX_BUNDLE
    main.cpp
    include/config/globals.h
    include/config/settings.h
    include/config/settings.cpp
    include/processor/worker.h
    include/processor/worker.cpp
    include/processor/processor.h
    include/processor/processor.cpp
    include/socket/server.h
    include/socket/server.cpp
    include/socket/client.h
    include/socket/client.cpp
    include/socket/imap.h
    include/socket/imap.cpp
)

set(qml_singletons
    config/Settings.qml
)

qt_add_qml_module(hyprdash
    URI hyprdashboard_qt6
    VERSION 1.0
    NO_RESOURCE_TARGET_PATH
    QML_FILES
        "hyprdash.qml"
        "components/ActionButton.qml"
        "components/AppLauncher.qml"
        "components/Box.qml"
        "components/Clock.qml"
        "components/Locations.qml"
        "components/Mail.qml"
        "components/Performance.qml"
        "components/RssReader.qml"
        "components/RssTabBar.qml"
        "components/TileLauncher.qml"
        "components/UpTime.qml"
        "components/User.qml"
        "components/Weather.qml"
        ${qml_singletons}
    RESOURCES
        "components/qmldir"
        "config/qmldir"
        "js/helpers.js"
        "resources/bg.png"
        "resources/blueman.png"
        "resources/code.svg"
        "resources/cpu.svg"
        "resources/cq_mono.otf"
        "resources/discord.svg"
        "resources/files.svg"
        "resources/firefox.svg"
        "resources/folder-download.svg"
        "resources/folder-music.svg"
        "resources/folder-settings.svg"
        "resources/folder-user.svg"
        "resources/folder.svg"
        "resources/geforcenow.jpg"
        "resources/gimp.svg"
        "resources/gmail.svg"
        "resources/home.svg"
        "resources/inkscape.svg"
        "resources/inquies.svg"
        "resources/logout.svg"
        "resources/netflix.svg"
        "resources/pokerth.svg"
        "resources/poweroff.svg"
        "resources/profile.jpg"
        "resources/ram.svg"
        "resources/reboot.svg"
        "resources/scinexx.png"
        "resources/settings.svg"
        "resources/ssd.svg"
        "resources/steam.png"
        "resources/steam.svg"
        "resources/suspend.svg"
        "resources/tagesschau.svg"
        "resources/temperature.svg"
        "resources/terminal.svg"
        "resources/timer.svg"
        "resources/whatsapp.svg"
        "resources/xbox.png"
        "resources/openweather/01d.svg"
        "resources/openweather/01n.svg"
        "resources/openweather/02d.svg"
        "resources/openweather/02n.svg"
        "resources/openweather/03d.svg"
        "resources/openweather/03n.svg"
        "resources/openweather/04d.svg"
        "resources/openweather/04n.svg"
        "resources/openweather/09d.svg"
        "resources/openweather/09n.svg"
        "resources/openweather/10d.svg"
        "resources/openweather/10n.svg"
        "resources/openweather/11d.svg"
        "resources/openweather/11n.svg"
        "resources/openweather/13d.svg"
        "resources/openweather/13n.svg"
        "resources/openweather/50d.svg"
        "resources/openweather/50n.svg"
        "resources/openweather/1232n.svg"
        "qmldir"
        "qtquickcontrols2.conf"
)

target_link_libraries(hyprdash PUBLIC
    Qt6::Core
    Qt6::Gui
    Qt6::Network
    Qt6::Quick
    Qt6::QuickControls2
    Qt6::Widgets
    Qt6::QuickWidgets
)

if(UNIX AND NOT APPLE AND CMAKE_CROSSCOMPILING)
    find_package(Qt6 REQUIRED COMPONENTS QuickTemplates2)
endif()

list( APPEND CMAKE_INSTALL_RPATH ${CMAKE_INSTALL_PREFIX}/lib )

install(TARGETS hyprdash
    BUNDLE  DESTINATION .
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
)

qt_generate_deploy_qml_app_script(
   TARGET hyprdash
   OUTPUT_SCRIPT deploy_script
   MACOS_BUNDLE_POST_BUILD
   NO_UNSUPPORTED_PLATFORM_ERROR
   DEPLOY_USER_QML_MODULES_ON_UNSUPPORTED_PLATFORM
)
install(SCRIPT ${deploy_script})
