
set(_TGT Ferns)
set(_LTGT ferns)
set(_PRJ_DIR ferns)
configure_file(
    ${CMAKE_CURRENT_LIST_DIR}/FindLocalLibrary.cmake.in
    ${CURRENT_PACKAGES_DIR}/share/FindLocalFerns.cmake @ONLY
)

file(
    COPY ${CMAKE_CURRENT_LIST_DIR}/local_ferns_1.h
    DESTINATION ${CURRENT_PACKAGES_DIR}/include
)

file(
    INSTALL ${CMAKE_CURRENT_LIST_DIR}/license.txt
    DESTINATION ${CURRENT_PACKAGES_DIR}/share/${PORT}
    RENAME copyright
)
