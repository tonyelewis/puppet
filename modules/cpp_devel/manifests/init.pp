# == Class: cpp_devel
#
# Description of class cpp_devel here.
#
# === Parameters
#
# Document parameters here.
#
# [*sample_parameter*]
#   Explanation of what this parameter affects and what it defaults to.
#   e.g. "Specify one or more upstream ntp servers as an array."
#
# === Variables
#
# Here you should define a list of variables that this module would require.
#
# [*sample_variable*]
#   Explanation of how this variable affects the function of this class and if
#   it has a default. e.g. "The parameter enc_ntp_servers must be set by the
#   External Node Classifier as a comma separated list of hostnames." (Note,
#   global variables should be avoided in favour of class parameters as
#   of Puppet 2.6.)

class cpp_devel {
  include git

  $clang_major_version  = '9'
  $clang_version        = "${$clang_major_version}.0.0"
  $repos_root_dir       = '/home/lewis'
  $repos_user           = 'lewis'
  $repos_group          = 'lewis'
  $user                 = 'lewis'
  # $repos_root_dir       = '/cath/homes2/ucbctnl'
  # $repos_user           = 'ucbctnl'
  # $repos_group          = 'users'
  $cath_tools_url         = 'git@github.com:UCLOrengoGroup/cath-tools.git'
  $gen_cmake_list_url     = 'git@github.com:tonyelewis/gen_cmake_list.git'
  $tell_url               = 'git@github.com:tonyelewis/tell.git'

  $desktop_files_dir       = '/usr/share/applications'

  File {
    owner => 'root',
    group => 'root',
  }

  # C++ Development
  package {
    [
      'cimg-dev',             # Currently required by LTFG code - can this be dropped for Boost Image Library?
      #'clang',                #
      # 'clang-format-3.6',    #
      #'clang-format',         #
      #'clang-tidy',           #
      'cmake',                #
      'doxygen',              #
      'doxygen-doc',          #
      'g++',                  #
      'kcachegrind',          #
      #'libc++1',              #
      #'libc++-dev',           #
      #'libc++abi-dev',        #
      #'libc6-dev-i386',       #
      #'libclang-dev',         # For iwyu
      'libgsl-dev',           # For cath-tools
      'libncurses5-dev',      # For iwyu
      'ninja-build',          #
      'python3-pip',          #
      # 'ninja-build-doc',     # Does not seem to exist in 16.10
      # 'nvidia-cuda-toolkit', # Commented out whilst using nvidia runfile for 8.0 (~/source/cuda_8.0.44_linux.bin)
      'valgrind',             #
      'zlib1g-dev',           # For iwyu
    ]:
    ensure => 'latest'
  }
  # # Seems to be required for in Ubuntu 16.04 (3.8.0-2ubuntu4)
  # file { 'put symlink to __cxxabi_config.h in the standard include directory' :
  #   name   => '/usr/include/c++/v1/__cxxabi_config.h',
  #   ensure => 'link',
  #   target => "/usr/include/libcxxabi/__cxxabi_config.h",
  # }

  # file { 'Download CMake FindBoost file':
  #   ensure  => file,
  #   mode    => 'a+r',
  #   path    => '/usr/share/cmake-3.10/Modules/FindBoost.cmake',
  #   replace => false,
  #   source  => 'https://raw.githubusercontent.com/Kitware/CMake/master/Modules/FindBoost.cmake',
  # }

  package { ['conan']:
    ensure => present,
    provider => pip3,
    require => Package['python3-pip'],
  }
  ->

  exec { 'gcc_is_ready':
    command     => '/bin/true',
    refreshonly => true,
  }
  if ( $::operatingsystem == 'Ubuntu' and $::operatingsystemmajrelease == '18.04' ) {
    package {
      [
        'g++-8',
        'gcc-8',
      ]:
      ensure  => 'latest',
      require => Package[ 'g++' ],
    }

    $gcc_bins = [ 'gcc', 'g++' ]
    $gcc_bins.each | String $gcc_bin | {
      alternative_entry { "/usr/bin/${gcc_bin}-8" :
        ensure   => present,
        altlink  => "/usr/bin/${gcc_bin}",
        altname  => $gcc_bin,
        priority => 100,
        require  => [ Package[ 'g++-8' ], Package[ 'gcc-8' ] ],
        before   => Exec[ 'gcc_is_ready' ],
      }
    }

    # sudo update-alternatives --set gcc /usr/bin/gcc-8
    # sudo update-alternatives --set g++ /usr/bin/g++-8

    # You can check include directories with:
    #  * echo | /usr/bin/g++   -xc++ -v -fsyntax-only -
    #  * echo | /usr/bin/g++-8 -xc++ -v -fsyntax-only -
    #  * echo | /usr/bin/g++-7 -xc++ -v -fsyntax-only -
  }

