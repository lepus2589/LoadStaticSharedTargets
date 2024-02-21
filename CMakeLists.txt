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

cmake_minimum_required(VERSION 3.25)

set(CMAKE_MAXIMUM_SUPPORTED_VERSION 3.28)

# If CMAKE_VERSION <= CMAKE_MAXIMUM_SUPPORTED_VERSION is used, set policies up
# to CMAKE_VERSION to NEW
if (${CMAKE_VERSION} VERSION_LESS_EQUAL ${CMAKE_MAXIMUM_SUPPORTED_VERSION})
    cmake_policy(VERSION ${CMAKE_VERSION})
# If CMAKE_VERSION > CMAKE_MAXIMUM_SUPPORTED_VERSION is used, set policies up to
# CMAKE_MAXIMUM_SUPPORTED_VERSION to NEW
else ()
    cmake_policy(VERSION ${CMAKE_MAXIMUM_SUPPORTED_VERSION})
endif()

project(LoadStaticSharedTargets VERSION 1.5.0 LANGUAGES NONE)

include(GNUInstallDirs)

string(COMPARE EQUAL "${CMAKE_PROJECT_NAME}" "${PROJECT_NAME}" IS_TOP_LEVEL)

if (IS_TOP_LEVEL)
    include(CTest)

    if (NOT DEFINED CMAKE_CTEST_ARGUMENTS)
        set(CMAKE_CTEST_ARGUMENTS "--verbose")
    endif ()
endif ()

add_subdirectory(src)

if (IS_TOP_LEVEL AND BUILD_TESTING)
    add_custom_target(check COMMAND ${CMAKE_CTEST_COMMAND} -V)

    add_subdirectory(tests EXCLUDE_FROM_ALL)
endif ()

option(LoadStaticSharedTargets_INCLUDE_PACKAGING "Include packaging rules for LoadStaticSharedTargets" "${IS_TOP_LEVEL}")

if (LoadStaticSharedTargets_INCLUDE_PACKAGING)
    add_subdirectory(packaging)
endif ()
