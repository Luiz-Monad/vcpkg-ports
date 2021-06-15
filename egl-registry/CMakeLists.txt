
cmake_minimum_required(VERSION 3.8)
project(egl-registry)

include(GNUInstallDirs)

add_library(libGLESv2 INTERFACE)

install(
    TARGETS libGLESv2
    EXPORT EGLRegistryExport
    INCLUDES DESTINATION ${CMAKE_INSTALL_INCLUDEDIR}
)

install(
    EXPORT EGLRegistryExport
    FILE egl-registry-config.cmake 
    NAMESPACE egl-registry:: 
    DESTINATION share/EGL-Registry
)