  # As of 19th March 2020, having to hack the following to get /opt/clang+llvm-9.0.0-x86_64-pc-linux-gnu/bin/clang++ to work on Ubuntu 19.10
  #
  #     sudo apt-get install libz3-4
  #     sudo ln -s libz3.so.4 /usr/lib/x86_64-linux-gnu/libz3.so.4.8
  #
  # Perhaps this is a good indication that it'd be better to move to building the latest release (as well as master) instead of downloading binaries

  # $clang_base_stem = "clang+llvm-${clang_version}-x86_64-linux-gnu-ubuntu-14.04"
  # $clang_base_stem = "clang+llvm-${clang_version}-x86_64-linux-gnu-ubuntu-16.04"
  # $clang_base_stem = "clang+llvm-${clang_version}-x86_64-linux-sles12.3"
  $clang_base_stem = $::operatingsystemmajrelease ? {
    '18.04' => "clang+llvm-${clang_version}-x86_64-linux-gnu-ubuntu-18.04",
    default => "clang+llvm-${clang_version}-x86_64-pc-linux-gnu",
  }

  $clang_tar_base  = "${clang_base_stem}.tar.xz"
  $clang_tar_file  = "/opt/${clang_tar_base}"
  $clang_dir       = "/opt/${clang_base_stem}"
  file { 'Download prebuilt Clang archive':
    ensure  => file,
    mode    => 'a+r',
    path    => $clang_tar_file,
    replace => false,
    source  => "http://releases.llvm.org/${clang_version}/${clang_tar_base}",
  }
  ->file { 'Create directory into which to untar prebuilt Clang' :
    ensure => 'directory',
    path   => $clang_dir,
  }
  ->exec { 'Untar prebuilt Clang archive' :
    command => "tar -Jxvf ${clang_tar_file} --directory ${clang_dir} --strip-components=1",
    creates => "${clang_dir}/bin/clang-tidy",
    path    => [ '/bin', '/usr/bin' ], # Needs /bin for tar and /usr/bin/ for child process xz
  }

  $clang_bins = [ 'clang', 'clang++', 'clang-format', 'clang-include-fixer', 'clang-tidy', 'llvm-symbolizer', 'scan-build' ]
  $clang_bins.each | String $clang_bin | {
    alternative_entry { "/opt/${clang_base_stem}/bin/${clang_bin}" :
      ensure   => present,
      altlink  => "/usr/bin/${clang_bin}",
      altname  => $clang_bin,
      priority => 100,
      require  => Exec[ 'Untar prebuilt Clang archive' ],
    }
  }

  # sudo update-alternatives --set clang++             /opt/clang+llvm-9.0.0-x86_64-linux-gnu-ubuntu-18.04/bin/clang++
  # sudo update-alternatives --set clang-format        /opt/clang+llvm-9.0.0-x86_64-linux-gnu-ubuntu-18.04/bin/clang-format
  # sudo update-alternatives --set clang-include-fixer /opt/clang+llvm-9.0.0-x86_64-linux-gnu-ubuntu-18.04/bin/clang-include-fixer
  # sudo update-alternatives --set clang-tidy          /opt/clang+llvm-9.0.0-x86_64-linux-gnu-ubuntu-18.04/bin/clang-tidy
  # sudo update-alternatives --set clang               /opt/clang+llvm-9.0.0-x86_64-linux-gnu-ubuntu-18.04/bin/clang
  # sudo update-alternatives --set llvm-symbolizer     /opt/clang+llvm-9.0.0-x86_64-linux-gnu-ubuntu-18.04/bin/llvm-symbolizer
  # sudo update-alternatives --set scan-build          /opt/clang+llvm-9.0.0-x86_64-linux-gnu-ubuntu-18.04/bin/scan-build

