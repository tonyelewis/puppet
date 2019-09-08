
# If building with GCC on Linux and if it isn't the standard OS compiler set up in /usr/bin,
# set the rpath for build (but not install?) executables to include the lib64 directory of that GCC root dir
# so that the executable will pick up the correct libstdc++.so without having to be told where to look
if ( ${CMAKE_HOST_SYSTEM_NAME} STREQUAL "Linux" AND ${CMAKE_CXX_COMPILER} MATCHES "g\\+\\+" )
	get_filename_component( CMAKE_CXX_COMPILER_BIN_DIR ${CMAKE_CXX_COMPILER} DIRECTORY )
	if ( CMAKE_CXX_COMPILER_BIN_DIR MATCHES "bin$" AND NOT CMAKE_CXX_COMPILER_BIN_DIR STREQUAL "/usr/bin" )
		get_filename_component( CMAKE_CXX_COMPILER_ROOT_DIR ${CMAKE_CXX_COMPILER_BIN_DIR} DIRECTORY )
		list( APPEND CMAKE_BUILD_RPATH "${CMAKE_CXX_COMPILER_ROOT_DIR}/lib64" )
	endif()
endif()
