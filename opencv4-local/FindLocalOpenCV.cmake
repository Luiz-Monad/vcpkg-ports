set(_TGT OpenCV)
string(TOLOWER ${_TGT} __LTGT)
set(_PRJ_DIR ${__LTGT})

set(_MERGED ${CMAKE_CURRENT_BINARY_DIR}/local)

# Merge targets
foreach(VCPKG_TARGET_TRIPLET_CONF debug release)
  set(_tri ${VCPKG_TARGET_TRIPLET}-${VCPKG_TARGET_TRIPLET_CONF})
  set(_dir $ENV{P_project_output}/${_PRJ_DIR}/${_tri})

  # Symbolic link binaries and configs
  foreach(_subdir "bin" "lib" "sdk/native/staticlibs" "share/${__LTGT}")
    file(GLOB _files "${_dir}/${_subdir}/*")
    execute_process(
      COMMAND ${CMAKE_COMMAND} 
        -E make_directory "${_MERGED}/${_subdir}")
    foreach(_file IN LISTS _files)
      get_filename_component(_name "${_file}" NAME)
      execute_process(
        COMMAND ${CMAKE_COMMAND} 
          -E create_symlink ${_file} "${_MERGED}/${_subdir}/${_name}")
    endforeach()
  endforeach()

  # Symbolic link header directory
  if (VCPKG_TARGET_TRIPLET_CONF STREQUAL release)
    execute_process(
      COMMAND ${CMAKE_COMMAND} 
        -E create_symlink "${_dir}/include" "${_MERGED}/include")
  endif()
  
endforeach()

# CMake find it
set(${_TGT}_DIR ${_MERGED}/share/${__LTGT})
set(${_TGT}_MAP_IMPORTED_CONFIG "RELWITHDEBINFO=release;MINSIZEREL=release")
_find_package(${_TGT} CONFIG REQUIRED)

# Create our virtual target
if(${_TGT}_FOUND AND NOT TARGET ${_TGT}::${_TGT})
    add_library(${_TGT}::${_TGT} INTERFACE IMPORTED)
    target_link_libraries(${_TGT}::${_TGT} INTERFACE "${${_TGT}_LIBS}")
endif()
