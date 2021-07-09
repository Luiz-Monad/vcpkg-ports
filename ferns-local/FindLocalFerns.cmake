
if(CMAKE_BUILD_TYPE MATCHES "^[Dd][Ee][Bb][Uu][Gg]$" OR NOT DEFINED CMAKE_BUILD_TYPE)
    set(VCPKG_TARGET_TRIPLET_CONF "debug")
else()
    set(VCPKG_TARGET_TRIPLET_CONF "release")
endif()
set(TRI ${VCPKG_TARGET_TRIPLET}-${VCPKG_TARGET_TRIPLET_CONF})

set(Ferns_DIR $ENV{P_project_output}/ferns/${TRI}/share/ferns)
_find_package(Ferns CONFIG REQUIRED)

if(Ferns_FOUND AND NOT TARGET Ferns::Ferns)
    add_library(Ferns::Ferns INTERFACE IMPORTED CONFIGURATIONS ${CMAKE_BUILD_TYPE})
    target_link_libraries(Ferns::Ferns INTERFACE ${Ferns_LIBS} CONFIGURATIONS ${CMAKE_BUILD_TYPE})
endif()
