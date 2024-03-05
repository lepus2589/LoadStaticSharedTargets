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

include("./cmake/HandlePolicies.cmake" NO_POLICY_SCOPE)

project(LoadStaticSharedTargets VERSION 1.5.1 LANGUAGES NONE)

include(GNUInstallDirs)

string(COMPARE EQUAL "${CMAKE_PROJECT_NAME}" "${PROJECT_NAME}" IS_TOP_LEVEL)

if (IS_TOP_LEVEL)
    include(CTest)

    if (NOT DEFINED CMAKE_CTEST_ARGUMENTS)
        set(CMAKE_CTEST_ARGUMENTS "--verbose")
    endif ()
endif ()

option(LoadStaticSharedTargets_INCLUDE_PACKAGING "Include packaging rules for LoadStaticSharedTargets" "${IS_TOP_LEVEL}")

add_subdirectory(src)

if (IS_TOP_LEVEL AND BUILD_TESTING)
    add_custom_target(check COMMAND ${CMAKE_CTEST_COMMAND} -V)

    add_subdirectory(tests EXCLUDE_FROM_ALL)
endif ()

if (LoadStaticSharedTargets_INCLUDE_PACKAGING)
    add_subdirectory(packaging)
endif ()
