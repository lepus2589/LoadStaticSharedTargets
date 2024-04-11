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

TEST_CASE("Include one static target by package specific flag, but it doesn't exist: ")

set(${CMAKE_FIND_PACKAGE_NAME}_SHARED_LIBS FALSE)

set(
    STATIC_TEST_TARGET_FILES
    "./mocks/i-do-not-exist"
)
set(
    SHARED_TEST_TARGET_FILES
    "./mocks/failure-target1.cmake"
)

include("./helpers/testee_macro_wrapper.cmake")

CHECK_STREQUAL(
    ${CMAKE_FIND_PACKAGE_NAME}_NOT_FOUND_MESSAGE
    "${CMAKE_FIND_PACKAGE_NAME} `STATIC` libraries were requested but not found."
)
REQUIRE_FALSY(${CMAKE_FIND_PACKAGE_NAME}_FOUND)
REQUIRE_TARGET_UNDEFINED(FAILURE_TARGET_1)
