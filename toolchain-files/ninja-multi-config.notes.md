# Ninja multi-config

To use [Ninja multi-config](https://cmake.org/cmake/help/latest/generator/Ninja%20Multi-Config.html), so something like:

~~~cmake
set( CMAKE_CONFIGURATION_TYPES   "Debug;Relwithdebinfo" )
set( CMAKE_DEFAULT_BUILD_TYPE    Relwithdebinfo         )
~~~

The case of the build types must be as above.
