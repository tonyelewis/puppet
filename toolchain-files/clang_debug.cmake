set( CMAKE_BUILD_TYPE            Debug                                CACHE STRING   "CMake build type" )
set( CMAKE_C_COMPILER            "/usr/bin/clang"                     CACHE FILEPATH "The C compiler"   )
set( CMAKE_CXX_COMPILER          "/usr/bin/clang++"                   CACHE FILEPATH "The C++ compiler" )
set( CMAKE_CXX_FLAGS_TLCHN_INIT  " -stdlib=libc++ "                                                     )



# VSCode CMake extension likes CMAKE_CXX_COMPILER/CMAKE_C_COMPILER in the cache
# (though CMake is trying to do this a diffferent way : https://gitlab.kitware.com/cmake/cmake/-/issues/20225)

set( CMAKE_EXE_LINKER_FLAGS_INIT " -Wl,-rpath=/opt/clang+llvm-16.0.4-x86_64-linux-gnu-ubuntu-22.04/lib/x86_64-unknown-linux-gnu " )

include( "${CMAKE_CURRENT_LIST_DIR}/misc.cmake" )
