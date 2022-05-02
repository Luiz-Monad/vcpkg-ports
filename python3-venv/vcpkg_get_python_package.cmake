#[===[.md:
# vcpkg_get_python_package

Create a venv in the buildtree, then install packages using pip and return the python executable.

```cmake
vcpkg_get_python_package(<VAR> PACKAGES <packages>)
```
## Parameters
### VAR
This variable specifies both the program to be acquired as well as the out parameter that will be set to the path of the program executable.

### PACKAGES
Packages to be installed by pip.

#]===]
if(Z_VCPKG_GET_PYTHON_PACKAGE_GUARD)
    return()
endif()
set(Z_VCPKG_GET_PYTHON_PACKAGE_GUARD ON CACHE INTERNAL "guard variable")

function(vcpkg_get_python_package VAR)
    cmake_parse_arguments(PARSE_ARGV 0 _vgpp "" "" "PACKAGES")
   
    if(NOT _vgpp_PACKAGES)
        message(FATAL_ERROR "${CMAKE_CURRENT_FUNCTION} requires parameter PACKAGES!")
    endif()

    # setup venv if it doesn't exist
    if (NOT EXISTS "${CMAKE_BINARY_DIR}/venv")
        find_package(Python3)
        vcpkg_execute_required_process(COMMAND ${Python3_EXECUTABLE} -m venv venv
            WORKING_DIRECTORY ${CURRENT_BUILDTREES_DIR}
            LOGNAME prerequesits-venv-${TARGET_TRIPLET})
        unset(${Python3_EXECUTABLE})
    endif()

    # activate python venv
    set(ENV{VIRTUAL_ENV} "${CMAKE_BINARY_DIR}/venv")
    find_package(Python3)
    #vcpkg_find_acquire_program(PYTHON3)
    get_filename_component(PYTHON3_DIR "${Python3_EXECUTABLE}" DIRECTORY)
    vcpkg_add_to_path("${PYTHON3_DIR}")
    vcpkg_add_to_path("${PYTHON3_DIR}/Scripts")
    set(ENV{PYTHON} "${Python3_EXECUTABLE}")

    # install packages
    vcpkg_execute_required_process(COMMAND ${Python3_EXECUTABLE} -m pip install ${_vgpp_PACKAGES}
        WORKING_DIRECTORY ${CURRENT_BUILDTREES_DIR}
        LOGNAME prerequesits-python3-pip-${TARGET_TRIPLET})

    set(${VAR} "${Python3_EXECUTABLE}" PARENT_SCOPE)
endfunction()
