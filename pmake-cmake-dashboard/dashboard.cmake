
# ----------------------------------------------------------------------------

function(pmake_dashboard)
  set(__args VERSION_FILE VERSION_ID)
  cmake_parse_arguments("PMAKE" "" "${__args}" "" ${ARGN})
  set(PMAKE_SOURCE_ROOT ${CMAKE_CURRENT_LIST_DIR})
  include(${CMAKE_CURRENT_FUNCTION_LIST_DIR}/summary/dashboard.cmake)
endfunction()

# ----------------------------------------------------------------------------
