set( ENV{Boost_DIR}              /opt/boost_1_73_0_normal_c++17                                                                                         )
set( CMAKE_BUILD_TYPE            DEBUG                                                                                                                  )
set( CMAKE_PREFIX_PATH           "/opt/Qt/this-version/gcc_64;$ENV{HOME}/source/cpprestsdk-gcc_debug;$ENV{HOME}/source/QtAV-gcc;$ENV{HOME}/source/vlc-qt-gcc" )
set( CMAKE_C_COMPILER            "$ENV{HOME}/source/gcc/bin/gcc"                                                                                        )
set( CMAKE_CXX_COMPILER          "$ENV{HOME}/source/gcc/bin/g++"                                                                                        )
set( CMAKE_CXX_FLAGS_INIT        " ${CMAKE_CXX_FLAGS}"                                                                                                  )






include( "${CMAKE_CURRENT_LIST_DIR}/fix-rpath-for-built-gcc.cmake" )
include( "${CMAKE_CURRENT_LIST_DIR}/misc.cmake" )
