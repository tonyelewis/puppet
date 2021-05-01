set( CMAKE_BUILD_TYPE            Debug                                CACHE STRING   "CMake build type"            )
set( CMAKE_PREFIX_PATH           "/opt/Qt/this-version/gcc_64;$ENV{HOME}/source/vlc-qt-gcc"                        )
set( CMAKE_C_COMPILER            "$ENV{HOME}/source/gcc/bin/gcc"      CACHE FILEPATH "The C compiler"              )
set( CMAKE_CXX_COMPILER          "$ENV{HOME}/source/gcc/bin/g++"      CACHE FILEPATH "The C++ compiler"            )
set( CMAKE_CXX_FLAGS_INIT        " ${CMAKE_CXX_FLAGS_INIT} -D_GLIBCXX_DEBUG -DRANGES_NO_STD_FORWARD_DECLARATIONS " )



# VSCode CMake extension likes CMAKE_CXX_COMPILER/CMAKE_C_COMPILER in the cache
# (though CMake is trying to do this a diffferent way : https://gitlab.kitware.com/cmake/cmake/-/issues/20225)







include( "${CMAKE_CURRENT_LIST_DIR}/misc.cmake" )
