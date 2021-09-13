
cmake_minimum_required(VERSION 3.8)
project(egl-registry)

include(GNUInstallDirs)

add_library(EGLHeaders INTERFACE)

install(
    TARGETS EGLHeaders
    EXPORT EGLRegistryExport
    INCLUDES DESTINATION ${CMAKE_INSTALL_INCLUDEDIR}
)

install(
    EXPORT EGLRegistryExport
    FILE egl-registry-config.cmake 
    NAMESPACE egl-registry:: 
    DESTINATION share/EGL-Registry
)
