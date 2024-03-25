# LoadStaticSharedTargets #

This CMake module contains a macro for loading static or shared exported library
targets in a CMake package config file. Static or shared targets can be
explicitly (via `COMPONENTS`) or implicitly (via `BUILD_SHARED_LIBS`) imported
with the `find_package()` command.

## Prerequisites ##

What you need:

- [Git](https://git-scm.com/) (optional) for getting the code and contributing
  to the project
- [CMake](https://cmake.org/) and [Ninja](https://ninja-build.org/) for building
  the project

### Linux (Ubuntu) ###

Use your distribution's package manager to install the necessary packages:

```shell
$ sudo apt-get install cmake ninja-build
```

### Mac OS X ###

You will need one of the community package managers for Mac OS X:
[Homebrew](https://brew.sh/) or
[MacPorts](https://www.macports.org/install.php). For installing one of these,
please refer to their respective installation instructions.

#### Homebrew ####

```shell
$ brew install cmake ninja
```

#### MacPorts ####

```shell
$ sudo port -vb install cmake-devel ninja
```

### Windows ###

The easiest thing to do is using the [Windows Subsystem for Linux
(WSL)](https://learn.microsoft.com/en-us/windows/wsl/install) and follow the
Linux instructions above.

Otherwise, install [Git for Windows](https://gitforwindows.org/) for version
control and [cygwin](https://cygwin.com/install.html), which is a large
collection of GNU and Open Source tools which provide functionality similar to a
Linux distribution on Windows. During the `cygwin` installation you'll be
prompted to add additional packages. Search and select the following:

- `cmake` and `ninja` for the build system

After `cygwin` finishes installing, use the cygwin terminal to start the build
process.

## How to build ##

1. Clone the git repository or download the source code archive and unpack it to
   an arbitrary directory (e.g. `load-static-shared-targets`).
2. Go to this directory and type `cmake --list-presets`. A list of available
   build configurations will be shown to you.
3. For configuring the project, type `cmake --preset ninja`. This will populate
   the `./build` directory with a CMake configuration tree. By default, the
   configured installation directory is `./install`. You can specify a different
   install location by setting the `CMAKE_INSTALL_PREFIX` variable:

   ```shell
   $ cmake --preset ninja -D "CMAKE_INSTALL_PREFIX=/path/to/install/prefix"
   ```

4. Now, you can build with `cmake --build --preset ninja`. You should see some
   informative terminal output.
5. Finally, install the built artifacts to the configured install prefix with
   `cmake --build --preset ninja --target install`. If the configured install
   prefix is a system-wide location (like `/usr/local`), installing might
   require `sudo`.

Now, the `LoadStaticSharedTargets` module is installed and you can use it in
other projects. The installed `LoadStaticSharedTargets` package is discoverable
by CMake as __LoadStaticSharedTargets__. In the `CMakeLists.txt` of the other
project, do the following:

```cmake
include(FetchContent)

FetchContent_Declare(
    LoadStaticSharedTargets
    GIT_REPOSITORY "https://github.com/lepus2589/LoadStaticSharedTargets.git"
    GIT_TAG v1.5.2
    SYSTEM
    FIND_PACKAGE_ARGS 1.5.2 CONFIG NAMES LoadStaticSharedTargets
)
set(LoadStaticSharedTargets_INCLUDE_PACKAGING TRUE)
FetchContent_MakeAvailable(LoadStaticSharedTargets)
```

This discovers an installed version of the LoadStaticSharedTargets module or
adds it to the other project's install targets. To help CMake discover an
installed LoadStaticSharedTargets package, call CMake for the other project like
this:

```shell
$ cmake -B ./build -D "CMAKE_PREFIX_PATH=/path/to/LoadStaticSharedTargets/install/prefix"
```

Replace the path to the LoadStaticSharedTargets install prefix with the actual
path on your system! If LoadStaticSharedTargets is installed in a proper
system-wide location, the `CMAKE_PREFIX_PATH` shouldn't be necessary.

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

## Further Reading ##

The idea for this code was taken from
[@alexreinking](https://github.com/alexreinking)'s blog post:
[Building a Dual Shared and Static Library with CMake](https://alexreinking.com/blog/building-a-dual-shared-and-static-library-with-cmake.html)
and the associated
[example repository](https://github.com/alexreinking/SharedStaticStarter).

Information on project structure and usage of CMake library packages using this
approach in other projects can be found there.
