
cmake_minimum_required(VERSION 3.8)
project(opengl-registry)

include(GNUInstallDirs)

add_library(OpenGlHeaders INTERFACE)

install(
    TARGETS OpenGlHeaders
    EXPORT OpenGLRegistryExport
    INCLUDES DESTINATION ${CMAKE_INSTALL_INCLUDEDIR}
)

install(
    EXPORT OpenGLRegistryExport
    FILE opengl-registry-config.cmake 
    NAMESPACE opengl-registry:: 
    DESTINATION share/OpenGL-Registry
)
