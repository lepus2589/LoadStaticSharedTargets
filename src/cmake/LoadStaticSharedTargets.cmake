#[[
MIT License

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
    block (
        SCOPE_FOR VARIABLES
        PROPAGATE
        ${CMAKE_FIND_PACKAGE_NAME}_FOUND
        ${CMAKE_FIND_PACKAGE_NAME}_NOT_FOUND_MESSAGE
    )
        set(${CMAKE_FIND_PACKAGE_NAME}_KNOWN_COMPS static shared)
        set(${CMAKE_FIND_PACKAGE_NAME}_COMP_static NO)
        set(${CMAKE_FIND_PACKAGE_NAME}_COMP_shared NO)

        # Iterate the list of requested components given to `find_package()`
        foreach (${CMAKE_FIND_PACKAGE_NAME}_COMP IN LISTS ${CMAKE_FIND_PACKAGE_NAME}_FIND_COMPONENTS)
            # If it's a valid component, turn on the respective switch.
            if (${CMAKE_FIND_PACKAGE_NAME}_COMP IN_LIST ${CMAKE_FIND_PACKAGE_NAME}_KNOWN_COMPS)
                set(${CMAKE_FIND_PACKAGE_NAME}_COMP_${${CMAKE_FIND_PACKAGE_NAME}_COMP} YES)
            # Else do error handling.
            else ()
                set(${CMAKE_FIND_PACKAGE_NAME}_NOT_FOUND_MESSAGE
                    "${CMAKE_FIND_PACKAGE_NAME} does not recognize component `${${CMAKE_FIND_PACKAGE_NAME}_COMP}`.")
                set(${CMAKE_FIND_PACKAGE_NAME}_FOUND FALSE)
                return()
            endif ()
        endforeach ()

        # Components static and shared are mutually exclusive.
        if (${CMAKE_FIND_PACKAGE_NAME}_COMP_static AND ${CMAKE_FIND_PACKAGE_NAME}_COMP_shared)
            set(${CMAKE_FIND_PACKAGE_NAME}_NOT_FOUND_MESSAGE
                "${CMAKE_FIND_PACKAGE_NAME} `static` and `shared` components are mutually exclusive.")
            set(${CMAKE_FIND_PACKAGE_NAME}_FOUND FALSE)
            return()
        endif ()

        # Parse static and shared targets from argument list.
        set(${CMAKE_FIND_PACKAGE_NAME}_ARGUMENT_KEYWORDS STATIC_TARGETS SHARED_TARGETS)
        cmake_parse_arguments(${CMAKE_FIND_PACKAGE_NAME} "" "" "${${CMAKE_FIND_PACKAGE_NAME}_ARGUMENT_KEYWORDS}" ${ARGN})
        # We now have ${CMAKE_FIND_PACKAGE_NAME}_STATIC_TARGETS and
        # ${CMAKE_FIND_PACKAGE_NAME}_SHARED_TARGETS variables created for us.

        # Static component requested
        if (${CMAKE_FIND_PACKAGE_NAME}_COMP_static)
            _load_static_shared_targets_load_targets(STATIC)
        # Shared component requested
        elseif (${CMAKE_FIND_PACKAGE_NAME}_COMP_shared)
            _load_static_shared_targets_load_targets(SHARED)
        # ${CMAKE_FIND_PACKAGE_NAME}_SHARED_LIBS cache variable set to ON
        elseif (DEFINED ${CMAKE_FIND_PACKAGE_NAME}_SHARED_LIBS AND ${CMAKE_FIND_PACKAGE_NAME}_SHARED_LIBS)
            _load_static_shared_targets_load_targets(SHARED)
        # ${CMAKE_FIND_PACKAGE_NAME}_SHARED_LIBS cache variable set to OFF
        elseif (DEFINED ${CMAKE_FIND_PACKAGE_NAME}_SHARED_LIBS AND NOT ${CMAKE_FIND_PACKAGE_NAME}_SHARED_LIBS)
            _load_static_shared_targets_load_targets(STATIC)
        # BUILD_SHARED_LIBS variable set to ON
        elseif (BUILD_SHARED_LIBS)
            # If shared targets are installed, include them.
            # Otherwise at least load the static targets
            _load_static_shared_targets_load_targets(SHARED ALTERNATIVE STATIC)
        # BUILD_SHARED_LIBS variable set to OFF
        else ()
            # If static targets are installed, include them.
            # Otherwise at least load the shared targets
            _load_static_shared_targets_load_targets(STATIC ALTERNATIVE SHARED)
        endif ()
    endblock ()
endmacro()

# Macro to check, if the target files for the requested type are all installed.
# If so, include them. Otherwise, try alternative type, if given. Do error
# handling, if not.
macro(_load_static_shared_targets_load_targets TYPE)
    block (
        SCOPE_FOR VARIABLES
        PROPAGATE
        ${CMAKE_FIND_PACKAGE_NAME}_FOUND
        ${CMAKE_FIND_PACKAGE_NAME}_NOT_FOUND_MESSAGE
    )
        cmake_parse_arguments(${CMAKE_FIND_PACKAGE_NAME} "" "ALTERNATIVE" "" ${ARGN})
        # We now have the ${CMAKE_FIND_PACKAGE_NAME}_ALTERNATIVE variable created for us.

        set(${CMAKE_FIND_PACKAGE_NAME}_${TYPE}_FOUND TRUE)

        foreach (
            ${CMAKE_FIND_PACKAGE_NAME}_${TYPE}_TARGET
            IN LISTS
            ${CMAKE_FIND_PACKAGE_NAME}_${TYPE}_TARGETS
        )
            # Check, if any of the targets for the requested TYPE does not exist
            if (NOT EXISTS "${${CMAKE_FIND_PACKAGE_NAME}_${TYPE}_TARGET}")
                set(${CMAKE_FIND_PACKAGE_NAME}_${TYPE}_FOUND FALSE)
                break ()
            endif ()
        endforeach ()

        # If TYPE targets are all installed, include them.
        if (${CMAKE_FIND_PACKAGE_NAME}_${TYPE}_FOUND)
            foreach (
                ${CMAKE_FIND_PACKAGE_NAME}_${TYPE}_TARGET
                IN LISTS
                ${CMAKE_FIND_PACKAGE_NAME}_${TYPE}_TARGETS
            )
                # We know they all exist.
                include("${${CMAKE_FIND_PACKAGE_NAME}_${TYPE}_TARGET}")
            endforeach ()
        # Otherwise at least load the ALTERNATIVE targets, if given
        elseif (DEFINED ${CMAKE_FIND_PACKAGE_NAME}_ALTERNATIVE)
            message(WARNING
                "Requested `${TYPE}` targets for package ${CMAKE_FIND_PACKAGE_NAME} were not found. "
                "Trying alternative `${${CMAKE_FIND_PACKAGE_NAME}_ALTERNATIVE}` targets."
            )
            _load_static_shared_targets_load_targets(${${CMAKE_FIND_PACKAGE_NAME}_ALTERNATIVE})
        else ()
            set(${CMAKE_FIND_PACKAGE_NAME}_NOT_FOUND_MESSAGE
                "${CMAKE_FIND_PACKAGE_NAME} `${TYPE}` libraries were requested but not found.")
            set(${CMAKE_FIND_PACKAGE_NAME}_FOUND FALSE)
            return()
        endif ()
    endblock ()
endmacro()
