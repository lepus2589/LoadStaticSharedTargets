#[[
MIT License

CMake build script for LoadStaticSharedTargets module
Copyright (c) 2024 Tim Kaune

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
]]

include(CMakePackageConfigHelpers)

if (NOT DEFINED LoadStaticSharedTargets_INSTALL_CMAKEDIR)
    set(
        LoadStaticSharedTargets_INSTALL_CMAKEDIR
        "${CMAKE_INSTALL_DATAROOTDIR}/cmake/${PROJECT_NAME}"
        CACHE
        STRING
        "Path to LoadStaticSharedTargets CMake files"
    )
endif ()

install(
    FILES
    "../LICENSE"
    RENAME copyright
    DESTINATION "${CMAKE_INSTALL_DOCDIR}"
)

write_basic_package_version_file(
    LoadStaticSharedTargetsConfigVersion.cmake
    COMPATIBILITY SameMajorVersion
)

configure_file(
    "LoadStaticSharedTargetsConfig.cmake.in"
    "${CMAKE_CURRENT_BINARY_DIR}/LoadStaticSharedTargetsConfig.cmake"
    @ONLY
)

install(
    FILES
    "${CMAKE_CURRENT_BINARY_DIR}/LoadStaticSharedTargetsConfigVersion.cmake"
    "${CMAKE_CURRENT_BINARY_DIR}/LoadStaticSharedTargetsConfig.cmake"
    "../src/cmake/LoadStaticSharedTargets.cmake"
    DESTINATION "${LoadStaticSharedTargets_INSTALL_CMAKEDIR}"
)
