# == Class: boost
#
# Description of class boost here.
#
# === Parameters
#
# Document parameters here.
#
# [*sample_parameter*]
#   Explanation of what this parameter affects and what it defaults to.
#   e.g. "Specify one or more upstream ntp servers as an array."
#
# Prerequisites - ensure the use of this depends on the packages for the compiler and standard library:
#  * 'clang'
#  * 'libc++1'
#  * 'libc++-dev'
#  * 'g++'

define boost (
  $compiler,
  $boost_version,
  $cpp_standard = 'c++03',
) {
  # TODO Lower case $compiler
  case $compiler {
    'clang' : { $b2_compiler_flags = "toolset=clang cxxflags=\"-stdlib=libc++ -std=${cpp_standard}\" linkflags=\"-stdlib=libc++ -std=${cpp_standard}\"" }
    'gcc'   : { $b2_compiler_flags = "              cxxflags=\"               -std=${cpp_standard}\" linkflags=\"               -std=${cpp_standard}\"" }
    default : { fail("In Boost, do not recognise compiler \"${compiler}\"")                                                                               }
  }

  $known_boost_vns = [
    '1_58_0',
    '1_59_0',
    '1_60_0_b1',
    '1_60_0',
    '1_61_0_b1',
    '1_61_0',
    '1_62_0_b1',
    '1_62_0',
    '1_63_0_b1',
    '1_64_0_b2',
    '1_65_1',
    '1_66_0',
    '1_67_0',
    '1_68_0',
  ];
  if ! $boost_version in $known_boost_vns {
    fail(
      "The Boost module does yet handle versions not in list: "
      + join( $known_boost_vns, ',' )
      + " - please make it do so, so it can then handle your version \"${boost_version}\""
    )
  }
  $unique_string             = "UID:${compiler};${boost_version};${cpp_standard}"

# $boost_version_underscores = '1_58_0'
# $boost_version_periods     = '1.58.0'
# $boost_version_underscores = '1_59_0'
# $boost_version_periods     = '1.59.0'
# $boost_version_underscores = '1_60_0_b1'
# $boost_version_periods     = '1.60.0.beta.1'
# $boost_version_underscores = '1_60_0'
# $boost_version_periods     = '1.60.0'
# $boost_version_underscores = '1_61_0_b1'
# $boost_version_periods     = '1.61.0.beta.1'
# $boost_version_underscores = '1_61_0'
# $boost_version_periods     = '1.61.0'
# $boost_version_underscores = '1_62_0_b1'
# $boost_version_periods     = '1.62.0.beta.1'
# $boost_version_underscores = '1_62_0'
# $boost_version_periods     = '1.62.0'
# $boost_version_underscores = '1_63_0_b1'
# $boost_version_periods     = '1.63.0.beta.1'
# $boost_version_underscores = '1_64_0_b2'
# $boost_version_periods     = '1.64.0.beta.2'
# $boost_version_underscores = '1_65_1'
# $boost_version_periods     = '1.65.1'
# $boost_version_underscores = '1_66_0'
# $boost_version_periods     = '1.66.0'
# $boost_version_underscores = '1_67_0'
# $boost_version_periods     = '1.67.0'
  $boost_version_underscores = '1_68_0'
  $boost_version_periods     = '1.68.0'
  $root_dir                  = '/opt'
  $archive_file              = "${root_dir}/boost_${boost_version_underscores}.tar.gz"
  $working_dir               = "${root_dir}/boost_${boost_version_underscores}_${compiler}_${cpp_standard}"
  $build_name                = "boost_${boost_version_underscores}_${compiler}_${cpp_standard}_build"
  $build_dir                 = "${root_dir}/${$build_name}"

  File {
    owner => 'root',
    group => 'root',
  }

  Exec {
    environment => [
      'EXPAT_INCLUDE=/usr/include',
      'EXPAT_LIBPATH=/usr/lib'
    ],
  }

  # Set a sensible path so that binaries' paths don't have to be fully qualified
  Exec {
    path => [
      '/usr/bin',
      '/usr/sbin',
      '/bin',
      '/sbin'
    ]
  }

  include boost::packages

  # Download the source archive (.tar.gz) file
  boost::download_file { "Download Boost archive ${unique_string}" :
    require       => Exec[ 'gcc_is_ready' ],
    #uri           => "http://downloads.sourceforge.net/project/boost/boost/${boost_version_periods}/boost_${boost_version_underscores}.tar.gz",
    uri           => "https://downloads.sourceforge.net/project/boost/boost/${boost_version_periods}/boost_${boost_version_underscores}.tar.gz",
    #uri           => "https://dl.bintray.com/boostorg/release/${boost_version_periods}/source/boost_${boost_version_underscores}.tar.gz",
    target        => $archive_file,
    unique_suffix => " ${unique_string}",
  }

  # Ensure the working directory exists
  ->file { "Make Boost working directory ${unique_string}" :
    ensure => 'directory',
    path   => $working_dir,
    owner  => 'root',
  }

  # Untar the Boost archive file into the working directory
  ->exec { "Untar Boost archive ${unique_string}" :
    command => "tar -zxvf ${archive_file} --directory ${working_dir} --strip-components=1",
    #creates => "${working_dir}/tools/regression/xsl_reports/xsl/v2/summary_page.xsl",
    creates => "${working_dir}/boost/cast.hpp",
  }

  # Chmod the Boost directory to make everything readable and directories excecutable for all
  #
  # This should be uncommented but Puppet doesn't like it because it has the same
  # path as above. Not sure how to resolve.
  #                                                                [December 2016]
#  ->file { "Make Boost working directory readable & directory-executable by all ${unique_string}" :
#    path    => $working_dir,
#    ensure  => 'directory',
#    owner   => 'root',
#    mode    => 'a+rX',
#    recurse => 'true',
#  }

  # Ensure the build directory exists
  ->file { $build_dir :
    ensure => 'directory'
  }

  # Run Boost's bootstrap
  ->exec { "bootstrap boost ${unique_string}" :
    command     =>   "bootstrap.sh --prefix=${build_dir}",
    #command     =>   "bootstrap.sh --prefix=${build_dir} --without-libraries=fiber",
    cwd         =>   $working_dir,
    path        => [
      $working_dir,
      '/usr/bin',
      '/bin',
    ],
    creates     => "${working_dir}/b2",
    environment => [
      'EXPAT_INCLUDE=/usr/include',
      'EXPAT_LIBPATH=/usr/lib'
    ],
    require     => Class[ boost::packages ],
  }

  # dll-path is important to put the location to find dependent libraries in each library, which is more
  # important as `RPATH` is becoming more widely deprecated
  #
  # On an ELF platform (ie Linux), the loader finds the library by looking through a series of paths in this order:
  # * The `RPATH` built into the ELF executable / shared-library
  # * the `LD_LIBRARY_PATH`
  # * The `RUNPATH` built into the ELF executable / shared-library
  #
  # `RUNPATH` was added a replacement for `RPATH` because it was thought to be a mistake to not have `LD_LIBRARY_PATH` overriding `RPATH`.
  #
  # However `RUNPATH` also behaves slightly differently in that the loader only uses it to find *direct* dependencies,
  # not *transitive* dependencies (as happens with `RPATH`).
  #
  # As link commands are becoming more likely to use RUNPATH, it's becoming more important that shared (`.so`) libraries
  # have a suitable `RPATH` / `RUNPATH` to locate their own dependent libraries.
  #
  #
  # Some useful notes...
  #
  # To tell the linker to write `RPATH`, not `RUNPATH`, use `-Wl,--disable-new-dtags`
  #
  # To post-hoc fix a bunch of Boost shared libraries, use a command like
  # ~~~
  # find . -type f -name '*.so*' | xargs -I VAR patchelf --set-rpath /opt/boost_1_68_0_gcc_c++14_build/lib VAR
  # ~~~
  #
  # There's a helpful explanation (particularly comment #5) [here](https://bugs.launchpad.net/ubuntu/+source/eglibc/+bug/1253638)
  #
  # Commands that can help to diagnose these issues:
  # * `LD_DEBUG=libs ldd the_binary`
  # * `readelf -d the_binary`
  ->boost::boost_b2 { "build debug boost ${unique_string}" :
    command     => "b2 -j2         ${b2_compiler_flags} --layout=tagged variant=debug   dll-path=${build_dir}/lib define=_GLIBCXX_DEBUG ",
    working_dir => $working_dir,
    creates     => [
      "${working_dir}/stage/lib/libboost_wave-mt-d.a",
      "${working_dir}/stage/lib/libboost_python-mt-d.a",
    ],
  }
  ->boost::boost_b2 { "build release boost ${unique_string}" :
    command     => "b2 -j2         ${b2_compiler_flags} --layout=tagged variant=release dll-path=${build_dir}/lib ",
    working_dir => $working_dir,
    creates     => [
      "${working_dir}/stage/lib/libboost_wave-mt.a",
      "${working_dir}/stage/lib/libboost_python-mt.a",
    ],
  }
  ->boost::boost_b2 { "install debug boost ${unique_string}" :
    command     => "b2 -j2 install ${b2_compiler_flags} --layout=tagged variant=debug   dll-path=${build_dir}/lib define=_GLIBCXX_DEBUG ",
    working_dir => $working_dir,
    creates     => [
      "${build_dir}/lib/libboost_wave-mt-d.a",
      "${build_dir}//lib/libboost_python-mt-d.a",
    ],
  }
  ->boost::boost_b2 { "install release boost ${unique_string}" :
    command     => "b2 -j2 install ${b2_compiler_flags} --layout=tagged variant=release dll-path=${build_dir}/lib ",
    working_dir => $working_dir,
    creates     => [
      "${build_dir}/lib/libboost_wave-mt.a",
      "${build_dir}//lib/libboost_python-mt.a",
    ],
  }

  if $compiler != 'gcc' {
    file { "/opt/include ${unique_string}" :
        ensure => 'link',
        path   => '/opt/include',
        target => "${build_name}/include",
        owner  => 'root',
        group  => 'root',
    }
  }
}



######################################################################

# 'java-1.7.0-openjdk',     # For Jenkins
# 'jenkins',

# service{ 'jenkins' :
# 	ensure  => 'running',
# 	enable  => 'true',
# 	require => Package[ 'jenkins', 'java-1.7.0-openjdk' ],
# }->
# exec{ 'open-port-8080-for-jenkins' :
# 	command     => 'firewall-cmd --zone=public --add-port=8080/tcp --permanent',
# 	refreshonly => 'true',
# }->
# exec{ 'open-http-for-jenkins' :
# 	command     => 'firewall-cmd --zone=public --add-service=http --permanent',
# 	refreshonly => 'true',
# }->
# exec{ 'reload-firewall-for-jenkins' :
# 	command     => 'firewall-cmd --reload',
# 	refreshonly => 'true',
  # }
