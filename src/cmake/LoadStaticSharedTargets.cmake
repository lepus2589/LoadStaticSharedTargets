#[[
MIT License

Copyright (c) 2022 Tim Haase

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

#[[
The idea for this code was taken from
https://alexreinking.com/blog/building-a-dual-shared-and-static-library-with-cmake.html
and the associated repository
https://github.com/alexreinking/SharedStaticStarter
]]

#[[
This macro is intended to be used in a package configuration file and adds two
virtual components that can be given to the `find_package()` command: static
and shared. The two are mutually exclusive and if none is specified, the
variables ${CMAKE_FIND_PACKAGE_NAME}_SHARED_LIBS and BUILD_SHARED_LIBS are
being used to determine a sane default. It then delegates to the respective
EXPORT scripts.

Usage:

load_static_shared_targets(
    STATIC_TARGETS
    <static target exported package file>
    ...
    SHARED_TARGETS
    <shared target exported package file>
    ...
)
]]

macro(load_static_shared_targets)
    set(${CMAKE_FIND_PACKAGE_NAME}_known_comps static shared)
    set(${CMAKE_FIND_PACKAGE_NAME}_comp_static NO)
    set(${CMAKE_FIND_PACKAGE_NAME}_comp_shared NO)

    # Iterate the list of requested components given to `find_package()`
    foreach (${CMAKE_FIND_PACKAGE_NAME}_comp IN LISTS ${CMAKE_FIND_PACKAGE_NAME}_FIND_COMPONENTS)
        # If it's a valid component, turn on the respective switch.
        if (${CMAKE_FIND_PACKAGE_NAME}_comp IN_LIST ${CMAKE_FIND_PACKAGE_NAME}_known_comps)
            set(${CMAKE_FIND_PACKAGE_NAME}_comp_${${CMAKE_FIND_PACKAGE_NAME}_comp} YES)
        # Else do error handling.
        else ()
            set(${CMAKE_FIND_PACKAGE_NAME}_NOT_FOUND_MESSAGE
                "${CMAKE_FIND_PACKAGE_NAME} does not recognize component `${${CMAKE_FIND_PACKAGE_NAME}_comp}`.")
            set(${CMAKE_FIND_PACKAGE_NAME}_FOUND FALSE)
            return()
        endif ()
    endforeach ()

    # Components static and shared are mutually exclusive.
    if (${CMAKE_FIND_PACKAGE_NAME}_comp_static AND ${CMAKE_FIND_PACKAGE_NAME}_comp_shared)
        set(${CMAKE_FIND_PACKAGE_NAME}_NOT_FOUND_MESSAGE
            "${CMAKE_FIND_PACKAGE_NAME} `static` and `shared` components are mutually exclusive.")
        set(${CMAKE_FIND_PACKAGE_NAME}_FOUND FALSE)
        return()
    endif ()

    # Parse static and shared targets from argument list.
    _static_shared_parse_args(${ARGN})

    # Static component requested
    if (${CMAKE_FIND_PACKAGE_NAME}_comp_static)
        _static_shared_load_targets(static)
    # Shared component requested
    elseif (${CMAKE_FIND_PACKAGE_NAME}_comp_shared)
        _static_shared_load_targets(shared)
    # ${CMAKE_FIND_PACKAGE_NAME}_SHARED_LIBS cache variable set to ON
    elseif (DEFINED ${CMAKE_FIND_PACKAGE_NAME}_SHARED_LIBS AND ${CMAKE_FIND_PACKAGE_NAME}_SHARED_LIBS)
        _static_shared_load_targets(shared)
    # ${CMAKE_FIND_PACKAGE_NAME}_SHARED_LIBS cache variable set to OFF
    elseif (DEFINED ${CMAKE_FIND_PACKAGE_NAME}_SHARED_LIBS AND NOT ${CMAKE_FIND_PACKAGE_NAME}_SHARED_LIBS)
        _static_shared_load_targets(static)
    # BUILD_SHARED_LIBS variable set to ON
    elseif (BUILD_SHARED_LIBS)
        # If shared target is installed, include it.
        if (EXISTS "${${CMAKE_FIND_PACKAGE_NAME}_shared_targets}")
            _static_shared_load_targets(shared)
        # Otherwise at least load the static target
        else ()
            _static_shared_load_targets(static)
        endif ()
    # BUILD_SHARED_LIBS variable set to OFF
    else ()
        # If static target is installed, include it.
        if (EXISTS "${${CMAKE_FIND_PACKAGE_NAME}_static_targets}")
            _static_shared_load_targets(static)
        # Otherwise at least load the shared target
        else ()
            _static_shared_load_targets(shared)
        endif ()
    endif ()
