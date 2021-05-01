set( CMAKE_BUILD_TYPE            RelWithDebInfo                       CACHE STRING   "CMake build type" )
set( CMAKE_PREFIX_PATH           "/opt/Qt/this-version/gcc_64;$ENV{HOME}/source/vlc-qt-clang"           )
set( CMAKE_C_COMPILER            "/usr/bin/clang"                     CACHE FILEPATH "The C compiler"   )
set( CMAKE_CXX_COMPILER          "/usr/bin/clang++"                   CACHE FILEPATH "The C++ compiler" )
set( CMAKE_CXX_FLAGS_INIT        " ${CMAKE_CXX_FLAGS_INIT} -stdlib=libc++ "                             )



# VSCode CMake extension likes CMAKE_CXX_COMPILER/CMAKE_C_COMPILER in the cache
# (though CMake is trying to do this a diffferent way : https://gitlab.kitware.com/cmake/cmake/-/issues/20225)

IF ( EXISTS "/opt/clang+llvm-9.0.0-x86_64-linux-gnu-ubuntu-18.04/lib" )
	set( CMAKE_EXE_LINKER_FLAGS_INIT " -Wl,-rpath=/opt/clang+llvm-9.0.0-x86_64-linux-gnu-ubuntu-18.04/lib "      )
ELSE()
	set( CMAKE_EXE_LINKER_FLAGS_INIT " -Wl,-rpath=/opt/clang+llvm-9.0.0-x86_64-pc-linux-gnu/lib "                )
ENDIF()

include( "${CMAKE_CURRENT_LIST_DIR}/misc.cmake" )
