set( ENV{Boost_DIR}     /opt/boost_1_70_0_normal_c++17                                                                                         )
set( CMAKE_BUILD_TYPE   RELWITHDEBINFO                                                                                                         )
set( CMAKE_PREFIX_PATH  "/opt/Qt/this-version/gcc_64;$ENV{HOME}/source/cpprestsdk-gcc;$ENV{HOME}/source/QtAV-gcc;$ENV{HOME}/source/vlc-qt-gcc" )
set( CMAKE_C_COMPILER   "$ENV{HOME}/source/gcc/bin/gcc"                                                                                        )
set( CMAKE_CXX_COMPILER "$ENV{HOME}/source/gcc/bin/g++"                                                                                        )
set( CMAKE_CXX_FLAGS    " -DBOOST_ASIO_HAS_STD_STRING_VIEW ${CMAKE_CXX_FLAGS}"                                                                 )

