# This file is derived work from part of the OpenCV project.
# It is subject to the license terms in the LICENSE file found in the top-level directory
# of this distribution and at http://opencv.org/license.html.

# Compilers:
# - PMAKE_GCC - GNU compiler (CMAKE_CXX_COMPILER_ID STREQUAL "GNU")
# - PMAKE_CLANG - Clang-compatible compiler (CMAKE_CXX_COMPILER_ID MATCHES "Clang" - Clang or AppleClang, see CMP0025)
# - PMAKE_ICC - Intel compiler
# - MSVC - Microsoft Visual Compiler (CMake variable)
# - MINGW / CYGWIN / CMAKE_COMPILER_IS_MINGW / CMAKE_COMPILER_IS_CYGWIN (CMake original variables)
#
# CPU Platforms:
# - X86 / X86_64
# - ARM - ARM CPU, not defined for AArch64
# - AARCH64 - ARMv8+ (64-bit)
# - PPC64 / PPC64LE - PowerPC
# - MIPS
#
# OS:
# - WIN32 - Windows | MINGW
# - UNIX - Linux | MacOSX | ANDROID
# - ANDROID
# - IOS
# - APPLE - MacOSX | iOS
# ----------------------------------------------------------------------------

if(NOT DEFINED PMAKE_GCC AND CMAKE_CXX_COMPILER_ID MATCHES "GNU")
  set(PMAKE_GCC 1)
endif()
if(NOT DEFINED PMAKE_CLANG AND CMAKE_CXX_COMPILER_ID MATCHES "Clang")  # Clang or AppleClang (see CMP0025)
  set(PMAKE_CLANG 1)
endif()

# ----------------------------------------------------------------------------
# Detect Intel ICC compiler
# ----------------------------------------------------------------------------
if(UNIX)
  if(__ICL)
    set(PMAKE_ICC   __ICL)
  elseif(__ICC)
    set(PMAKE_ICC   __ICC)
  elseif(__ECL)
    set(PMAKE_ICC   __ECL)
  elseif(__ECC)
    set(PMAKE_ICC   __ECC)
  elseif(__INTEL_COMPILER)
    set(PMAKE_ICC   __INTEL_COMPILER)
  elseif(CMAKE_C_COMPILER MATCHES "icc")
    set(PMAKE_ICC   icc_matches_c_compiler)
  endif()
endif()

if(MSVC AND CMAKE_C_COMPILER MATCHES "icc|icl")
  set(PMAKE_ICC   __INTEL_COMPILER_FOR_WINDOWS)
endif()

if(NOT DEFINED CMAKE_CXX_COMPILER_VERSION
    AND NOT PMAKE_SUPPRESS_MESSAGE_MISSING_COMPILER_VERSION)
  message(WARNING "PMAKE: Compiler version is not available: CMAKE_CXX_COMPILER_VERSION is not set")
endif()
if((NOT DEFINED CMAKE_SYSTEM_PROCESSOR OR CMAKE_SYSTEM_PROCESSOR STREQUAL "")
    AND NOT PMAKE_SUPPRESS_MESSAGE_MISSING_CMAKE_SYSTEM_PROCESSOR)
  message(WARNING "PMAKE: CMAKE_SYSTEM_PROCESSOR is not defined. Perhaps CMake toolchain is broken")
endif()
if(NOT DEFINED CMAKE_SIZEOF_VOID_P
    AND NOT PMAKE_SUPPRESS_MESSAGE_MISSING_CMAKE_SIZEOF_VOID_P)
  message(WARNING "PMAKE: CMAKE_SIZEOF_VOID_P is not defined. Perhaps CMake toolchain is broken")
endif()

message(STATUS "Detected processor: ${CMAKE_SYSTEM_PROCESSOR}")
if(CMAKE_SYSTEM_PROCESSOR MATCHES "(amd64|x86_64|x64)")
  set(X86_64 1)
elseif(CMAKE_SYSTEM_PROCESSOR MATCHES "(i686|i386|x86)")
  set(X86 1)
elseif(CMAKE_SYSTEM_PROCESSOR MATCHES "(arm64|aarch64)")
  set(AARCH64 1)
