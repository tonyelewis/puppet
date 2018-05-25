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

  $clang_version  = '6.0.0'
  $repos_root_dir = '/home/lewis'
  $repos_user     = 'lewis'
  $repos_group    = 'lewis'
  # $repos_root_dir = '/cath/homes2/ucbctnl'
  # $repos_user     = 'ucbctnl'
  # $repos_group    = 'users'
  $cath_tools_url   = 'git@github.com:UCLOrengoGroup/cath-tools.git'
  $tell_url         = 'git@github.com:tonyelewis/tell.git'

  $desktop_files_dir = '/usr/share/applications'

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
      'libncurses5-dev',      # For iwyu
      'ninja-build',          #
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

  exec { 'gcc_is_ready':
    command => '/bin/true'
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

    # You can check include directories with:
    #  * echo | /usr/bin/g++   -xc++ -v -fsyntax-only -
    #  * echo | /usr/bin/g++-8 -xc++ -v -fsyntax-only -
    #  * echo | /usr/bin/g++-7 -xc++ -v -fsyntax-only -
  }

  $clang_tar_base = "clang+llvm-${clang_version}-x86_64-linux-gnu-ubuntu-14.04.tar.xz"
  $clang_tar_file = "/opt/${clang_tar_base}"
  $clang_dir      = "/opt/clang+llvm-${clang_version}-x86_64-linux-gnu-ubuntu-14.04"
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

  $clang_bins = [ 'clang', 'clang++', 'clang-format', 'clang-include-fixer', 'clang-tidy', 'lldb', 'llvm-symbolizer', 'scan-build' ]
  $clang_bins.each | String $clang_bin | {
    alternative_entry { "/opt/clang+llvm-6.0.0-x86_64-linux-gnu-ubuntu-14.04/bin/${clang_bin}" :
      ensure   => present,
      altlink  => "/usr/bin/${clang_bin}",
      altname  => $clang_bin,
      priority => 100,
      require  => Exec[ 'Untar prebuilt Clang archive' ],
    }
  }
  # $libcpp_libs' = [ libc++.a', 'libc++.so', 'libc++.so.1', 'libc++.so.1.0', 'libc++abi.a', 'libc++abi.so', 'libc++abi.so.1', 'libc++abi.so.1.0' ]
  # /opt/clang+llvm-6.0.0-x86_64-linux-gnu-ubuntu-14.04/lib
  # /usr/lib/x86_64-linux-gnu
  #
  # $libclang_libs = [ 'libclang.so', 'libclang.so.6', 'libclang.so.6.0' ]
  # link
  # /opt/clang+llvm-6.0.0-x86_64-linux-gnu-ubuntu-14.04/lib/libclang.so
  # /opt/clang+llvm-6.0.0-x86_64-linux-gnu-ubuntu-14.04/lib/libclang.so.6
  # /opt/clang+llvm-6.0.0-x86_64-linux-gnu-ubuntu-14.04/lib/libclang.so.6.0

  # `sudo update-alternatives --install /usr/bin/clang               clang               /opt/clang+llvm-6.0.0-x86_64-linux-gnu-ubuntu-14.04/bin/clang                100`
  # `sudo update-alternatives --install /usr/bin/clang++             clang++             /opt/clang+llvm-6.0.0-x86_64-linux-gnu-ubuntu-14.04/bin/clang++              100`
  # `sudo update-alternatives --install /usr/bin/clang-format        clang-format        /opt/clang+llvm-6.0.0-x86_64-linux-gnu-ubuntu-14.04/bin/clang-format         100`
  # `sudo update-alternatives --install /usr/bin/clang-include-fixer clang-include-fixer /opt/clang+llvm-6.0.0-x86_64-linux-gnu-ubuntu-14.04/bin/clang-include-fixer  100`
  # `sudo update-alternatives --install /usr/bin/clang-tidy          clang-tidy          /opt/clang+llvm-6.0.0-x86_64-linux-gnu-ubuntu-14.04/bin/clang-tidy           100`
  # `sudo update-alternatives --install /usr/bin/lldb                lldb                /opt/clang+llvm-6.0.0-x86_64-linux-gnu-ubuntu-14.04/bin/lldb                 100`
  # `sudo update-alternatives --install /usr/bin/llvm-symbolizer     llvm-symbolizer     /opt/clang+llvm-6.0.0-x86_64-linux-gnu-ubuntu-14.04/bin/llvm-symbolizer      100`
  # `sudo update-alternatives --install /usr/bin/scan-build          scan-build          /opt/clang+llvm-6.0.0-x86_64-linux-gnu-ubuntu-14.04/bin/scan-build           100`
  #
  # `sudo update-alternatives --set                                  clang               /opt/clang+llvm-6.0.0-x86_64-linux-gnu-ubuntu-14.04/bin/clang               `
  # `sudo update-alternatives --set                                  clang++             /opt/clang+llvm-6.0.0-x86_64-linux-gnu-ubuntu-14.04/bin/clang++             `
  # `sudo update-alternatives --set                                  clang-format        /opt/clang+llvm-6.0.0-x86_64-linux-gnu-ubuntu-14.04/bin/clang-format        `
  # `sudo update-alternatives --set                                  clang-include-fixer /opt/clang+llvm-6.0.0-x86_64-linux-gnu-ubuntu-14.04/bin/clang-include-fixer `
  # `sudo update-alternatives --set                                  clang-tidy          /opt/clang+llvm-6.0.0-x86_64-linux-gnu-ubuntu-14.04/bin/clang-tidy          `
  # `sudo update-alternatives --set                                  lldb                /opt/clang+llvm-6.0.0-x86_64-linux-gnu-ubuntu-14.04/bin/lldb                `
  # `sudo update-alternatives --set                                  llvm-symbolizer     /opt/clang+llvm-6.0.0-x86_64-linux-gnu-ubuntu-14.04/bin/llvm-symbolizer     `
  # `sudo update-alternatives --set                                  scan-build          /opt/clang+llvm-6.0.0-x86_64-linux-gnu-ubuntu-14.04/bin/scan-build          `


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
#
#  file { 'Install eclipse.desktop shortcut' :
#    path    => "$desktop_files_dir/eclipse.desktop",
#    ensure  => 'present',
#    source  => 'puppet:///modules/cpp_devel/eclipse.desktop',
#    replace => 'yes',
#    mode    => '0644',
#  }
#
  file { 'Install ltfg_konsole.desktop shortcut' :
    ensure  => 'present',
    path    => "${desktop_files_dir}/ltfg_konsole.desktop",
    source  => 'puppet:///modules/cpp_devel/ltfg_konsole.desktop',
    replace => 'yes',
    mode    => '0644',
  }
