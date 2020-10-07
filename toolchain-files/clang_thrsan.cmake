set( ENV{Boost_DIR}              /opt/boost_1_73_0_thrsan_c++17                                                                                               )
set( CMAKE_BUILD_TYPE            DEBUG                                                                                                                        )
set( CMAKE_PREFIX_PATH           "/opt/Qt/this-version/gcc_64;$ENV{HOME}/source/cpprestsdk-clang_thrsan;$ENV{HOME}/source/QtAV-clang;$ENV{HOME}/source/vlc-qt-clang" )
set( CMAKE_C_COMPILER            "$ENV{HOME}/source/llvm/bin/clang"                                                                                           )
set( CMAKE_CXX_COMPILER          "$ENV{HOME}/source/llvm/bin/clang++"                                                                                         )
set( CMAKE_CXX_FLAGS_INIT        "-stdlib=libc++ -fsanitize=thread ${CMAKE_CXX_FLAGS}"                                                                        )
set( CMAKE_EXE_LINKER_FLAGS_INIT " -Wl,-rpath=$ENV{HOME}/source/llvm/lib "                                                                                    )





include( "${CMAKE_CURRENT_LIST_DIR}/misc.cmake" )
