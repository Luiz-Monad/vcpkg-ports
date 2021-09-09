vcpkg_fail_port_install(ON_ARCH "arm" ON_TARGET "osx" "uwp")

vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO luiz-monad/Irrlicht%20SDK
    REF customport
    SHA512 de69ddd2c6bc80a1b27b9a620e3697b1baa552f24c7d624076d471f3aecd9b15f71dce3b640811e6ece20f49b57688d428e3503936a7926b3e3b0cc696af98d1
)

configure_file(${CMAKE_CURRENT_LIST_DIR}/CMakeLists.txt ${SOURCE_PATH}/CMakeLists.txt COPYONLY)

vcpkg_check_features(OUT_FEATURE_OPTIONS FEATURE_OPTIONS FEATURES
        unicode     IRR_UNICODE_PATH
        fast-fpu    IRR_FAST_MATH
        tools       IRR_BUILD_TOOLS
        win32ui     WITH_WIN32UI
        directx     WITH_DIRECTX
        opengl      WITH_OPENGL
        vulkan      WITH_VULKAN
        webgl       WITH_WEBGL
        angle       WITH_ANGLE
)

if(VCPKG_LIBRARY_LINKAGE STREQUAL "dynamic")
  set(IRR_SHARED_LIB ON)
endif()

if(VCPKG_TARGET_IS_EMSCRIPTEN)
  set(WITH_WEBGL ON)
endif()

if(VCPKG_TARGET_IS_WINDOWS)
  set(WITH_WIN32UI ON)
  #set(WITH_DIRECTX ON)
  set(WITH_ANGLE ON)
  set(IRR_UNICODE_PATH ON)
endif()

if(VCPKG_TARGET_IS_LINUX)
  set(WITH_OPENGL ON)
endif()

if(IOS)
  # test_big_endian needs try_compile, which doesn't work for iOS
  # http://public.kitware.com/Bug/view.php?id=12288
  set(WORDS_BIGENDIAN 0)
else()
  include(TestBigEndian)
  test_big_endian(WORDS_BIGENDIAN)
endif()

vcpkg_cmake_configure(
    SOURCE_PATH ${SOURCE_PATH}
    OPTIONS
        -DWORDS_BIGENDIAN=${WORDS_BIGENDIAN}
        -DIRR_SHARED_LIB=${IRR_SHARED_LIB}
        -DIRR_UNICODE_PATH=${IRR_UNICODE_PATH}
        -DIRR_FAST_MATH=${IRR_FAST_MATH}
        -DIRR_BUILD_TOOLS=${IRR_BUILD_TOOLS}
        -DWITH_WIN32UI=${WITH_WIN32UI}
        -DWITH_DIRECTX=${WITH_DIRECTX}
        -DWITH_OPENGL=${WITH_OPENGL}
        -DWITH_VULKAN=${WITH_VULKAN}
        -DWITH_WEBGL=${WITH_WEBGL}
        -DWITH_ANGLE=${WITH_ANGLE}
)

vcpkg_cmake_install()

vcpkg_cmake_config_fixup()

if("tools" IN_LIST FEATURES)
    vcpkg_copy_tool_dependencies(${CURRENT_PACKAGES_DIR}/tools/irrlicht/)
endif()

file(WRITE ${CURRENT_PACKAGES_DIR}/share/irrlicht/irrlicht-config.cmake "include(\${CMAKE_CURRENT_LIST_DIR}/irrlicht-targets.cmake)")

vcpkg_copy_pdbs()

file(INSTALL ${CMAKE_CURRENT_LIST_DIR}/LICENSE.txt DESTINATION ${CURRENT_PACKAGES_DIR}/share/${PORT} RENAME copyright)
