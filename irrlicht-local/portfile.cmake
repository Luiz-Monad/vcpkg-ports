
set(_TGT Irrlicht)
set(_LTGT irrlicht)
set(_PRJ_DIR irrlicht-ogl-es)
configure_file(
    ${CMAKE_CURRENT_LIST_DIR}/FindLocalLibrary.cmake.in
    ${CURRENT_PACKAGES_DIR}/share/FindLocalIrrlicht.cmake @ONLY
)

file(
    COPY ${CMAKE_CURRENT_LIST_DIR}/local_irrlicht_1_9.h
    DESTINATION ${CURRENT_PACKAGES_DIR}/include
)

file(
    INSTALL ${CMAKE_CURRENT_LIST_DIR}/License.txt
    DESTINATION ${CURRENT_PACKAGES_DIR}/share/${PORT}
    RENAME copyright
)
