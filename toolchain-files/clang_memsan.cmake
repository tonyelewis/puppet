set( ENV{Boost_DIR}              /opt/boost_1_70_0_memsan_c++17                                                                                                                                                        )
set( CMAKE_BUILD_TYPE            DEBUG                                                                                                                                                                                 )
set( CMAKE_PREFIX_PATH           "/opt/Qt/this-version/gcc_64;$ENV{HOME}/source/cpprestsdk-clang;$ENV{HOME}/source/QtAV-clang;$ENV{HOME}/source/vlc-qt-clang"                                                          )
set( CMAKE_C_COMPILER            "$ENV{HOME}/source/llvm/bin/clang"                                                                                                                                                    )
set( CMAKE_CXX_COMPILER          "$ENV{HOME}/source/llvm/bin/clang++"                                                                                                                                                  )
set( CMAKE_CXX_FLAGS_INIT        " -fsanitize=memory -fsanitize-memory-track-origins -fPIE -fPIC -fno-omit-frame-pointer -nostdinc++ -I$ENV{HOME}/source/msan-libcxx/include/c++/v1 -DBOOST_ASIO_HAS_STD_STRING_VIEW " )
set( CMAKE_EXE_LINKER_FLAGS_INIT " -fsanitize=memory -fpie -stdlib=libc++ -Wno-unused-command-line-argument -L$ENV{HOME}/source/msan-libcxx/lib -Wl,-rpath,$ENV{HOME}/source/msan-libcxx/lib -lc++abi -lc++"           )

include( "${CMAKE_CURRENT_LIST_DIR}/misc.cmake" )

# set( CMAKE_CXX_FLAGS_INIT        "  -fPIE -fPIC -I$ENV{HOME}/source/msan-libcxx/include/c++/v1 -DBOOST_ASIO_HAS_STD_STRING_VIEW " )