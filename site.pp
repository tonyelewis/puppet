class base {
  include eclipse_user
  include plasma_user
  include cpp_devel
  include general_desktop

  # TODO: Split into normal / checked versions, with the checked version using:
  #
  #     define=_GLIBCXX_DEBUG define=_LIBCPP_DEBUG=1
  #
  # (_LIBCPP_DEBUG documented here: https://libcxx.llvm.org/docs/DesignDocs/DebugMode.html
  # ...has been around for a while - see https://releases.llvm.org/5.0.0/projects/libcxx/docs/DesignDocs/DebugMode.html)

  # boost { 'boost__1_75_0__c++17':
  #   boost_version           => '1_75_0',
  #   cpp_standard            => 'c++17',
  #   set_opt_include_symlink => true,
  # }

  # boost { 'boost__1_75_0__c++14':
  #   boost_version           => '1_75_0',
  #   cpp_standard            => 'c++14',
  # }
}

node 'default' {
  include base
}

# Boost commands:
#     ./b2  toolset=clang cxxflags="-stdlib=libc++" linkflags="-stdlib=libc++" --layout=tagged variant=release dll-path=/path/where/libs/will/live
#     ./b2  toolset=clang cxxflags="-stdlib=libc++" linkflags="-stdlib=libc++" --layout=tagged variant=debug   dll-path=/path/where/libs/will/live define=_GLIBCXX_DEBUG
#     ./b2                                                                     --layout=tagged variant=release dll-path=/path/where/libs/will/live
#     ./b2                                                                     --layout=tagged variant=debug   dll-path=/path/where/libs/will/live define=_GLIBCXX_DEBUG
