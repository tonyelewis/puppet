set( CMAKE_BUILD_TYPE            RelWithDebInfo                       CACHE STRING   "CMake build type" )
set( CMAKE_C_COMPILER            "/usr/bin/gcc"                       CACHE FILEPATH "The C compiler"   )
set( CMAKE_CXX_COMPILER          "/usr/bin/g++"                       CACHE FILEPATH "The C++ compiler" )
set( CMAKE_CXX_FLAGS_TLCHN_INIT  " -m32 "                                                               )



# VSCode CMake extension likes CMAKE_CXX_COMPILER/CMAKE_C_COMPILER in the cache
# (though CMake is trying to do this a diffferent way : https://gitlab.kitware.com/cmake/cmake/-/issues/20225)



include( "${CMAKE_CURRENT_LIST_DIR}/misc.cmake" )
