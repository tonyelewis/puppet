set( ENV{Boost_DIR}              /opt/boost_1_75_0_memsan_c++17                                                                                                                                              )
set( CMAKE_BUILD_TYPE            DEBUG                                                                                                                                                                       )
set( CMAKE_PREFIX_PATH           "/opt/Qt/this-version/gcc_64;$ENV{HOME}/source/cpprestsdk-clang_memsan;$ENV{HOME}/source/QtAV-clang;$ENV{HOME}/source/vlc-qt-clang"                                         )
set( CMAKE_C_COMPILER            "$ENV{HOME}/source/llvm/bin/clang"   CACHE FILEPATH "The C compiler"                                                                                                        )
set( CMAKE_CXX_COMPILER          "$ENV{HOME}/source/llvm/bin/clang++" CACHE FILEPATH "The C++ compiler"                                                                                                      )
set( CMAKE_CXX_FLAGS_INIT        " -fsanitize=memory -fsanitize-memory-track-origins -fPIE -fPIC -fno-omit-frame-pointer -nostdinc++ -I$ENV{HOME}/source/msan-libcxx/include/c++/v1 "                        )
set( CMAKE_EXE_LINKER_FLAGS_INIT " -fsanitize=memory -fpie -stdlib=libc++ -Wno-unused-command-line-argument -L$ENV{HOME}/source/msan-libcxx/lib -Wl,-rpath,$ENV{HOME}/source/msan-libcxx/lib -lc++abi -lc++" )

# VSCode CMake extension likes CMAKE_CXX_COMPILER/CMAKE_C_COMPILER in the cache
# (though CMake is trying to do this a diffferent way : https://gitlab.kitware.com/cmake/cmake/-/issues/20225)







include( "${CMAKE_CURRENT_LIST_DIR}/misc.cmake" )

# set( CMAKE_CXX_FLAGS_INIT        "  -fPIE -fPIC -I$ENV{HOME}/source/msan-libcxx/include/c++/v1 " )