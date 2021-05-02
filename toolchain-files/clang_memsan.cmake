set( CMAKE_BUILD_TYPE            Debug                                CACHE STRING   "CMake build type"                                                                                                      )
set( CMAKE_C_COMPILER            "$ENV{HOME}/source/llvm/bin/clang"   CACHE FILEPATH "The C compiler"                                                                                                        )
set( CMAKE_CXX_COMPILER          "$ENV{HOME}/source/llvm/bin/clang++" CACHE FILEPATH "The C++ compiler"                                                                                                      )
set( CMAKE_CXX_FLAGS_TLCHN_INIT  " -fsanitize=memory -fsanitize-memory-track-origins -fPIE -fPIC -fno-omit-frame-pointer -nostdinc++ -I$ENV{HOME}/source/msan-libcxx/include/c++/v1 "                        )
set( CMAKE_EXE_LINKER_FLAGS_INIT " -fsanitize=memory -fpie -stdlib=libc++ -Wno-unused-command-line-argument -L$ENV{HOME}/source/msan-libcxx/lib -Wl,-rpath,$ENV{HOME}/source/msan-libcxx/lib -lc++abi -lc++" )


# VSCode CMake extension likes CMAKE_CXX_COMPILER/CMAKE_C_COMPILER in the cache
# (though CMake is trying to do this a diffferent way : https://gitlab.kitware.com/cmake/cmake/-/issues/20225)







include( "${CMAKE_CURRENT_LIST_DIR}/misc.cmake" )

# set( CMAKE_CXX_FLAGS_INIT        "  -fPIE -fPIC -I$ENV{HOME}/source/msan-libcxx/include/c++/v1 " )