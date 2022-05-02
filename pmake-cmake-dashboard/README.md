# pmake-cmake-dashboard

`pmake-cmake-dashboard` provides a build dashboard to check if options are correct.

Principle of operation:

* Create an optional file `cmake/dashboard.cmake` with extra status.
* Call the `status` function.


# pmake_dashboard

## Displays a dashboard.

Displays a dashboard with some gathered info about the build, also save the CMakeVars for debugging.

```cmake
pmake_dashboard(
    VERSION_FILE <version_file>
)
```
* __version_file__ The name of the header version file to display in the dashboard.