elseif(CMAKE_SYSTEM_PROCESSOR MATCHES "(arm|armeabi|armv7)")
  set(ARM 1)
else()
  if(NOT PMAKE_SUPPRESS_MESSAGE_UNRECOGNIZED_SYSTEM_PROCESSOR)
    message(WARNING "PMAKE: unrecognized target processor configuration")
  endif()
endif()

# Workaround for 32-bit operating systems on x86_64
if(CMAKE_SIZEOF_VOID_P EQUAL 4 AND X86_64
    AND NOT FORCE_X86_64  # deprecated (2019-12)
    AND NOT PMAKE_FORCE_X86_64
)
  message(STATUS "sizeof(void) = 4 on 64 bit processor. Assume 32-bit compilation mode")
  if(X86_64)
    unset(X86_64)
    set(X86 1)
  endif()
endif()
# Workaround for 32-bit operating systems on aarch64 processor
if(CMAKE_SIZEOF_VOID_P EQUAL 4 AND AARCH64
    AND NOT PMAKE_FORCE_AARCH64
)
  message(STATUS "sizeof(void) = 4 on 64 bit processor. Assume 32-bit compilation mode")
  if(AARCH64)
    unset(AARCH64)
    set(ARM 1)
  endif()
endif()


# Similar code exists in OpenCVConfig.cmake
if(NOT DEFINED PMAKE_STATIC)
  # look for global setting
  if(NOT DEFINED BUILD_SHARED_LIBS OR BUILD_SHARED_LIBS)
    set(PMAKE_STATIC OFF)
  else()
    set(PMAKE_STATIC ON)
  endif()
endif()

if(DEFINED PMAKE_ARCH AND DEFINED PMAKE_RUNTIME)
  # custom overridden values
elseif(MSVC)
  # see Modules/CMakeGenericSystem.cmake
  if("${CMAKE_GENERATOR}" MATCHES "(Win64|IA64)")
    set(PMAKE_ARCH "x64")
  elseif("${CMAKE_GENERATOR_PLATFORM}" MATCHES "ARM64")
    set(PMAKE_ARCH "ARM64")
  elseif("${CMAKE_GENERATOR}" MATCHES "ARM")
    set(PMAKE_ARCH "ARM")
  elseif("${CMAKE_SIZEOF_VOID_P}" STREQUAL "8")
    set(PMAKE_ARCH "x64")
  else()
    set(PMAKE_ARCH x86)
  endif()

  if(MSVC_VERSION EQUAL 1400)
    set(PMAKE_RUNTIME vc8)
  elseif(MSVC_VERSION EQUAL 1500)
    set(PMAKE_RUNTIME vc9)
  elseif(MSVC_VERSION EQUAL 1600)
    set(PMAKE_RUNTIME vc10)
  elseif(MSVC_VERSION EQUAL 1700)
    set(PMAKE_RUNTIME vc11)
  elseif(MSVC_VERSION EQUAL 1800)
    set(PMAKE_RUNTIME vc12)
  elseif(MSVC_VERSION EQUAL 1900)
    set(PMAKE_RUNTIME vc14)
  elseif(MSVC_VERSION MATCHES "^191[0-9]$")
    set(PMAKE_RUNTIME vc15)
  elseif(MSVC_VERSION MATCHES "^192[0-9]$")
    set(PMAKE_RUNTIME vc16)
  else()
    message(WARNING "IRR does not recognize MSVC_VERSION \"${MSVC_VERSION}\". Cannot set PMAKE_RUNTIME")
  endif()
elseif(MINGW)
  set(PMAKE_RUNTIME mingw)

  if(CMAKE_SYSTEM_PROCESSOR MATCHES "amd64.*|x86_64.*|AMD64.*")
    set(PMAKE_ARCH x64)
  else()
    set(PMAKE_ARCH x86)
  endif()
endif()

if(NOT PMAKE_SKIP_CMAKE_CXX_STANDARD)
  if(CMAKE_CXX11_COMPILE_FEATURES)
    set(HAVE_CXX11 ON)
  endif()
endif()
