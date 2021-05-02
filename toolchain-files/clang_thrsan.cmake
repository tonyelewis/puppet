set( CMAKE_BUILD_TYPE            Debug                                CACHE STRING   "CMake build type" )
set( CMAKE_C_COMPILER            "$ENV{HOME}/source/llvm/bin/clang"   CACHE FILEPATH "The C compiler"   )
set( CMAKE_CXX_COMPILER          "$ENV{HOME}/source/llvm/bin/clang++" CACHE FILEPATH "The C++ compiler" )
set( CMAKE_CXX_FLAGS_TLCHN_INIT  " -stdlib=libc++ -fsanitize=thread "                                   )
set( CMAKE_EXE_LINKER_FLAGS_INIT " -Wl,-rpath=$ENV{HOME}/source/llvm/lib "                              )


# VSCode CMake extension likes CMAKE_CXX_COMPILER/CMAKE_C_COMPILER in the cache
# (though CMake is trying to do this a diffferent way : https://gitlab.kitware.com/cmake/cmake/-/issues/20225)







include( "${CMAKE_CURRENT_LIST_DIR}/misc.cmake" )
