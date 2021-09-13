
file(
    COPY ${CMAKE_CURRENT_LIST_DIR}/FindLocalFerns.cmake 
    DESTINATION ${CURRENT_PACKAGES_DIR}/share
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
