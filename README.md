# LoadStaticSharedTargets #

This CMake module contains a macro for loading static or shared exported library
targets in a CMake package config file. Static or shared targets can be
explicitly (via `COMPONENTS`) or implicitly (via `BUILD_SHARED_LIBS`) imported
with the `find_package()` command.

## Prerequisites ##

What you need:

- [Git](https://git-scm.com/) (optional) for getting the code and contributing
  to the project
- [CMake](https://cmake.org/) for building the project

## How to build ##

1. Clone the git repository or download the source code archive and unpack it to
   an arbitrary directory (e.g. `load-static-shared-targets`).
2. For building the module, type `cmake --preset default`. This will populate the
   `build` directory with a CMake build tree.
3. Now, you can build with `cmake --build ./build`. You should see some
   informative terminal output.
4. Finally, install the built artifacts to the `bin` folder with `cmake
   --install ./build --prefix ./bin`. You can also specify a different install
   prefix, e. g. if you want to install system-wide: `cmake --install ./build
   --prefix /usr/local` (might require `sudo`).

Now, the `LoadStaticSharedTargets` module is installed and you can use it in
other projects. The installed `LoadStaticSharedTargets` package is discoverable
by CMake as __LoadStaticSharedTargets__. In the `CMakeLists.txt` of the other
project, do the following:

```cmake
include(FetchContent)

FetchContent_Declare(
    LoadStaticSharedTargets
    GIT_REPOSITORY "https://github.com/lepus2589/LoadStaticSharedTargets.git"
    GIT_TAG v1.4
    FIND_PACKAGE_ARGS NAMES LoadStaticSharedTargets CONFIG
)
set(LoadStaticSharedTargets_INCLUDE_PACKAGING TRUE)
FetchContent_MakeAvailable(LoadStaticSharedTargets)
```

This discovers an installed version of the LoadStaticSharedTargets module or
adds it to the other project's install targets.

In the other project's package config CMake file, you can now use the module like this:

```cmake
find_package(LoadStaticSharedTargets REQUIRED CONFIG)
include(LoadStaticSharedTargets)

load_static_shared_targets(
    STATIC_TARGETS
    "${CMAKE_CURRENT_LIST_DIR}/YourProject_Targets-static.cmake"
    SHARED_TARGETS
    "${CMAKE_CURRENT_LIST_DIR}/YourProject_Targets-shared.cmake"
)
```

This adds the LoadStaticSharedTargets module to the `CMAKE_MODULE_PATH` variable
which enables the include by name only.

Then, to help CMake discover the LoadStaticSharedTargets package, call CMake for
the other project like this:

```shell
$ cmake -B ./build -DCMAKE_PREFIX_PATH=/path/to/LoadStaticSharedTargets/install/prefix
```

Replace the path to the LoadStaticSharedTargets install prefix with the actual
path on your system! If LoadStaticSharedTargets is installed in a proper
system-wide location, the `CMAKE_PREFIX_PATH` shouldn't be necessary.

## Further Reading ##

The idea for this code was taken from
[@alexreinking](https://github.com/alexreinking)'s blog post:
[Building a Dual Shared and Static Library with CMake](https://alexreinking.com/blog/building-a-dual-shared-and-static-library-with-cmake.html)
and the associated
[example repository](https://github.com/alexreinking/SharedStaticStarter).

Information on project structure and usage of CMake library packages using this
approach in other projects can be found there.
