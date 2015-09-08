cmake_minimum_required(VERSION 2.6)

project(DesktopWeather)

find_package(Qt4 REQUIRED)
find_package(KDE4 REQUIRED)

include(KDE4Defaults)

install (DIRECTORY package/
         DESTINATION ${DATA_INSTALL_DIR}/plasma/plasmoids/org.monarq.desktop.weather)

install (FILES package/metadata.desktop
         DESTINATION ${SERVICES_INSTALL_DIR} RENAME plasma-applet-desktop-weather.desktop)
