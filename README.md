# LoadStaticSharedTargets.cmake #

This project contains a CMake macro for loading static or shared exported
library targets in a CMake package config file. Static or shared targets can be
explicitly (via `COMPONENTS`) or implicitly (via `BUILD_SHARED_LIBS`) imported
with the `find_package()` command.

## Usage ##

In your cmake project, do the following:

```cmake
include(FetchContent)

FetchContent_Declare(
    LoadStaticSharedTargets
    GIT_REPOSITORY "https://github.com/lepus2589/LoadStaticSharedTargets.git"
    GIT_TAG v1.1
)
FetchContent_MakeAvailable(LoadStaticSharedTargets)
FetchContent_GetProperties(
  LoadStaticSharedTargets
  SOURCE_DIR LoadStaticSharedTargets_SOURCE_DIR
  POPULATED LoadStaticSharedTargets_POPULATED
)

install(
    FILES
    "${LoadStaticSharedTargets_SOURCE_DIR}/src/cmake/LoadStaticSharedTargets.cmake"
    DESTINATION "${YourProject_INSTALL_CMAKEDIR}"
)
```

In your projects package config CMake file, you can now use the macro like this:

```cmake
include("${CMAKE_CURRENT_LIST_DIR}/LoadStaticSharedTargets.cmake")

load_static_shared_targets(
    STATIC_TARGETS
    "${CMAKE_CURRENT_LIST_DIR}/YourProject_Targets-static.cmake"
    SHARED_TARGETS
    "${CMAKE_CURRENT_LIST_DIR}/YourProject_Targets-shared.cmake"
)
```

## Further Reading ##

The idea for this code was taken from
[@alexreinking](https://github.com/alexreinking)'s blog post:
[Building a Dual Shared and Static Library with CMake](https://alexreinking.com/blog/building-a-dual-shared-and-static-library-with-cmake.html)
and the associated
[example repository](https://github.com/alexreinking/SharedStaticStarter).

Information on project structure and usage of CMake library packages using this
approach in other projects can be found there.
