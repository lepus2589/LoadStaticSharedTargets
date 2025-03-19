#[[
MIT License

CMake build script for LoadStaticSharedTargets module
Copyright (c) 2025 Tim Kaune

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

set(
    TEST_CASES
    "common-failures_test-case-01"
    "common-failures_test-case-02"
    "include-requested-by-common-flag_test-case-01"
    "include-requested-by-common-flag_test-case-04"
    "include-requested-by-common-flag_test-case-07"
    "include-requested-by-common-flag_test-case-10"
    "include-requested-by-component_test-case-01"
    "include-requested-by-component_test-case-02"
    "include-requested-by-component_test-case-03"
    "include-requested-by-component_test-case-04"
    "include-requested-by-component_test-case-05"
    "include-requested-by-component_test-case-06"
    "include-requested-by-component_test-case-07"
    "include-requested-by-component_test-case-08"
    "include-requested-by-package-flag_test-case-01"
    "include-requested-by-package-flag_test-case-02"
    "include-requested-by-package-flag_test-case-03"
    "include-requested-by-package-flag_test-case-04"
    "include-requested-by-package-flag_test-case-05"
    "include-requested-by-package-flag_test-case-06"
    "include-requested-by-package-flag_test-case-07"
    "include-requested-by-package-flag_test-case-08"
)

set(
    TEST_CASES_WITH_WARNING
    "include-requested-by-common-flag_test-case-02"
    "include-requested-by-common-flag_test-case-03"
    "include-requested-by-common-flag_test-case-05"
    "include-requested-by-common-flag_test-case-06"
    "include-requested-by-common-flag_test-case-08"
    "include-requested-by-common-flag_test-case-09"
    "include-requested-by-common-flag_test-case-11"
    "include-requested-by-common-flag_test-case-12"
)

foreach (TEST_CASE IN LISTS TEST_CASES TEST_CASES_WITH_WARNING)
    add_test(
        NAME "${TEST_CASE}"
        COMMAND
        "${CMAKE_COMMAND}"
        -D CMAKE_MINIMUM_REQUIRED_VERSION=${CMAKE_MINIMUM_REQUIRED_VERSION}
        -D CMAKE_MAXIMUM_SUPPORTED_VERSION=${CMAKE_MAXIMUM_SUPPORTED_VERSION}
        -D "TEST_CASE=${TEST_CASE}"
        -P "./helpers/test_case_wrapper.cmake"
        WORKING_DIRECTORY "${CMAKE_CURRENT_SOURCE_DIR}"
    )
endforeach ()

foreach (TEST_CASE IN LISTS TEST_CASES_WITH_WARNING)
    add_test(
        NAME "${TEST_CASE}_check-warning"
        COMMAND
        "${CMAKE_COMMAND}"
        -D CMAKE_MINIMUM_REQUIRED_VERSION=${CMAKE_MINIMUM_REQUIRED_VERSION}
        -D CMAKE_MAXIMUM_SUPPORTED_VERSION=${CMAKE_MAXIMUM_SUPPORTED_VERSION}
        -D "TEST_CASE=${TEST_CASE}"
        -P "./helpers/test_case_wrapper.cmake"
        WORKING_DIRECTORY "${CMAKE_CURRENT_SOURCE_DIR}"
    )

    set_tests_properties(
        "${TEST_CASE}_check-warning"
        PROPERTIES
        PASS_REGULAR_EXPRESSION
        "Requested `.+` targets for package .+ were not found\\.;Trying alternative `.+` targets\\."
    )
endforeach ()
