set( ENV{Boost_DIR}     /opt/boost_1_70_0_dbgstd_c++17                                                                                                       )
set( CMAKE_BUILD_TYPE   DEBUG                                                                                                                                )
set( CMAKE_PREFIX_PATH  "/opt/Qt/this-version/gcc_64;$ENV{HOME}/source/cpprestsdk-gcc-debug-checked;$ENV{HOME}/source/QtAV-gcc;$ENV{HOME}/source/vlc-qt-gcc" )
set( CMAKE_C_COMPILER   "$ENV{HOME}/source/gcc/bin/gcc"                                                                                                      )
set( CMAKE_CXX_COMPILER "$ENV{HOME}/source/gcc/bin/g++"                                                                                                      )
set( CMAKE_CXX_FLAGS    " -D_GLIBCXX_DEBUG -DBOOST_ASIO_HAS_STD_STRING_VIEW ${CMAKE_CXX_FLAGS}"                                                              )

include( "${CMAKE_CURRENT_LIST_DIR}/fix-rpath-for-built-gcc.cmake" )
include( "${CMAKE_CURRENT_LIST_DIR}/misc.cmake" )
