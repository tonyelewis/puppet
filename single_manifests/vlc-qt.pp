# puppet apply --noop --test single_manifests/vlc-qt.pp
# puppet apply        --test single_manifests/vlc-qt.pp

$user           = 'lewis'
$group          = 'lewis'
$home_dir       = "/home/${user}"
$user_src_dir   = "${home_dir}/source"
$vlc_qt_root    = "${user_src_dir}/vlc-qt-master"
$qt_install_dir = "/opt/Qt/this-version/gcc_64"

Exec {
  path => [
    '/usr/bin',
    '/usr/sbin',
    '/bin',
    '/sbin',
  ]
}

# # Prerequisites:
# #  * ffmpeg
# #  * libpulse-dev
# #  * libvlc-dev
# #  * libavfilter-dev
# #
# # From vlc-qt docs:
# #
# #   > OpenAL(recommended) or PulseAudio. To enable all supported features, you must install libass, XVideo and VA-API dev packages.
# #   >
# #   > sudo apt-get install libopenal-dev libpulse-dev libva-dev libxv-dev libass-dev libegl1-mesa-dev
# #
# # (but of these, only libpulse-dev was installed on bigslide at the time of writing)
package { [
  'libvlc-dev',
  'libvlccore-dev',
  ] :
  ensure => 'latest',
}

file { "Source dir ${user_src_dir}":
  ensure => 'directory',
  owner  => $user,
  group  => $user,
  path   => $user_src_dir,
}
->vcsrepo { 'clone vlc-qt into source dir' :
  ensure     => present,
  group      => $group,
  owner      => $user,
  path       => $vlc_qt_root,
  provider   => git,
  source     => 'https://github.com/vlc-qt/vlc-qt.git',
  submodules => true,
  user       => $user,
}


$compiler_and_cmake_flags_pairs = {
  'clang' => ' -DCMAKE_C_COMPILER=/usr/bin/clang -DCMAKE_CXX_COMPILER=/usr/bin/clang++ -DCMAKE_CXX_FLAGS="-stdlib=libc++" ',
  'gcc'   => '',
}

$compiler_and_cmake_flags_pairs.each | String $compiler, String $cmake_flags | {
  $build_dir   = "${vlc_qt_root}/${compiler}_build"
  $install_dir = "${user_src_dir}/vlc-qt-${compiler}"

  file { $build_dir:
    ensure  => 'directory',
    group   => $user,
    owner   => $user,
  }
  ->file { $install_dir:
    ensure => 'directory',
    group  => $user,
    owner  => $user,
  }
  ->exec { "cmake vlc-qt ${compiler}":
    command => "cmake -GNinja -B${build_dir} -H${vlc_qt_root} -DCMAKE_PREFIX_PATH=${qt_install_dir} -DCMAKE_INSTALL_PREFIX=${install_dir} ${cmake_flags}",
    creates => "${build_dir}/build.ninja",
    group   => $user,
    require => Package[ 'libvlc-dev', 'libvlccore-dev' ],
    user    => $user,
  }
  ->exec { "build vlc-qt ${compiler}":
    command => "ninja -j 8 -C ${build_dir}",
    creates => "${build_dir}/src/core/libVLCQtCore.so",
    group   => $user,
    timeout => 3600, # Defaults to 300s
    user    => $user,
  }
  ->exec { "install vlc-qt ${compiler}":
    command   => "ninja -j 2 -C ${build_dir} install",
    creates   => "${install_dir}/lib/libVLCQtCore.so",
    group     => $user,
    user      => $user,
    # logoutput => true,
  }
#   # See https://github.com/wang-bin/vlc-qt/issues/1121
#   ->file { "symlink vlc-qt CMake config-mode files ${compiler}":
#     ensure => "link",
#     group  => $user,
#     owner  => $user,
#     path   => "${install_dir}/lib/cmake/vlc-qt/vlc-qt-config.cmake",
#     target => "${install_dir}/lib/cmake/vlc-qt/vlc-qt-config.cmake",
#   }
}
