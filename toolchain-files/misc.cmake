# Note that these toolchain files may get run several times from different parts of the CMake run

# If building with GCC on Linux and if it isn't the standard OS compiler set up in /usr/bin,
# set the rpath for build (but not install?) executables to include the lib64 directory of that GCC root dir
# so that the executable will pick up the correct libstdc++.so without having to be told where to look
if ( ${CMAKE_HOST_SYSTEM_NAME} STREQUAL "Linux" AND ${CMAKE_CXX_COMPILER} MATCHES "/g\\+\\+$" )
	get_filename_component( CMAKE_CXX_COMPILER_BIN_DIR ${CMAKE_CXX_COMPILER} DIRECTORY )
	if ( CMAKE_CXX_COMPILER_BIN_DIR MATCHES "bin$" AND NOT CMAKE_CXX_COMPILER_BIN_DIR STREQUAL "/usr/bin" )
		get_filename_component( CMAKE_CXX_COMPILER_ROOT_DIR ${CMAKE_CXX_COMPILER_BIN_DIR} DIRECTORY )
		list( APPEND CMAKE_BUILD_RPATH "${CMAKE_CXX_COMPILER_ROOT_DIR}/lib64" )
	endif()
endif()

# Add colour diagnostics when using Ninja
if ( CMAKE_GENERATOR STREQUAL "Ninja" )
	add_compile_options( $<$<CXX_COMPILER_ID:Clang>:-fcolor-diagnostics> )
	add_compile_options( $<$<CXX_COMPILER_ID:GNU>:-fdiagnostics-color> )
endif()

set( CMAKE_CXX_EXTENSIONS "OFF" )

set( PROJECT_CONFIG_DIR "${CMAKE_CURRENT_LIST_DIR}/project" )
get_filename_component( PROJECT_SOURCE_DIR_NAME "${PROJECT_SOURCE_DIR}" NAME )
string( REGEX REPLACE "-[0-9]$" "" PROJECT_SOURCE_DIR_NAME_STRIPPED "${PROJECT_SOURCE_DIR_NAME}" )
set( PROJECT_SPECIFIC_CMAKE_CONFIG "${PROJECT_CONFIG_DIR}/${PROJECT_SOURCE_DIR_NAME_STRIPPED}.cmake" )
set( DEFAULT_PROJECT_SPECIFIC_CMAKE_CONFIG "${PROJECT_CONFIG_DIR}/default.cmake" )

# If there is a project specific config, use it
if( EXISTS "${PROJECT_SPECIFIC_CMAKE_CONFIG}" )
	message( "Including project-specific configuration file ${PROJECT_SPECIFIC_CMAKE_CONFIG}" )
	include( "${PROJECT_SPECIFIC_CMAKE_CONFIG}" )
# Otherwise (as long as the project isn't "CMakeTmp") use the default project config
#
# TODO: What about this getting called from "CMakeTmp"? Does this mean the project
#       should be stored in a CACHE variable and that gets used here? Does it matter?
elseif( NOT ${PROJECT_SOURCE_DIR_NAME_STRIPPED} STREQUAL "CMakeTmp" )
	message( "No project-specific configuration file ${PROJECT_SPECIFIC_CMAKE_CONFIG} found - including ${DEFAULT_PROJECT_SPECIFIC_CMAKE_CONFIG}" )
	include( "${DEFAULT_PROJECT_SPECIFIC_CMAKE_CONFIG}" )
endif()

if( NOT ${PROJECT_SOURCE_DIR_NAME_STRIPPED} STREQUAL "CMakeTmp" )
	set( CMAKE_CXX_FLAGS_INIT " ${CMAKE_CXX_FLAGS_TLCHN_INIT} ${CMAKE_CXX_FLAGS_PRJCT_INIT} " )
	if ( NOT DEFINED ENV{DO_NOT_SET_BOOST_ASIO_HAS_STD_STRING_VIEW} )
		set( CMAKE_CXX_FLAGS_INIT " -DBOOST_ASIO_HAS_STD_STRING_VIEW ${CMAKE_CXX_FLAGS_INIT} " )
	endif()
endif()