endmacro()

# Macro to check, if the requested file with the exported targets is installed.
# Do error handling if not, include it otherwise.
macro(_static_shared_load_targets type)
    foreach (${CMAKE_FIND_PACKAGE_NAME}_target ${${CMAKE_FIND_PACKAGE_NAME}_${type}_targets})
        if (NOT EXISTS "${${CMAKE_FIND_PACKAGE_NAME}_target}")
            set(${CMAKE_FIND_PACKAGE_NAME}_NOT_FOUND_MESSAGE
                "${CMAKE_FIND_PACKAGE_NAME} `${type}` libraries were requested but not found.")
            set(${CMAKE_FIND_PACKAGE_NAME}_FOUND FALSE)
            return()
        endif ()
        include("${${CMAKE_FIND_PACKAGE_NAME}_target}")
    endforeach ()
endmacro()

# Parse the list of static targets and the list of shared targets from the macro
# arguments.
macro(_static_shared_parse_args)
    set(_STATIC_SHARED_EXTRA_MACRO_ARGS ${ARGN})
    list(FIND _STATIC_SHARED_EXTRA_MACRO_ARGS STATIC_TARGETS _STATIC_SHARED_STATIC_OPTION_INDEX)
    list(FIND _STATIC_SHARED_EXTRA_MACRO_ARGS SHARED_TARGETS _STATIC_SHARED_SHARED_OPTION_INDEX)

    if (NOT _STATIC_SHARED_STATIC_OPTION_INDEX EQUAL -1 AND NOT _STATIC_SHARED_SHARED_OPTION_INDEX EQUAL -1)
        math(EXPR _STATIC_SHARED_STATIC_START_INDEX "${_STATIC_SHARED_STATIC_OPTION_INDEX} + 1")
        math(EXPR _STATIC_SHARED_SHARED_START_INDEX "${_STATIC_SHARED_SHARED_OPTION_INDEX} + 1")

        if (_STATIC_SHARED_STATIC_OPTION_INDEX LESS _STATIC_SHARED_SHARED_OPTION_INDEX)
            math(EXPR _STATIC_SHARED_STATIC_LENGTH "${_STATIC_SHARED_SHARED_OPTION_INDEX} - ${_STATIC_SHARED_STATIC_START_INDEX}")
            set(_STATIC_SHARED_SHARED_LENGTH -1)
        else ()
            set(_STATIC_SHARED_STATIC_LENGTH -1)
            math(EXPR _STATIC_SHARED_SHARED_LENGTH "${_STATIC_SHARED_STATIC_OPTION_INDEX} - ${_STATIC_SHARED_SHARED_START_INDEX}")
        endif ()

        list(
            SUBLIST
            _STATIC_SHARED_EXTRA_MACRO_ARGS
            ${_STATIC_SHARED_SHARED_START_INDEX}
            ${_STATIC_SHARED_SHARED_LENGTH}
            ${CMAKE_FIND_PACKAGE_NAME}_shared_targets
        )

        list(
            SUBLIST
            _STATIC_SHARED_EXTRA_MACRO_ARGS
            ${_STATIC_SHARED_STATIC_START_INDEX}
            ${_STATIC_SHARED_STATIC_LENGTH}
            ${CMAKE_FIND_PACKAGE_NAME}_static_targets
        )
    # Else do error handling.
    else ()
        message(FATAL_ERROR "load_static_shared_targets() has been called with invalid arguments!")
    endif ()
endmacro()
