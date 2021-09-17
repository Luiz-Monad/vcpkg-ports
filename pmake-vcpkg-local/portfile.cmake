if(NOT TARGET_TRIPLET STREQUAL _HOST_TRIPLET)
    message(WARNING "pmake-vcpkg-local is a host-only port; please mark it as a host port in your dependencies.")
endif()

set(VCPKG_POLICY_EMPTY_PACKAGE enabled)

file(
    INSTALL
    ${CMAKE_CURRENT_LIST_DIR}/templates
    ${CMAKE_CURRENT_LIST_DIR}/generator.cmake
    ${CMAKE_CURRENT_LIST_DIR}/vcpkg-port-config.cmake
    DESTINATION ${CURRENT_PACKAGES_DIR}/share/${PORT}
)

file(
    INSTALL ${CMAKE_CURRENT_LIST_DIR}/copyright
    DESTINATION ${CURRENT_PACKAGES_DIR}/share/${PORT}
)
