option( IS_VSCODE_CMAKE_BUILD "Flag to indicate this is being run in a VSCode configure build (`.vscode-cmake-build/`)" ON )

include( "${CMAKE_CURRENT_LIST_DIR}/clang_debug.cmake" )
