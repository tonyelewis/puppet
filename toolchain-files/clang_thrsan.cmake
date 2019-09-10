set( ENV{Boost_DIR}     /opt/boost_1_70_0_thrsan_c++17                                                                                               )
set( CMAKE_BUILD_TYPE   DEBUG                                                                                                                        )
set( CMAKE_PREFIX_PATH  "/opt/Qt/this-version/gcc_64;$ENV{HOME}/source/cpprestsdk-clang;$ENV{HOME}/source/QtAV-clang;$ENV{HOME}/source/vlc-qt-clang" )
set( CMAKE_C_COMPILER   "$ENV{HOME}/source/llvm/bin/clang"                                                                                           )
set( CMAKE_CXX_COMPILER "$ENV{HOME}/source/llvm/bin/clang++"                                                                                         )
set( CMAKE_CXX_FLAGS    "-stdlib=libc++ -fsanitize=thread -DBOOST_ASIO_HAS_STD_STRING_VIEW ${CMAKE_CXX_FLAGS}"                                       )

include( "${CMAKE_CURRENT_LIST_DIR}/misc.cmake" )
