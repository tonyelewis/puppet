# Add colour diagnostics when using Ninja
if ( CMAKE_GENERATOR STREQUAL "Ninja" )
    add_compile_options( $<$<CXX_COMPILER_ID:Clang>:-fcolor-diagnostics> )
    add_compile_options( $<$<CXX_COMPILER_ID:GNU>:-fdiagnostics-color> )
endif()

set( CMAKE_CXX_EXTENSIONS "OFF" )
