# puppet apply --noop --test single_manifests/qtav.pp
# puppet apply        --test single_manifests/qtav.pp

$user           = 'lewis'
$group          = 'lewis'
$home_dir       = "/home/${user}"
$user_src_dir   = "${home_dir}/source"
$qtav_root      = "${user_src_dir}/QtAV-master"
$qt_install_dir = "/opt/Qt/5.12.0/gcc_64"

Exec {
  path => [
    '/usr/bin',
    '/usr/sbin',
    '/bin',
    '/sbin',
  ]
}

# Prerequisites:
#  * ffmpeg
#  * libpulse-dev
#  * libavfilter-dev
#
# From QtAV docs:
#
#   > OpenAL(recommended) or PulseAudio. To enable all supported features, you must install libass, XVideo and VA-API dev packages.
#   >
#   > sudo apt-get install libopenal-dev libpulse-dev libva-dev libxv-dev libass-dev libegl1-mesa-dev
#
# (but of these, only libpulse-dev was installed on bigslide at the time of writing)
package { [
  'ffmpeg',
  'libavfilter-dev',
  'libpulse-dev',
  ] :
  ensure => 'latest',
}

file { "Source dir ${user_src_dir}":
  ensure => 'directory',
  owner  => $user,
  group  => $user,
  path   => $user_src_dir,
}
->vcsrepo { 'clone qtav into source dir' :
  ensure     => present,
  group      => $group,
  owner      => $user,
  path       => $qtav_root,
  provider   => git,
  source     => 'git@github.com:wang-bin/QtAV.git',
  submodules => true,
  user       => $user,
}


$compiler_and_cmake_flags_pairs = {
  'clang' => ' -DCMAKE_C_COMPILER=/usr/bin/clang -DCMAKE_CXX_COMPILER=/usr/bin/clang++ -DCMAKE_CXX_FLAGS="-stdlib=libc++" ',
  'gcc'   => '',
}

$compiler_and_cmake_flags_pairs.each | String $compiler, String $cmake_flags | {
  $build_dir   = "${qtav_root}/${compiler}_build"
  $install_dir = "${user_src_dir}/QtAV-${compiler}"

  file { $build_dir:
    ensure  => 'directory',
    group   => $user,
    owner   => $user,
    require => Vcsrepo[ 'clone qtav into source dir' ],
  }
  ->file { $install_dir:
    ensure => 'directory',
    group  => $user,
    owner  => $user,
  }
  ->exec { "cmake qtav ${compiler}":
    command => "cmake -GNinja -B${build_dir} -H${qtav_root} -DCMAKE_PREFIX_PATH=${qt_install_dir} -DCMAKE_INSTALL_PREFIX=${install_dir} ${cmake_flags}",
    creates => "${build_dir}/build.ninja",
    group   => $user,
    require => Package[ 'ffmpeg', 'libpulse-dev' ],
    user    => $user,
  }
  ->exec { "build qtav ${compiler}":
    command => "ninja -j 8 -C ${build_dir}",
    creates => "${build_dir}/lib/libQtAV.so",
    group   => $user,
    timeout => 3600, # Defaults to 300s
    user    => $user,
  }
  ->exec { "install qtav ${compiler}":
    command   => "ninja -j 2 -C ${build_dir} install",
    creates   => "${install_dir}/lib/libQtAV.so",
    group     => $user,
    user      => $user,
    # logoutput => true,
  }
  # See https://github.com/wang-bin/QtAV/issues/1121
  ->file { "symlink QtAV CMake config-mode files ${compiler}":
    ensure => "link",
    group  => $user,
    owner  => $user,
    path   => "${install_dir}/lib/cmake/QtAV/qtav-config.cmake",
    target => "${install_dir}/lib/cmake/QtAV/QtAV-config.cmake",
  }
}
