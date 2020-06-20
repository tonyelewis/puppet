# puppet apply --noop --test cpprest.pp
# puppet apply        --test cpprest.pp

$user         = 'lewis'
$group        = 'lewis'
$home_dir     = "/home/${user}"
$user_src_dir = "${home_dir}/source"
$cpprest_root = "${user_src_dir}/cpprestsdk-master"
$release_dir  = "${cpprest_root}/Release"

Exec {
  path => [
    "${$home_dir}/bin",
    '/usr/bin',
    '/usr/sbin',
    '/bin',
    '/sbin',
  ]
}

package { 'libssl-dev':
  ensure => 'latest',
}
# package { 'libssl1.0-dev':
#   ensure => 'latest',
# }

file { "Source dir ${user_src_dir}":
  ensure => 'directory',
  owner  => $user,
  group  => $user,
  path   => $user_src_dir,
}
->vcsrepo { 'clone cpprest into source dir' :
  ensure   => present,
  group    => $group,
  owner    => $user,
  path     => $cpprest_root,
  provider => git,
  source   => 'https://github.com/Microsoft/cpprestsdk.git',
  user     => $user,
}

# Needs to checkout submodule https://github.com/zaphoyd/websocketpp in Release/libs/websocketpp to develop (bc0dc57)
# else this fails to build with more recent Boosts (>= 1.70 ish)
#
# Unfortunately, this:
#
#     ->vcsrepo { 'checkout cpprest submodule zaphoyd/websocketpp to bc0dc57' :
#       ensure   => present,
#       group    => $group,
#       owner    => $user,
#       path     => "${cpprest_root}/Release/libs/websocketpp",
#       provider => git,
#       source   => 'https://github.com/zaphoyd/websocketpp',
#       user     => $user,
#       revision => 'bc0dc57',
#     }
#
# ...fails with "Could not create repository (non-repository at path)"

# REMOVE THESE SOON IF NOT USED:
# $old_profile_details = [
#   [ 'clg70-cpp17-boost1680-normal', 'clang', '/opt/boost_1_72_0_clang_c++14_build', " -DCMAKE_C_COMPILER=/usr/bin/clang                    -DCMAKE_CXX_COMPILER=/usr/bin/clang++                                             -DCMAKE_CXX_FLAGS=' -std=c++17 -stdlib=libc++                                                                 \${CMAKE_CXX_FLAGS} ' " ],
#   [ 'clg90-cpp17-boost1680-dbgchk', 'clang', '/opt/boost_1_72_0_clang_c++14_build', " -DCMAKE_C_COMPILER=${home_dir}/source/llvm/bin/clang -DCMAKE_CXX_COMPILER=${home_dir}/source/llvm/bin/clang++ -DCMAKE_BUILD_TYPE=Debug -DCMAKE_CXX_FLAGS=' -std=c++17 -stdlib=libc++ -D_LIBCPP_DEBUG=0                                               \${CMAKE_CXX_FLAGS} ' " ],
#   [ 'clg90-cpp17-boost1680-ubasan', 'clang', '/opt/boost_1_72_0_clang_c++14_build', " -DCMAKE_C_COMPILER=${home_dir}/source/llvm/bin/clang -DCMAKE_CXX_COMPILER=${home_dir}/source/llvm/bin/clang++ -DCMAKE_BUILD_TYPE=Debug -DCMAKE_CXX_FLAGS=' -std=c++17 -stdlib=libc++ -fsanitize=address -fsanitize=undefined -fno-omit-frame-pointer \${CMAKE_CXX_FLAGS} ' " ],
#   [ 'gcc91-cpp17-boost1680-normal', 'gcc',   '/opt/boost_1_72_0_gcc_c++14_build',   " -DCMAKE_C_COMPILER=${home_dir}/source/gcc/bin/gcc    -DCMAKE_C_COMPILER=${home_dir}/source/gcc/bin/g++                                 -DCMAKE_CXX_FLAGS=' -std=c++17                                                                                \${CMAKE_CXX_FLAGS} ' " ],
#   [ 'gcc91-cpp17-boost1680-dbgchk', 'gcc',   '/opt/boost_1_72_0_gcc_c++14_build',   " -DCMAKE_C_COMPILER=${home_dir}/source/gcc/bin/gcc    -DCMAKE_C_COMPILER=${home_dir}/source/gcc/bin/g++        -DCMAKE_BUILD_TYPE=Debug -DCMAKE_CXX_FLAGS=' -std=c++17                -D_GLIBCXX_DEBUG=1                                              \${CMAKE_CXX_FLAGS} ' " ],
#   [ 'gcc91-cpp17-boost1680-ubasan', 'gcc',   '/opt/boost_1_72_0_gcc_c++14_build',   " -DCMAKE_C_COMPILER=${home_dir}/source/gcc/bin/gcc    -DCMAKE_C_COMPILER=${home_dir}/source/gcc/bin/g++        -DCMAKE_BUILD_TYPE=Debug -DCMAKE_CXX_FLAGS=' -std=c++17                -fsanitize=address -fsanitize=undefined -fno-omit-frame-pointer \${CMAKE_CXX_FLAGS} ' " ],

$profile_names = [
  'clang_dbgchk',
  'clang_debug',
  'clang_memsan',
  'clang_rwdi',
  'clang_thrsan',
  'clang_ubasan',
  'gcc_dbgchk',
  'gcc_debug',
  'gcc_rwdi',
  'gcc_ubasan',
]

$profile_names.each | String $profile_name | {
  $build_dir      = "${release_dir}/${profile_name}_build"
  $install_dir    = "${user_src_dir}/cpprestsdk-${profile_name}"
  $toolchain_file = "${$home_dir}/puppet/toolchain-files/${profile_name}.cmake"

  file { $build_dir:
    ensure  => 'directory',
    group   => $user,
    owner   => $user,
    require => Vcsrepo[ 'clone cpprest into source dir' ],
  }
  ->file { $install_dir:
    ensure => 'directory',
    group  => $user,
    owner  => $user,
  }
  ->exec { "cmake cpprest ${profile_name}":
    command     => "cmake -GNinja -B${build_dir} -H${release_dir} -DCMAKE_TOOLCHAIN_FILE=${toolchain_file} -DWERROR:BOOL=OFF -DCMAKE_INSTALL_RPATH_USE_LINK_PATH:BOOL=ON -DCMAKE_INSTALL_PREFIX=${install_dir} ",
    environment => [
        "DO_NOT_SET_BOOST_ASIO_HAS_STD_STRING_VIEW=1",
        "DISABLE_MY_STANDARD_CXX_WARNINGS=1",
        "HOME=${home_dir}",
   ],
    creates     => "${build_dir}/build.ninja",
    group       => $user,
    require     => Package[ 'libssl-dev' ],
    # require     => Package[ 'libssl1.0-dev' ],
    user        => $user,
  }
  ->exec { "build cpprest ${profile_name}":
    command => "ninja -j 2 -C ${build_dir}",
    creates => "${build_dir}/Binaries/libcpprest.so",
    group   => $user,
    timeout => 3600, # Defaults to 300s
    user    => $user,
  }
  ->exec { "install cpprest ${profile_name}":
    command => "ninja -j 2 -C ${build_dir} install",
    creates => "${install_dir}/lib/libcpprest.so",
    group   => $user,
    user    => $user,
  }
}
