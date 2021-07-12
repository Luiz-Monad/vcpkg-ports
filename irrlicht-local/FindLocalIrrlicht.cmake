
if(CMAKE_BUILD_TYPE MATCHES "^[Dd][Ee][Bb][Uu][Gg]$" OR NOT DEFINED CMAKE_BUILD_TYPE)
    set(VCPKG_TARGET_TRIPLET_CONF "debug")
else()
    set(VCPKG_TARGET_TRIPLET_CONF "release")
endif()
set(TRI ${VCPKG_TARGET_TRIPLET}-${VCPKG_TARGET_TRIPLET_CONF})

set(Irrlicht_DIR $ENV{P_project_output}/irrlicht-ogl-es/${TRI}/share/irrlicht)
_find_package(Irrlicht CONFIG REQUIRED)

if(Irrlicht_FOUND AND NOT TARGET Irrlicht::irrlicht)
    add_library(Irrlicht::irrlicht INTERFACE IMPORTED CONFIGURATIONS ${CMAKE_BUILD_TYPE})
    target_link_libraries(Irrlicht::irrlicht INTERFACE ${Irrlicht_LIBRARIES} CONFIGURATIONS ${CMAKE_BUILD_TYPE})
endif()
