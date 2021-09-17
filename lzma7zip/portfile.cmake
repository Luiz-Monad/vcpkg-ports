
set(7ZIP_VERSION 19.00)
vcpkg_download_distfile(ARCHIVE
    URLS "https://www.7-zip.org/a/7z1900-src.7z"
    FILENAME "7z1900-src.7z"
    SHA512 d68b308e175224770adc8b1495f1ba3cf3e7f67168a7355000643d3d32560ae01aa34266f0002395181ed91fb5e682b86e0f79c20625b42d6e2c62dd24a5df93
)

vcpkg_extract_source_archive_ex(
    OUT_SOURCE_PATH SOURCE_PATH
    ARCHIVE ${ARCHIVE}
    REF ${7ZIP_VERSION}
    NO_REMOVE_ONE_LEVEL
)

file(COPY ${CMAKE_CURRENT_LIST_DIR}/CMakeLists.txt DESTINATION ${SOURCE_PATH})
file(COPY ${CMAKE_CURRENT_LIST_DIR}/Lzma7ZipConfig.cmake.in DESTINATION ${SOURCE_PATH})

vcpkg_cmake_configure(
    SOURCE_PATH ${SOURCE_PATH}
    OPTIONS_DEBUG
      -DCMAKE_DEBUG_POSTFIX=d
)

vcpkg_cmake_install()
vcpkg_copy_pdbs()

vcpkg_cmake_config_fixup(CONFIG_PATH share/lzma7z)

file(
    INSTALL ${CMAKE_CURRENT_LIST_DIR}/License.txt
    DESTINATION ${CURRENT_PACKAGES_DIR}/share/${PORT}
    RENAME copyright
)

if (NOT VCPKG_BUILD_TYPE OR VCPKG_BUILD_TYPE STREQUAL "release")
  set(LIB_PREFIX "${CURRENT_INSTALLED_DIR}")
  set(LIBNAME lzma7zip)
  configure_file("${CMAKE_CURRENT_LIST_DIR}/lzma.pc.in" "${CURRENT_PACKAGES_DIR}/lib/pkgconfig/lzma.pc" @ONLY)
endif()

if (NOT VCPKG_BUILD_TYPE OR VCPKG_BUILD_TYPE STREQUAL "debug")
  set(LIB_PREFIX "${CURRENT_INSTALLED_DIR}/debug")
  set(LIBNAME lzma7zip)
  configure_file("${CMAKE_CURRENT_LIST_DIR}/lzma.pc.in" "${CURRENT_PACKAGES_DIR}/debug/lib/pkgconfig/lzma.pc" @ONLY)
endif()

vcpkg_fixup_pkgconfig()
