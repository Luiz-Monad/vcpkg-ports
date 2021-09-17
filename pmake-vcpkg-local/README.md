# pmake-vcpkg-local

`pmake-vcpkg-local` provides a helper generate a local port symlink library.

Merge back the release and debug CMake targets and configs to support multiconfig generators, 
and provide the targets for the `find_package` CMake function to work.

Principle of operation:

* Generate a `FindLocal<project>.cmake` and installs it in the default path for `vcpkg` packages.
* The generated CMake script will find the local library in `pmake` directory structure format.
* A directory named `local_<project>` will be created in the CurrentBinaryDir of the target project.
* Symlinks for files in the *bin*, *lib*, *share* directories will be created.
* Symlink for the endire *include* directory will be created.
* Then the actual `find_package` will be called on the `local<project>` directory.
* The following variables will be provided `<project>_DIR`, `<project>_FOUND`, `<project>_VERSION`.


The generated template works normally like a `find_package` call for a `vcpkg` packaged library, 
this is just a proxy, and the actual `<project>Config.cmake` will work just like if `vcpkg` actually
installed the library.

The only caveat is that it used my opnionated output directory structure defined in `pmake`. This
is just `<P_project_output>/<project_dir>/<triplet>`.

* __P_project_output__ is just an environment variable with the full dir name to find the outputs.
* __project_dir__ is the directory for the project inside `project_output` directory.
* __triplet__ is the `vcpkg` triplet.


# pmake_generate_local_finder

## FindPackage Proxy Generator

Generates a CMake script that creates a symlinked proxy to a local CMake project output.


```cmake
pmake_generate_local_finder(
    NAME <name>
    BASE_DIR <base_dir>
)
```

* __name__ is the name of the target project `<project>`, will be the name of the `port`.
* __base_dir__ is the same as __project_dir__.
