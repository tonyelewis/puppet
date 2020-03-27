set( ENV{Boost_DIR}              /opt/boost_1_72_0_normal_c++17                                                                                               )
set( CMAKE_BUILD_TYPE            RELWITHDEBINFO                                                                                                               )
set( CMAKE_PREFIX_PATH           "/opt/Qt/this-version/gcc_64;$ENV{HOME}/source/cpprestsdk-clang;$ENV{HOME}/source/QtAV-clang;$ENV{HOME}/source/vlc-qt-clang" )
set( CMAKE_C_COMPILER            "/usr/bin/clang"                                                                                                             )
set( CMAKE_CXX_COMPILER          "/usr/bin/clang++"                                                                                                           )
set( CMAKE_CXX_FLAGS_INIT        " -stdlib=libc++ -DBOOST_ASIO_HAS_STD_STRING_VIEW ${CMAKE_CXX_FLAGS} "                                                       )
set( CMAKE_EXE_LINKER_FLAGS_INIT " -Wl,-rpath=/opt/clang+llvm-9.0.0-x86_64-pc-linux-gnu/lib "                                                                 )

include( "${CMAKE_CURRENT_LIST_DIR}/misc.cmake" )
