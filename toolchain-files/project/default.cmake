set( CMAKE_CXX_FLAGS_PRJCT_INIT_LIST
	-W
	-Wall
	-Werror
	-Wextra
	-Wcast-qual
	-Wconversion
	-Wformat=2
	-Wnon-virtual-dtor
	-Wshadow
	-Wimplicit-fallthrough
	-Wsign-compare
	-Wsign-conversion
	-pedantic
	-ftabstop=2
	-Wno-deprecated-declarations
)
string( REPLACE ";" " " CMAKE_CXX_FLAGS_PRJCT_INIT "${CMAKE_CXX_FLAGS_PRJCT_INIT_LIST}" )
# $<$<AND:$<CXX_COMPILER_ID:GNU>,$<VERSION_GREATER:$<CXX_COMPILER_VERSION>,6.0.0>>:-Wduplicated-cond>
# $<$<AND:$<CXX_COMPILER_ID:GNU>,$<VERSION_GREATER:$<CXX_COMPILER_VERSION>,6.0.0>>:-Wnull-dereference>
# $<$<AND:$<CXX_COMPILER_ID:GNU>,$<VERSION_GREATER:$<CXX_COMPILER_VERSION>,7.0.0>>:-Wduplicated-branches>
# $<$<AND:$<CXX_COMPILER_ID:GNU>,$<VERSION_GREATER:$<CXX_COMPILER_VERSION>,7.0.0>>:-Wrestrict>
# $<$<AND:$<CXX_COMPILER_ID:GNU>,$<VERSION_GREATER:$<CXX_COMPILER_VERSION>,8.0.0>,$<VERSION_LESS:$<CXX_COMPILER_VERSION>,9.0.0>>:-Wno-maybe-uninitialized>