  # sudo update-alternatives --set clang++             /opt/clang+llvm-9.0.0-x86_64-pc-linux-gnu/bin/clang++
  # sudo update-alternatives --set clang-format        /opt/clang+llvm-9.0.0-x86_64-pc-linux-gnu/bin/clang-format
  # sudo update-alternatives --set clang-include-fixer /opt/clang+llvm-9.0.0-x86_64-pc-linux-gnu/bin/clang-include-fixer
  # sudo update-alternatives --set clang-tidy          /opt/clang+llvm-9.0.0-x86_64-pc-linux-gnu/bin/clang-tidy
  # sudo update-alternatives --set clang               /opt/clang+llvm-9.0.0-x86_64-pc-linux-gnu/bin/clang
  # sudo update-alternatives --set llvm-symbolizer     /opt/clang+llvm-9.0.0-x86_64-pc-linux-gnu/bin/llvm-symbolizer
  # sudo update-alternatives --set scan-build          /opt/clang+llvm-9.0.0-x86_64-pc-linux-gnu/bin/scan-build

  # Use to hack this by copying clang libraries into /usr/lib/x86_64-linux-gnu but that's a bad idea.
  # It's much better to use toolchain settings that tell the compiler where to find these libraries.
  # Eg -Wl,-rpath=/opt/clang+llvm-9.0.0-x86_64-pc-linux-gnu/lib
  #
  # $libcpp_libs = [
  #   'libc++.a',    'libc++.so',    'libc++.so.1',    'libc++.so.1.0',
  #   'libc++abi.a', 'libc++abi.so', 'libc++abi.so.1', 'libc++abi.so.1.0'
  # ]
  # $libcpp_libs.each | String $libcpp_lib | {
  #   file{ "Copy lib ${libcpp_lib} from clang into system lib directory" :
  #     ensure  => present,
  #     mode    => 'a+r',
  #     path    => "/usr/lib/x86_64-linux-gnu/${libcpp_lib}",
  #     replace => false,
  #     require => Exec[ 'Untar prebuilt Clang archive' ],
  #     source  => "/opt/${clang_base_stem}/lib/${libcpp_lib}",
  #   }
  # }
  #
  # $libclang_libs = [ 'libclang.so', "libclang.so.${clang_major_version}", "libclang.so.${clang_major_version}.0" ]
  # $libclang_libs.each | String $libclang_lib | {
  #   file{ "Link to lib ${libclang_lib} in system lib directory" :
  #     ensure => 'link',
  #     path   =>  "/usr/lib/${libclang_lib}",
  #     target => "/opt/${clang_base_stem}/lib/${libclang_lib}",
  #   }
  # }

  # Seems to be required for in Ubuntu 17.10 (package libc++-dev 3.9.1-3)
  # Demonstrable with : `echo '#include <locale>' | clang++ -stdlib=libc++ -c -x c++ -`
  # See https://www.mail-archive.com/ubuntu-bugs@lists.ubuntu.com/msg5274201.html
  #
  # TODO: Come Ubuntu 18.04, check if this is still necessary and remove if possible
  # file { 'put symlink to locale.h called xlocale.h in the standard include directory' :
  #   name   => '/usr/include/xlocale.h',
  #   ensure => 'link',
  #   target => "/usr/include/locale.h",
  # }

  file { 'Install cath-tools_konsole.desktop shortcut' :
    ensure  => 'present',
    path    => "${desktop_files_dir}/cath-tools_konsole.desktop",
    source  => 'puppet:///modules/cpp_devel/cath-tools_konsole.desktop',
    replace => 'yes',
    mode    => '0644',
  }

#  file { 'Install eclipse.desktop shortcut' :
#    path    => "$desktop_files_dir/eclipse.desktop",
#    ensure  => 'present',
#    source  => 'puppet:///modules/cpp_devel/eclipse.desktop',
#    replace => 'yes',
#    mode    => '0644',
#  }
#

