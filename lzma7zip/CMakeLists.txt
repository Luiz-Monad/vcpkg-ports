# Created from 7-zip v19.00 - 7zip/CPP/7zip/Bundles/Format7zF

cmake_minimum_required(VERSION 3.11)
cmake_policy(VERSION 3.11)

set(LZMA_VER "19.00")
project(LZMA VERSION ${LZMA_VER} LANGUAGES C CXX)

set(SRC_C
    C/LzmaDec.c
    C/LzmaEnc.c
    C/LzmaLib.c
)

set_source_files_properties(
    ${SRC_C}
        PROPERTIES
            COMPILE_FLAGS $<$<CONFIG:RELEASE>:"-O2">
)

add_library(
    LZMA
    ${SRC_C}
    C/Util/LzmaLib/LzmaLib.def
)

set_target_properties(
    LZMA
    PROPERTIES
    OUTPUT_NAME lzma
    DEBUG_POSTFIX d
    VERSION ${LZMA_VER}
    SOVERSION 1.0)

target_compile_definitions(
    LZMA
    PUBLIC
        -D_7ZIP_ST
        -DUNICODE
        -D_UNICODE
)

if(MSVC)
target_compile_options(
    LZMA
    PRIVATE
        /wd5043
        $<$<CONFIG:RELEASE>:/guard:cf>
)
endif()

target_include_directories(
    LZMA
    INTERFACE
        $<INSTALL_INTERFACE:include>/lzma
)

set(PUBLIC_HEADERS
    C/7zTypes.h
    C/Alloc.h
    C/LzmaDec.h
    C/LzmaEnc.h
    C/LzmaLib.h
)

include(GNUInstallDirs)

install(
    TARGETS LZMA
    EXPORT LZMA
    ARCHIVE DESTINATION lib
    LIBRARY DESTINATION lib
    RUNTIME DESTINATION bin
)

install(
    FILES ${PUBLIC_HEADERS}
    DESTINATION include/lzma
    CONFIGURATIONS Release
)

install(
    EXPORT LZMA
    DESTINATION share/LZMA
    FILE LZMATargets.cmake
    NAMESPACE LZMA::
)

include(CMakePackageConfigHelpers)

write_basic_package_version_file(
    ${CMAKE_CURRENT_BINARY_DIR}/LZMAConfigVersion.cmake
    COMPATIBILITY AnyNewerVersion
)
install(
    FILES ${CMAKE_CURRENT_BINARY_DIR}/LZMAConfigVersion.cmake
    DESTINATION share/LZMA
)

configure_package_config_file(
    ${CMAKE_CURRENT_SOURCE_DIR}/LZMAConfig.cmake.in
    ${CMAKE_CURRENT_BINARY_DIR}/LZMAConfig.cmake
    INSTALL_DESTINATION share/LZMA
)

install(
    FILES ${CMAKE_CURRENT_BINARY_DIR}/LZMAConfig.cmake
    DESTINATION share/LZMA
)
