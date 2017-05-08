
class base {
#include eclipse_user
#include plasma_user
include cpp_devel
#include general_desktop

# ./b2  toolset=clang cxxflags="-stdlib=libc++" linkflags="-stdlib=libc++" --layout=tagged variant=release
# ./b2  toolset=clang cxxflags="-stdlib=libc++" linkflags="-stdlib=libc++" --layout=tagged variant=debug   define=_GLIBCXX_DEBUG
# ./b2                                                                     --layout=tagged variant=release
# ./b2                                                                     --layout=tagged variant=debug   define=_GLIBCXX_DEBUG

# boost { 'clang_boost' :
#   compiler => 'clang',
# }

boost { 'gcc_boost':
  compiler => 'gcc',
}

}

node 'default' {
  include base
}