  vcsrepo { 'clone ltfg git repository' :
    ensure   => present,
    path     => "${repos_root_dir}/ltfg",
    provider => git,
    source   => 'ssh://gituser@192.168.178.4/volume1/homes/gituser/ltfg.git',
    owner    => $repos_user,
    user     => $repos_user,
    group    => $repos_group,
  }
  ->file { 'put symlink to ltfg in the root directory' :
    ensure => 'link',
    name   => '/ltfg',
    target => "${repos_root_dir}/ltfg",
  }
  ->file { 'Install ltfg_konsole.desktop shortcut' :
    ensure  => 'present',
    path    => "${desktop_files_dir}/ltfg_konsole.desktop",
    source  => 'puppet:///modules/cpp_devel/ltfg_konsole.desktop',
    replace => 'yes',
    mode    => '0644',
  }

#  vcsrepo { 'Checkout immediates of svn repo' :
#    ensure   => present,
#    provider => svn,
#    source   => 'svn://192.168.0.32/',
#    path     => '/home/lewis/svn',
#    depth    => 'immediates',
#    owner    => $repos_user,
#    group    => $repos_group,
#  }->
#  vcsrepo { 'Checkout latest of config' :
#    ensure   => latest,
#    provider => svn,
#    source   => 'svn://192.168.0.32/config',
#    path     => '/home/lewis/svn/config',
#    depth    => 'infinity',
#    owner    => $repos_user,
#    group    => $repos_group,
#  }->
#  vcsrepo { 'Checkout latest of cpan' :
#    ensure   => latest,
#    provider => svn,
#    source   => 'svn://192.168.0.32/cpan',
#    path     => '/home/lewis/svn/cpan',
#    depth    => 'infinity',
#    owner    => $repos_user,
#    group    => $repos_group,
#  }->
#  vcsrepo { 'Checkout latest of tools' :
#    ensure   => latest,
#    provider => svn,
#    source   => 'svn://192.168.0.32/tools',
#    path     => '/home/lewis/svn/tools',
#    depth    => 'infinity',
#    owner    => $repos_user,
#    group    => $repos_group,
#  }->
#  vcsrepo { 'Checkout latest of writing' :
#    ensure   => latest,
#    provider => svn,
#    source   => 'svn://192.168.0.32/writing',
#    path     => '/home/lewis/svn/writing',
#    depth    => 'infinity',
#    owner    => $repos_user,
#    group    => $repos_group,
#  }
#  # This doesn't seem to chown all files to the correct user, so (as root) run: chown -R lewis:lewis ~lewis/svn

  vcsrepo { 'clone cath-tools git repository' :
    ensure   => present,
    path     => "${repos_root_dir}/cath-tools",
    provider => git,
    source   => $cath_tools_url,
    owner    => $repos_user,
    group    => $repos_group,
    user     => $repos_user,
  }
  ->file { 'put symlink to cath-tools in the root directory' :
    ensure => 'link',
    name   => '/cath-tools',
    target => "${repos_root_dir}/cath-tools",
  }

  vcsrepo { 'clone gen_cmake_list git repository' :
    ensure   => present,
    path     => "${repos_root_dir}/gen_cmake_list",
    provider => git,
    source   => $gen_cmake_list_url,
    owner    => $repos_user,
    group    => $repos_group,
    user     => $repos_user,
  }
  $gen_cmake_list_bins = [ 'extract-cmake-flags.py', 'gen_cmake_list.py' ]
  $gen_cmake_list_bins.each | String $gen_cmake_list_bin | {
    file { "symlink ${repos_root_dir}/${gen_cmake_list_bin}" :
      ensure   => 'link',
      group    => $repos_group,
      name     => "${repos_root_dir}/bin/${gen_cmake_list_bin}",
      owner    => $repos_user,
      require  => [ File[ 'create_user_bin_dir' ], Vcsrepo[ 'clone gen_cmake_list git repository' ] ],
      target   => "${repos_root_dir}/gen_cmake_list/${gen_cmake_list_bin}",
    }
  }

  vcsrepo { 'clone tell git repository' :
    ensure   => present,
    path     => "${repos_root_dir}/tell",
    provider => git,
    source   => $tell_url,
    owner    => $repos_user,
    group    => $repos_group,
    user     => $repos_user,
  }
  ->file { 'put symlink to tell in the root directory' :
    ensure => 'link',
    name   => '/tell',
    target => "${repos_root_dir}/tell",
  }