#
#  file { 'put symlink to ltfg in the root directory' :
#    name   => '/ltfg',
#    ensure => 'link',
#    target => "${repos_root_dir}/ltfg",
#  }
#
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

  vcsrepo { "clone cath-tools git repository" :
    ensure   => present,
    path     => "${repos_root_dir}/cath-tools",
    provider => git,
    source   => $cath_tools_url,
    owner    => $repos_user,
    group    => $repos_group,
  }
  ->file { 'put symlink to cath-tools in the root directory' :
    ensure => 'link',
    name   => '/cath-tools',
    target => "${repos_root_dir}/cath-tools",
  }

  vcsrepo { 'clone tell git repository' :
    ensure   => present,
    path     => "${repos_root_dir}/tell",
    provider => git,
    source   => $tell_url,
    owner    => $repos_user,
    group    => $repos_group,
  }
  ->file { 'put symlink to tell in the root directory' :
    ensure => 'link',
    name   => '/tell',
    target => "${repos_root_dir}/tell",
  }

  # These cause warnings like:
  #
  #     warning: Scope(Git::Config[Set user Git config core.editor to vim]): Could not look up qualified variable '::git::package_manage'; class ::git has not been evaluated
  #
  # ...but the still seem to work
  git::config { 'Set user Git config core.editor to vim' :
    user  => $repos_user,
    scope => 'global',
    key   => 'core.editor',
    value => 'vim',
  }
  git::config { 'Set user Git config pager.diff to false' :
    user  => $repos_user,
    scope => 'global',
    key   => 'pager.diff',
    value => 'false',
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
  git::config { 'Set user Git config pull.ff to only to prevent it automatically doing non-fast-forward merges' :
    user  => $repos_user,
    scope => 'global',
    key   => 'pull.ff',
    value => 'only',
  }
}
