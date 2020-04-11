# Add colour diagnostics when using Ninja
if ( CMAKE_GENERATOR STREQUAL "Ninja" )
    add_compile_options( $<$<CXX_COMPILER_ID:Clang>:-fcolor-diagnostics> )
    add_compile_options( $<$<CXX_COMPILER_ID:GNU>:-fdiagnostics-color> )
endif()

set( CMAKE_CXX_EXTENSIONS "OFF" )

if ( NOT DEFINED ENV{DO_NOT_SET_BOOST_ASIO_HAS_STD_STRING_VIEW} )
    set( CMAKE_CXX_FLAGS_INIT " -DBOOST_ASIO_HAS_STD_STRING_VIEW ${CMAKE_CXX_FLAGS_INIT} " )
endif()
