
# ----------------------------------------------------------------------------

function(pmake_generate_local_finder)
  set(__args NAME BASE_DIR)
  cmake_parse_arguments("_arg" "" "" "${__args}" ${ARGN})

  string(TOLOWER ${_arg_NAME} _arg_LNAME)

  set(_TGT ${_arg_NAME})
  set(_LTGT ${_arg_LNAME})
  set(_PRJ_DIR ${_arg_BASE_DIR})

  configure_file(
      ${CMAKE_CURRENT_FUNCTION_LIST_DIR}/templates/FindLocalLibrary.cmake.in
      ${CURRENT_PACKAGES_DIR}/share/FindLocal${_TGT}.cmake @ONLY
  )

  configure_file(
      ${CMAKE_CURRENT_FUNCTION_LIST_DIR}/templates/local.h.in
      ${CURRENT_PACKAGES_DIR}/include/local_${_TGT}.h @ONLY
  )

  file(
      INSTALL ${CMAKE_CURRENT_FUNCTION_LIST_DIR}/copyright
      DESTINATION ${CURRENT_PACKAGES_DIR}/share/${PORT}
  )


endfunction()

# ----------------------------------------------------------------------------
