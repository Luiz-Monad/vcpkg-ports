# ----------------------------------------------------------------------------
#  General validations
# ----------------------------------------------------------------------------

# Disable in-source builds to prevent source tree corruption.
if(" ${CMAKE_SOURCE_DIR}" STREQUAL " ${CMAKE_BINARY_DIR}")
  message(FATAL_ERROR "FATAL: In-source builds are not allowed.
       You should create a separate directory for build files.")
endif()

include(${CMAKE_CURRENT_FUNCTION_LIST_DIR}/summary/utils.cmake)

# ----------------------------------------------------------------------------
# Break in case of popular CMake configuration mistakes
# ----------------------------------------------------------------------------
if(NOT CMAKE_SIZEOF_VOID_P GREATER 0)
  message(FATAL_ERROR "CMake fails to determine the bitness of the target platform.
  Please check your CMake and compiler installation. If you are cross-compiling then ensure that your CMake toolchain file correctly sets the compiler details.")
endif()

# ----------------------------------------------------------------------------
# Detect compiler and target platform architecture
# ----------------------------------------------------------------------------
include(${CMAKE_CURRENT_FUNCTION_LIST_DIR}/summary/detect_compiler.cmake)

# ----------------------------------------------------------------------------
# Get actual version number from sources
# ----------------------------------------------------------------------------
include(${CMAKE_CURRENT_FUNCTION_LIST_DIR}/summary/version.cmake)

# ----------------------------------------------------------------------------
# Autodetect if we are in a GIT repository
# ----------------------------------------------------------------------------
find_host_package(Git QUIET)

if(NOT DEFINED _TMP_VCSVERSION AND GIT_FOUND)
  pmake_git_describe(_TMP_VCSVERSION "${CMAKE_CURRENT_LIST_DIR}")
elseif(NOT DEFINED _TMP_VCSVERSION)
  # We don't have git:
  set(_TMP_VCSVERSION "unknown")
endif()

# ----------------------------------------------------------------------------
# Summary:
# ----------------------------------------------------------------------------

status("")
status("General ${PROJECT_NAME} (${PROJECT_VERSION}) configuration ${CMAKE_BUILD_TYPE} =======================================")
if(_TMP_VCSVERSION)
  status("  Version control:" ${_TMP_VCSVERSION})
  status("  Version header:" ${PMAKE_VERSION})
endif()

# ========================== build platform ==========================
status("")
status("  Platform:")
status("    Host:"             ${CMAKE_HOST_SYSTEM_NAME} ${CMAKE_HOST_SYSTEM_VERSION} ${CMAKE_HOST_SYSTEM_PROCESSOR})
if(CMAKE_CROSSCOMPILING)
  status("    Target:"         ${CMAKE_SYSTEM_NAME} ${CMAKE_SYSTEM_VERSION} ${CMAKE_SYSTEM_PROCESSOR})
endif()
status("    CMake:"            ${CMAKE_VERSION})
status("    CMake generator:"  ${CMAKE_GENERATOR})
status("    CMake build tool:" ${CMAKE_BUILD_TOOL})
if(MSVC)
  status("    MSVC:"           ${MSVC_VERSION})
endif()
if(CMAKE_GENERATOR MATCHES Xcode)
  status("    Xcode:"          ${XCODE_VERSION})
endif()
if(NOT CMAKE_GENERATOR MATCHES "Xcode|Visual Studio")
  status("    Configuration:"  ${CMAKE_BUILD_TYPE})
endif()

# ======================== dependency manager ========================
pmake_cmake_find_vars(_TARGET_IS VCPKG_TARGET_IS_)
pmake_cmake_find_vars(_HOST_IS VCPKG_HOST_IS_)
status("")
status("  VcPkg:")
status("    Target Arch:" ${VCPKG_TARGET_ARCHITECTURE})
status("    Target Triplet:" ${VCPKG_TARGET_TRIPLET})
status("    Target Is:" ${_TARGET_IS})
status("    Host Is:" ${_HOST_IS})
status("    CRT linkage:" ${VCPKG_CRT_LINKAGE})
status("    Library linkage:" ${VCPKG_LIBRARY_LINKAGE})
status("    CMake system name:" ${VCPKG_CMAKE_SYSTEM_NAME})
status("    CMake system version:" ${VCPKG_CMAKE_SYSTEM_VERSION})
status("    Chainload toolchain:" ${VCPKG_CHAINLOAD_TOOLCHAIN_FILE})
status("    Install options:" ${VCPKG_INSTALL_OPTIONS})
status("    Manifest:" ${VCPKG_MANIFEST_DIR})
status("      Install:" ${VCPKG_MANIFEST_INSTALL})
status("      Mode:" ${VCPKG_MANIFEST_MODE})

# ========================== C/C++ options ===========================
if(CMAKE_CXX_COMPILER_VERSION)
  set(_TMP_COMPILER_STR "${CMAKE_CXX_COMPILER} ${CMAKE_CXX_COMPILER_ARG1} (ver ${CMAKE_CXX_COMPILER_VERSION})")
else()
  set(_TMP_COMPILER_STR "${CMAKE_CXX_COMPILER} ${CMAKE_CXX_COMPILER_ARG1}")
endif()
string(STRIP "${_TMP_COMPILER_STR}" _TMP_COMPILER_STR)

status("")
status("  C/C++:")
status("    Built as dynamic libs?:" BUILD_SHARED_LIBS THEN YES ELSE NO)
if(DEFINED CMAKE_CXX_STANDARD AND CMAKE_CXX_STANDARD)
  status("    C++ standard:"           "${CMAKE_CXX_STANDARD}")
endif()
status("    C++ Compiler:"           ${_TMP_COMPILER_STR})
status("    C++ flags (Release):"    ${CMAKE_CXX_FLAGS} ${CMAKE_CXX_FLAGS_RELEASE})
status("    C++ flags (Debug):"      ${CMAKE_CXX_FLAGS} ${CMAKE_CXX_FLAGS_DEBUG})
status("    C Compiler:"             ${CMAKE_C_COMPILER} ${CMAKE_C_COMPILER_ARG1})
status("    C flags (Release):"      ${CMAKE_C_FLAGS} ${CMAKE_C_FLAGS_RELEASE})
status("    C flags (Debug):"        ${CMAKE_C_FLAGS} ${CMAKE_C_FLAGS_DEBUG})
if(NOT BUILD_SHARED_LIBS)
  status("    Linker flags (Release):" ${CMAKE_EXE_STATIC_FLAGS} ${CMAKE_EXE_STATIC_FLAGS_RELEASE})
  status("    Linker flags (Debug):"   ${CMAKE_EXE_STATIC_FLAGS} ${CMAKE_EXE_STATIC_FLAGS_DEBUG})
elseif(WIN32)
  status("    Linker flags (Release):" ${CMAKE_EXE_LINKER_FLAGS} ${CMAKE_EXE_LINKER_FLAGS_RELEASE})
  status("    Linker flags (Debug):"   ${CMAKE_EXE_LINKER_FLAGS} ${CMAKE_EXE_LINKER_FLAGS_DEBUG})
else()
  status("    Linker flags (Release):" ${CMAKE_SHARED_LINKER_FLAGS} ${CMAKE_SHARED_LINKER_FLAGS_RELEASE})
  status("    Linker flags (Debug):"   ${CMAKE_SHARED_LINKER_FLAGS} ${CMAKE_SHARED_LINKER_FLAGS_DEBUG})
endif()
status("    Precompiled headers:"     ${PRECOMPILE_HEADERS} THEN YES ELSE NO)

# ============================== Modules =============================
status("")
status("  Modules:")
status("    To be built:" ${BUILDSYSTEM_TARGETS})

# ======================== Windows RT features =======================
if(WIN32)
status("")
status("  Windows RT support:" WINRT THEN YES ELSE NO)
  if(WINRT)
    status("    Building for Microsoft platform: " ${CMAKE_SYSTEM_NAME})
    status("    Building for architectures: " ${CMAKE_VS_EFFECTIVE_PLATFORMS})
    status("    Building for version: " ${CMAKE_SYSTEM_VERSION})
    if (DEFINED ENABLE_WINRT_MODE_NATIVE)
      status("    Building for C++ without CX extensions")
    endif()
  endif()
endif(WIN32)

# ----------------------------------------------------------------------------
# Extra:
# ----------------------------------------------------------------------------
include(${PMAKE_SOURCE_ROOT}/cmake/dashboard.cmake)

# ========================== auxiliary ==========================
status("")
status("  Install to:" "${CMAKE_INSTALL_PREFIX}")
status("-----------------------------------------------------------------")
status("")
pmake_finalize_status()

# ----------------------------------------------------------------------------
# Debug stuff
# ----------------------------------------------------------------------------

# This should be the last command
pmake_cmake_dump_vars("" TOFILE "CMakeVars.txt")
