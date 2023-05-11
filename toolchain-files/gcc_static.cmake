set( CMAKE_BUILD_TYPE            RelWithDebInfo                       CACHE STRING   "CMake build type"     )
set( CMAKE_C_COMPILER            "/usr/bin/gcc"      CACHE FILEPATH "The C compiler"                        )
set( CMAKE_CXX_COMPILER          "/usr/bin/g++"      CACHE FILEPATH "The C++ compiler"                      )
set( CMAKE_CXX_FLAGS_TLCHN_INIT  " -static -DBoost_USE_STATIC_LIBS=ON "                                     )
option( Boost_USE_STATIC_LIBS "Booost static libs"   ON  )
option( BUILD_SHARED_LIBS     "Build shared library" OFF )

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
