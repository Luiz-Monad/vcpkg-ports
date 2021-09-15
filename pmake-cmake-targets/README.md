# pmake-cmake-targets

`pmake-cmake-targets` provides helpers to simplify targets declaration on CMake.

Merge release and debug CMake targets and configs to support multiconfig generators.

Principle of operation:

* Create one or more files on `cmake/` named, for example, `find_lib.cmake`.
* Define there the calls for `find_package`.
* On the begin of the file you make a call to `pmake_target_create`.
* Use `pmake_target_link_libraries` instead to connect the dependencies.
* On the final target of the project, use `pmake_target_install`.


The function `pmake_target_create` will define a `library` `interface` virtual target, and
automatically export the install targets and install them.


When the final target of the project is exported by `pmake_target_install`, 
the usual `<project>Config.cmake` will be generated from the template.


The generated template will be installed together with a copy of `find_lib.cmake` so
that the consumers of this project library finds our dependencies and provide the targets we need.


# pmake_target_create

## Virtual Target Creation.

Creates and export and install a virtual target.


```cmake
pmake_target_create(
    <target>
    NS <namespace>
)
```

* __target__ is a CMake Target.
* __namespace__ is the namespace to export the CMake Target.


# pmake_target_link_libraries

## Define Target dependencies.

It works exactly link `target_link_libraries`, but its used to bail out
if the `target` was already linked to the library, its necessary because
inside `<project>Config.cmake` the target may already be defined by the `IMPORTED` target definition.


```cmake
pmake_target_link_libraries(
    <target>
    [ARGN]
)
```
* __target__ is a CMake Target.
* __ARGN__ all the other arguments are passed as is.


# pmake_target_option

## Export Target options.

While `find_lib.cmake` is called `<project>Config.cmake` from inside CMake `find_package` function, we
don't have access to the original project variables (except those from the build system).
So they need to be exported to be used by `find_lib.cmake`, and this functions does exactly that, 
it exports the variables into `<project>Config.cmake` when its generated.

```cmake
pmake_target_option(
    <target>
    <option>
)
```
* __target__ is a CMake Target.
* __option__ name of the option boolean var to be set.


# pmake_target_install

## Final Target Export and Install.


```cmake
pmake_target_install(
    <target>
    PUB_INC <name>
    LIB <libs>
)
```
* __target__ is a CMake Target.
* __PUB_INC__ the list of headers to be installed.
* __LIB__ the list of virtual targets (created by `pmake_target_create`) to be exported and installed.

