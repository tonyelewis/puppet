
class base {
#include eclipse_user
#include plasma_user
include cpp_devel
#include general_desktop

# ./b2  toolset=clang cxxflags="-stdlib=libc++" linkflags="-stdlib=libc++" --layout=tagged variant=release
# ./b2  toolset=clang cxxflags="-stdlib=libc++" linkflags="-stdlib=libc++" --layout=tagged variant=debug   define=_GLIBCXX_DEBUG
# ./b2                                                                     --layout=tagged variant=release
# ./b2                                                                     --layout=tagged variant=debug   define=_GLIBCXX_DEBUG

boost { 'boost__clang__1_66_0__c++14':
  compiler      => 'clang',
  boost_version => '1_66_0',
  cpp_standard  => 'c++14',
}

boost { 'boost__gcc__1_66_0__c++14':
  compiler      => 'gcc',
  boost_version => '1_66_0',
  cpp_standard  => 'c++14',
}

}

node 'default' {
  include base
}
