
file(
    COPY ${CMAKE_CURRENT_LIST_DIR}/FindLocalIrrlicht.cmake 
    DESTINATION ${CURRENT_PACKAGES_DIR}/share/)

file(
    COPY ${CMAKE_CURRENT_LIST_DIR}/irrlicht19.h
    DESTINATION ${CURRENT_PACKAGES_DIR}/include
)

file(
    INSTALL ${CMAKE_CURRENT_LIST_DIR}/License.txt
    DESTINATION ${CURRENT_PACKAGES_DIR}/share/${PORT}
    RENAME copyright
)
