$user         = 'lewis'
$group        = 'lewis'
$home_dir     = "/home/${user}"
$user_src_dir = "${home_dir}/source"
$cpprest_root = "${user_src_dir}/cpprestsdk-master"
$release_dir  = "${cpprest_root}/Release"

Exec {
  path => [
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
  [ 'clang',             'clang', ' -DCMAKE_C_COMPILER=/usr/bin/clang -DCMAKE_CXX_COMPILER=/usr/bin/clang++ -DCMAKE_CXX_FLAGS=" -stdlib=libc++ ${CMAKE_CXX_FLAGS} " ' ],
  [ 'gcc',               'gcc',   ''                                                                                                                                  ],
  [ 'gcc-debug-checked', 'gcc',   ' -DCMAKE_BUILD_TYPE=Debug -DCMAKE_CXX_FLAGS=" -D_GLIBCXX_DEBUG=1 ${CMAKE_CXX_FLAGS} " '                                            ],
]

$tag_compiler_and_cmake_flags_sets.each | Array $tag_compiler_and_cmake_flags_set | {
  [ $tag, $compiler, $cmake_flags] = $tag_compiler_and_cmake_flags_set
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
  ->exec { "cmake cpprest ${tag}":
    command => "cmake -GNinja -B${build_dir} -H${release_dir} -DBOOST_ROOT=/opt/boost_1_68_0_${compiler}_c++14_build -DWERROR:BOOL=OFF -DCMAKE_INSTALL_RPATH_USE_LINK_PATH:BOOL=ON -DCMAKE_INSTALL_PREFIX=${install_dir} ${cmake_flags}",
    creates => "${build_dir}/build.ninja",
    group   => $user,
    require => Package[ 'libssl-dev' ],
    user    => $user,
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
