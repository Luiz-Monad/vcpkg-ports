
set(_TGT OpenCV)
set(_LTGT opencv)
set(_PRJ_DIR opencv)
configure_file(
    ${CMAKE_CURRENT_LIST_DIR}/FindLocalLibrary.cmake.in
    ${CURRENT_PACKAGES_DIR}/share/FindLocalOpenCV.cmake @ONLY
)

file(
    COPY ${CMAKE_CURRENT_LIST_DIR}/local_opencv_4_5_1.h
    DESTINATION ${CURRENT_PACKAGES_DIR}/include
)

file(
    INSTALL ${CMAKE_CURRENT_LIST_DIR}/License.txt
    DESTINATION ${CURRENT_PACKAGES_DIR}/share/${PORT}
    RENAME copyright
)
