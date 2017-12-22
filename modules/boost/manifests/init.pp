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
#   $boost_version = '1_58_0',
#   $boost_version = '1_59_0',
#   $boost_version = '1_60_0_b1',
#   $boost_version = '1_60_0',
#   $boost_version = '1_61_0_b1',
#   $boost_version = '1_61_0',
#   $boost_version = '1_62_0_b1',
#   $boost_version = '1_62_0',
#   $boost_version = '1_63_0_b1',
#   $boost_version = '1_63_0',
#   $boost_version = '1_64_0_b2',
#   $boost_version = '1_64_0',
#   $boost_version = '1_65_1',
    $boost_version = '1_66_0',
    $cpp_standard  = 'c++03',
) {
  
  # TODO Lower case $compiler
  case $compiler {
    'clang' : { $b2_compiler_flags = "toolset=clang cxxflags=\"-stdlib=libc++ -std=${cpp_standard}\" linkflags=\"-stdlib=libc++ -std=${cpp_standard}\"" }
    'gcc'   : { $b2_compiler_flags = "              cxxflags=\"               -std=${cpp_standard}\" linkflags=\"               -std=${cpp_standard}\"" }
    default : { fail("In Boost, do not recognise compiler \"$compiler\"")                                                                               }
  }

  if $boost_version != '1_58_0'    and
     $boost_version != '1_59_0'    and
     $boost_version != '1_60_0_b1' and
     $boost_version != '1_60_0'    and
     $boost_version != '1_61_0_b1' and
     $boost_version != '1_61_0'    and
     $boost_version != '1_62_0_b1' and
     $boost_version != '1_62_0'    and
     $boost_version != '1_63_0_b1' and
     $boost_version != '1_64_0_b2' and
     $boost_version != '1_65_1'    and
     $boost_version != '1_66_0' {
    fail( "The Boost module does yet handle versions other than 1_58_0, 1_59_0, 1_60_0_b1, 1_60_0, 1_61_0_b1, 1_61_0, 1_62_0_b1, 1_62_0, 1_63_0_b1, 1_64_0_b2, 1_65_1 and 1_66_0 yet - please make it do so, so it can then handle your version \"${boost_version}\"" )
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
  $boost_version_underscores = '1_66_0'
  $boost_version_periods     = '1.66.0'
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
    #uri           => "http://downloads.sourceforge.net/project/boost/boost/${boost_version_periods}/boost_${boost_version_underscores}.tar.gz",
    uri           => "https://downloads.sourceforge.net/project/boost/boost/${boost_version_periods}/boost_${boost_version_underscores}.tar.gz",
    #uri           => "https://dl.bintray.com/boostorg/release/${boost_version_periods}/source/boost_${boost_version_underscores}.tar.gz",
    target        => $archive_file,
    unique_suffix => " ${unique_string}"
  }->

  # Ensure the working directory exists
  file { "Make Boost working directory $unique_string" :
    path    => $working_dir,
    ensure  => 'directory',
    owner   => 'root',
  }->

  # Untar the Boost archive file into the working directory
  exec { "Untar Boost archive $unique_string" :
    command => "tar -zxvf ${archive_file} --directory ${working_dir} --strip-components=1",
    #creates => "${working_dir}/tools/regression/xsl_reports/xsl/v2/summary_page.xsl",
    creates => "${working_dir}/boost/cast.hpp",
  }->

  # Chmod the Boost directory to make everything readable and directories excecutable for all
  #
  # This should be uncommented but Puppet doesn't like it because it has the same
  # path as above. Not sure how to resolve.
  #                                                                [December 2016]
#  file { "Make Boost working directory readable & directory-executable by all $unique_string" :
#    path    => $working_dir,
#    ensure  => 'directory',
#    owner   => 'root',
#    mode    => 'a+rX',
#    recurse => 'true',
#  }->

  # Ensure the build directory exists
  file { "${build_dir}" :
    ensure => 'directory'
  }->

  # Run Boost's bootstrap
  exec { "bootstrap boost $unique_string" :
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
  }->
  boost::boost_b2 { "build debug boost $unique_string" :
    command     => "b2 -j2         ${b2_compiler_flags} --layout=tagged variant=debug   define=_GLIBCXX_DEBUG",
    working_dir => $working_dir,
    creates     => [
      "${working_dir}/stage/lib/libboost_wave-mt-d.a",
      "${working_dir}/stage/lib/libboost_python-mt-d.a",
    ],
  }->
  boost::boost_b2 { "build release boost $unique_string" :
    command     => "b2 -j2         ${b2_compiler_flags} --layout=tagged variant=release",
    working_dir => $working_dir,
    creates     => [
      "${working_dir}/stage/lib/libboost_wave-mt.a",
      "${working_dir}/stage/lib/libboost_python-mt.a",
    ],
  }->
  boost::boost_b2 { "install debug boost $unique_string" :
    command     => "b2 -j2 install ${b2_compiler_flags} --layout=tagged variant=debug   define=_GLIBCXX_DEBUG",
    working_dir => $working_dir,
    creates     => [
      "${build_dir}/lib/libboost_wave-mt-d.a",
      "${build_dir}//lib/libboost_python-mt-d.a",
    ],
  }->
  boost::boost_b2 { "install release boost $unique_string" :
    command     => "b2 -j2 install ${b2_compiler_flags} --layout=tagged variant=release",
    working_dir => $working_dir,
    creates     => [
      "${build_dir}/lib/libboost_wave-mt.a",
      "${build_dir}//lib/libboost_python-mt.a",
    ],
  }

  if $compiler != 'gcc' {
    file { "/opt/include $unique_string" :
        path   => '/opt/include',
        ensure => 'link',
        target => "$build_name/include",
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
