set( ENV{Boost_DIR}              /opt/boost_1_75_0_normal_c++17                                                                                         )
set( CMAKE_BUILD_TYPE            RELWITHDEBINFO                                                                                                         )
set( CMAKE_PREFIX_PATH           "/opt/Qt/this-version/gcc_64;$ENV{HOME}/source/cpprestsdk-gcc_rwdi;$ENV{HOME}/source/QtAV-gcc;$ENV{HOME}/source/vlc-qt-gcc" )
set( CMAKE_C_COMPILER            "$ENV{HOME}/source/gcc/bin/gcc" CACHE FILEPATH "The C compiler"                                                        )
set( CMAKE_CXX_COMPILER          "$ENV{HOME}/source/gcc/bin/g++" CACHE FILEPATH "The C++ compiler"                                                      )
set( CMAKE_CXX_FLAGS_INIT        " ${CMAKE_CXX_FLAGS} -static "                                                                                         )
set( Boost_USE_STATIC_LIBS       ON )

# VSCode CMake extension likes CMAKE_CXX_COMPILER/CMAKE_C_COMPILER in the cache
# (though CMake is trying to do this a diffferent way : https://gitlab.kitware.com/cmake/cmake/-/issues/20225)







include( "${CMAKE_CURRENT_LIST_DIR}/misc.cmake" )

# The problem with this is that it needs to be disabled for the auto-generated code in edit-suite
#
# # This condition allows these strict warnings to be turned off when using this toolchain file for compiling dependency libraries (eg cpprest)
# if ( NOT DEFINED ENV{DISABLE_MY_STANDARD_CXX_WARNINGS} )
# 
#     set( CMAKE_CXX_FLAGS_INIT        " ${CMAKE_CXX_FLAGS_INIT} -W -Wall -Werror -Wextra -Wcast-qual -Wconversion -Wformat=2 -Wnon-virtual-dtor -Wshadow -Wsign-compare -Wsign-conversion -pedantic -ftabstop=2 " )
# 
#     # For GCC:
#     set( CMAKE_CXX_FLAGS_INIT        " ${CMAKE_CXX_FLAGS_INIT} -Wduplicated-cond -Wnull-dereference -Wduplicated-branches -Wrestrict ")
# 
# endif()
