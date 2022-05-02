
set(VCPKG_POLICY_EMPTY_PACKAGE enabled)

file(
    INSTALL
    ${CMAKE_CURRENT_LIST_DIR}/summary
    ${CMAKE_CURRENT_LIST_DIR}/dashboard.cmake
    ${CMAKE_CURRENT_LIST_DIR}/pmake-cmake-dashboard-config.cmake
    DESTINATION ${CURRENT_PACKAGES_DIR}/share/${PORT}
)

file(
    INSTALL ${CMAKE_CURRENT_LIST_DIR}/copyright
    DESTINATION ${CURRENT_PACKAGES_DIR}/share/${PORT}
)
