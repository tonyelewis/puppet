set( CMAKE_CXX_FLAGS_PRJCT_INIT_LIST
	-Wcast-qual
	-Wconversion
	-Wformat=2
	-Wimplicit-fallthrough
	-Wno-deprecated-declarations
	-Wnon-virtual-dtor
	-Wnull-dereference
	-Wshadow
	-Wsign-compare
	-Wsign-conversion
)

if ( CMAKE_CXX_COMPILER MATCHES "clang\\+\\+$"  )
	list( APPEND CMAKE_CXX_FLAGS_PRJCT_INIT_LIST
		-Wmove
	)
elseif ( CMAKE_CXX_COMPILER MATCHES "g\\+\\+$"  )
	list( APPEND CMAKE_CXX_FLAGS_PRJCT_INIT_LIST
		-Wduplicated-branches
		-Wduplicated-cond
		-Wnull-dereference
		-Wrestrict
	)
endif()

list( SORT CMAKE_CXX_FLAGS_PRJCT_INIT_LIST )
list( PREPEND CMAKE_CXX_FLAGS_PRJCT_INIT_LIST
	-ftabstop=2
	-pedantic
	-W
	-Wall
	-Werror
	-Wextra
)
string( REPLACE ";" " " CMAKE_CXX_FLAGS_PRJCT_INIT "${CMAKE_CXX_FLAGS_PRJCT_INIT_LIST}" )
