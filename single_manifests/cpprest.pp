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
  source   => 'git@github.com:Microsoft/cpprestsdk.git',
  user     => $user,
}

$tag_compiler_and_cmake_flags_sets = [
  [ 'clg70-cpp17-boost1680-normal', 'clang', '/opt/boost_1_68_0_clang_c++14_build', " -DCMAKE_C_COMPILER=/usr/bin/clang                    -DCMAKE_CXX_COMPILER=/usr/bin/clang++                                             -DCMAKE_CXX_FLAGS=' -std=c++17 -stdlib=libc++                                                                 \${CMAKE_CXX_FLAGS} ' " ],
  [ 'clg90-cpp17-boost1680-dbgchk', 'clang', '/opt/boost_1_68_0_clang_c++14_build', " -DCMAKE_C_COMPILER=${home_dir}/source/llvm/bin/clang -DCMAKE_CXX_COMPILER=${home_dir}/source/llvm/bin/clang++ -DCMAKE_BUILD_TYPE=Debug -DCMAKE_CXX_FLAGS=' -std=c++17 -stdlib=libc++ -D_LIBCPP_DEBUG=0                                               \${CMAKE_CXX_FLAGS} ' " ],
  [ 'clg90-cpp17-boost1680-ubasan', 'clang', '/opt/boost_1_68_0_clang_c++14_build', " -DCMAKE_C_COMPILER=${home_dir}/source/llvm/bin/clang -DCMAKE_CXX_COMPILER=${home_dir}/source/llvm/bin/clang++ -DCMAKE_BUILD_TYPE=Debug -DCMAKE_CXX_FLAGS=' -std=c++17 -stdlib=libc++ -fsanitize=address -fsanitize=undefined -fno-omit-frame-pointer \${CMAKE_CXX_FLAGS} ' " ],
  [ 'gcc91-cpp17-boost1680-normal', 'gcc',   '/opt/boost_1_68_0_gcc_c++14_build',   " -DCMAKE_C_COMPILER=${home_dir}/source/gcc/bin/gcc    -DCMAKE_C_COMPILER=${home_dir}/source/gcc/bin/g++                                 -DCMAKE_CXX_FLAGS=' -std=c++17                                                                                \${CMAKE_CXX_FLAGS} ' " ],
  [ 'gcc91-cpp17-boost1680-dbgchk', 'gcc',   '/opt/boost_1_68_0_gcc_c++14_build',   " -DCMAKE_C_COMPILER=${home_dir}/source/gcc/bin/gcc    -DCMAKE_C_COMPILER=${home_dir}/source/gcc/bin/g++        -DCMAKE_BUILD_TYPE=Debug -DCMAKE_CXX_FLAGS=' -std=c++17                -D_GLIBCXX_DEBUG=1                                              \${CMAKE_CXX_FLAGS} ' " ],
  [ 'gcc91-cpp17-boost1680-ubasan', 'gcc',   '/opt/boost_1_68_0_gcc_c++14_build',   " -DCMAKE_C_COMPILER=${home_dir}/source/gcc/bin/gcc    -DCMAKE_C_COMPILER=${home_dir}/source/gcc/bin/g++        -DCMAKE_BUILD_TYPE=Debug -DCMAKE_CXX_FLAGS=' -std=c++17                -fsanitize=address -fsanitize=undefined -fno-omit-frame-pointer \${CMAKE_CXX_FLAGS} ' " ],
]

$tag_compiler_and_cmake_flags_sets.each | Array $tag_compiler_and_cmake_flags_set | {
  [ $tag, $compiler, $boost_dir, $cmake_flags] = $tag_compiler_and_cmake_flags_set
  $build_dir   = "${release_dir}/${tag}_build"
  $install_dir = "${user_src_dir}/cpprestsdk-${tag}"

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
  # Come cpprestsdk supporting Boost 1.70 (it currently fails with: "fatal error: 'boost/bind/bind.hpp' file not found")
  # remove the boost flags in the command and add:
  #   environment => [ "Boost_DIR=${boost_dir}" ],
  ->exec { "cmake cpprest ${tag}":
    command     => "cmake -GNinja -B${build_dir} -H${release_dir} -DBoost_NO_BOOST_CMAKE=ON -DBOOST_ROOT=${boost_dir} -DWERROR:BOOL=OFF -DCMAKE_INSTALL_RPATH_USE_LINK_PATH:BOOL=ON -DCMAKE_INSTALL_PREFIX=${install_dir} ${cmake_flags}",
  #   environment => [ "Boost_DIR=${boost_dir}" ],
    creates     => "${build_dir}/build.ninja",
    group       => $user,
    require     => Package[ 'libssl-dev' ],
    user        => $user,
  }
  ->exec { "build cpprest ${tag}":
    command => "ninja -j 2 -C ${build_dir}",
    creates => "${build_dir}/Binaries/libcpprest.so",
    group   => $user,
    timeout => 3600, # Defaults to 300s
    user    => $user,
  }
  ->exec { "install cpprest ${tag}":
    command => "ninja -j 2 -C ${build_dir} install",
    creates => "${install_dir}/lib/libcpprest.so",
    group   => $user,
    user    => $user,
  }
}
