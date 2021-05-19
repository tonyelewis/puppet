if ( ${IS_VSCODE_CMAKE_BUILD} )
	set( MXX_EDIT_SUITE_PROJECT_LEVEL COMPLETE CACHE STRING "How much of the project to build" FORCE )
endif()

if ( NOT EDIT_SUITE_TOOLCHAIN_FILE_HAS_APPENDED_TO_PREFIX_PATH )
	list( APPEND CMAKE_PREFIX_PATH "/opt/Qt/this-version/gcc_64" )
	list( APPEND CMAKE_PREFIX_PATH "$ENV{HOME}/source/vlc-qt-gcc" )
	option( EDIT_SUITE_TOOLCHAIN_FILE_HAS_APPENDED_TO_PREFIX_PATH "Whether this edit-suite toolchain file has already appended to the CMAKE_PREFIX_PATH" ON )
endif()

if ( DEFINED BUILD_SHARED_LIBS AND NOT BUILD_SHARED_LIBS )
	list( APPEND CMAKE_PREFIX_PATH "/opt/ffmpeg-4.4" )
endif()
