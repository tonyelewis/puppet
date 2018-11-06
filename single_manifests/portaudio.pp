# puppet apply --noop --test single_manifests/portaudio.pp
# puppet apply        --test single_manifests/portaudio.pp

$user           = 'lewis'
$group          = 'lewis'
$home_dir       = "/home/${user}"
$user_src_dir   = "${home_dir}/source"
$portaudio_root = "${user_src_dir}/portaudio-master"

Exec {
  path => [
    '/usr/bin',
    '/usr/sbin',
    '/bin',
    '/sbin',
  ]
}

file { "Source dir ${user_src_dir}":
  ensure => 'directory',
  owner  => $user,
  group  => $user,
  path   => $user_src_dir,
}
->vcsrepo { 'clone portaudio into source dir' :
  ensure     => present,
  group      => $group,
  owner      => $user,
  path       => $portaudio_root,
  provider   => git,
  source     => 'https://git.assembla.com/portaudio.git',
  submodules => true,
  user       => $user,
}


$compiler_and_cmake_flags_pairs = {
  'clang' => ' -DCMAKE_C_COMPILER=/usr/bin/clang -DCMAKE_CXX_COMPILER=/usr/bin/clang++ -DCMAKE_CXX_FLAGS="-stdlib=libc++" ',
  'gcc'   => '',
}

$compiler_and_cmake_flags_pairs.each | String $compiler, String $cmake_flags | {
  $build_dir   = "${portaudio_root}/${compiler}_build"
  $install_dir = "${user_src_dir}/portaudio-${compiler}"

  file { $build_dir:
    ensure  => 'directory',
    group   => $user,
    owner   => $user,
    require => Vcsrepo[ 'clone portaudio into source dir' ],
  }
  ->file { $install_dir:
    ensure => 'directory',
    group  => $user,
    owner  => $user,
  }
  ->exec { "cmake portaudio ${compiler}":
    command => "cmake -GNinja -B${build_dir} -H${portaudio_root} -DCMAKE_INSTALL_PREFIX=${install_dir} ${cmake_flags}",
    creates => "${build_dir}/build.ninja",
    group   => $user,
    user    => $user,
  }
  ->exec { "build portaudio ${compiler}":
    command => "ninja -j 3 -C ${build_dir}",
    creates => "${build_dir}/libportaudio.so",
    group   => $user,
    timeout => 3600, # Defaults to 300s
    user    => $user,
  }
  ->exec { "install portaudio ${compiler}":
    command   => "ninja -j 2 -C ${build_dir} install",
    creates   => "${install_dir}/lib/libportaudio.so",
    group     => $user,
    user      => $user,
    # logoutput => true,
  }
}