  file { 'Install .gitignore_global file' :
    ensure  => 'present',
    group  => $repos_group,
    mode    => '0644',
    owner  => $user,
    path    => "${$repos_root_dir}/.gitignore_global",
    replace => 'yes',
    source  => 'puppet:///modules/cpp_devel/dot_gitignore_global',
  }
  ->git::config { 'Set user global Git ignore file to ~/.gitignore_global' :
    key   => 'core.excludesfile',
    scope => 'global',
    user  => $repos_user,
    value => "${$repos_root_dir}/.gitignore_global",
  }

  git::config { 'Set user Git config core.editor to vim' :
    user  => $repos_user,
    scope => 'global',
    key   => 'core.editor',
    value => 'vim',
  }
  git::config { 'Set user Git config pager.branch to false' :
    user  => $repos_user,
    scope => 'global',
    key   => 'pager.branch',
    value => 'false', # This 'false' should be kept as a string, not changed to the Puppet value false
  }
  git::config { 'Set user Git config pager.diff to false' :
    user  => $repos_user,
    scope => 'global',
    key   => 'pager.diff',
    value => 'false', # This 'false' should be kept as a string, not changed to the Puppet value false
  }
  git::config { 'Set user Git config pager.stash to false' :
    user  => $repos_user,
    scope => 'global',
    key   => 'pager.stash',
    value => 'false', # This 'false' should be kept as a string, not changed to the Puppet value false
  }
  git::config { 'Set user Git config alias.st to status --column' :
    user  => $repos_user,
    scope => 'global',
    key   => 'alias.st',
    value => 'status --column',
  }
  git::config { 'Set user Git config alias.sts to status -s' :
    user  => $repos_user,
    scope => 'global',
    key   => 'alias.sts',
    value => 'status -s',
  }
  git::config { 'Set user Git config alias.ls-modified to diff --name-only' :
    user  => $repos_user,
    scope => 'global',
    key   => 'alias.ls-modified',
    value => 'diff --name-only', # Could use 'ls-files -m' which has the advantage of giving filenames relative to the cwd but use diff --name-only here for consistency
  }
  git::config { 'Set user Git config alias.ls-cached to diff --name-only --cached' :
    user  => $repos_user,
    scope => 'global',
    key   => 'alias.ls-cached',
    value => 'diff --name-only --cached',
  }
  git::config { 'Set user Git config alias.ls-head to diff --name-only HEAD' :
    user  => $repos_user,
    scope => 'global',
    key   => 'alias.ls-head',
    value => 'diff --name-only HEAD',
  }
  git::config { 'Set user Git config alias.di to diff' :
    user  => $repos_user,
    scope => 'global',
    key   => 'alias.di',
    value => 'diff',
  }
  git::config { 'Set user Git config alias.ci to commit' :
    user  => $repos_user,
    scope => 'global',
    key   => 'alias.ci',
    value => 'commit',
  }
  git::config { 'Set user Git config alias.praise to blame' :
    user  => $repos_user,
    scope => 'global',
    key   => 'alias.praise',
    value => 'blame',
  }
  git::config { 'Set user Git config alias.hist to nice history command' :
    user  => $repos_user,
    scope => 'global',
    key   => 'alias.hist',
    value => 'log --pretty=format:"%h %ad | %s%d [%an]" --graph --date=short',
  }
  git::config { 'Set user Git remote branch color' :
    user  => $repos_user,
    scope => 'global',
    key   => 'color.branch.remote',
    value => 'red bold',
  }
  git::config { 'Set user Git upstream branch color' :
    user  => $repos_user,
    scope => 'global',
    key   => 'color.branch.upstream',
    value => 'blue bold',
  }
  git::config { 'Set user Git added status color' :
    user  => $repos_user,
    scope => 'global',
    key   => 'color.status.added',
    value => 'green bold',
  }
  git::config { 'Set user Git changed status color' :
    user  => $repos_user,
    scope => 'global',
    key   => 'color.status.changed',
    value => 'red bold',
  }
  git::config { 'Set user Git nobranch status color' :
    user  => $repos_user,
    scope => 'global',
    key   => 'color.status.nobranch',
    value => 'red bold',
  }
  git::config { 'Set user Git untracked status color' :
    user  => $repos_user,
    scope => 'global',
    key   => 'color.status.untracked',
    value => 'red bold',
  }
  git::config { 'Set user Git config pull.ff to only to prevent it automatically doing non-fast-forward merges' :
    user  => $repos_user,
    scope => 'global',
    key   => 'pull.ff',
    value => 'only',
  }
}
