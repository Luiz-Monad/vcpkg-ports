
if(CMAKE_BUILD_TYPE MATCHES "^[Dd][Ee][Bb][Uu][Gg]$" OR NOT DEFINED CMAKE_BUILD_TYPE)
    set(VCPKG_TARGET_TRIPLET_CONF "debug")
else()
    set(VCPKG_TARGET_TRIPLET_CONF "release")
endif()
set(TRI ${VCPKG_TARGET_TRIPLET}-${VCPKG_TARGET_TRIPLET_CONF})

set(OpenCV_DIR $ENV{P_project_output}/opencv/${TRI}/share/opencv)
_find_package(OpenCV CONFIG REQUIRED)

if(OpenCV_FOUND AND NOT TARGET OpenCV::OpenCV)
    add_library(OpenCV::OpenCV INTERFACE IMPORTED CONFIGURATIONS Release)
    target_link_libraries(OpenCV::OpenCV INTERFACE ${OpenCV_LIBS} CONFIGURATIONS Release)
endif()
