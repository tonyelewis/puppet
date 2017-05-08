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
#   Explanation of how this variable affects the funtion of this class and if
#   it has a default. e.g. "The parameter enc_ntp_servers must be set by the
#   External Node Classifier as a comma separated list of hostnames." (Note,
#   global variables should be avoided in favor of class parameters as
#   of Puppet 2.6.)

class cpp_devel {

  $repos_root_dir = '/home/lewis'
  $repos_user     = 'lewis'
  $repos_group    = 'lewis'
#  $repos_root_dir = '/cath/homes2/ucbctnl'
#  $repos_user     = 'ucbctnl'
#  $repos_group    = 'users'
  $cath_tools_url = 'https://github.com/UCLOrengoGroup/cath-tools.git'
  
  $desktop_files_dir = '/usr/share/applications'
  
  File {
    owner => 'root',
    group => 'root',
  }

  # C++ Development
  package {
    [
      'clang',               #
      'clang-format-3.6',    #
      'clang-tidy',          #
      'cmake',               #
      'doxygen',             #
      'doxygen-doc',         #
      'g++',                 #
      'kcachegrind',         #
      'libc++1',             #
      'libc++-dev',          #
      'libc++abi-dev',       # Seems to be required for in Ubuntu 16.04 (3.8.0-2ubuntu4)
      'libc6-dev-i386',      #
      'libclang-dev',        # For iwyu
      'libncurses5-dev',     # For iwyu
      'ninja-build',         #
      # 'ninja-build-doc',    # Doesn't seem to exist in 16.10
      #'nvidia-cuda-toolkit', # Commented out whilst using nvidia runfile for 8.0 (~/source/cuda_8.0.44_linux.bin)
      'valgrind',            #
      'zlib1g-dev',          # For iwyu
    ]:
    ensure => 'latest'
  }->
  # Seems to be required for in Ubuntu 16.04 (3.8.0-2ubuntu4)
  file { 'put symlink to __cxxabi_config.h in the standard include directory' : 
    name   => '/usr/include/c++/v1/__cxxabi_config.h',
    ensure => 'link',
    target => "/usr/include/libcxxabi/__cxxabi_config.h",
  }
  
  file { 'Install cath-tools_konsole.desktop shortcut' :
    path    => "$desktop_files_dir/cath-tools_konsole.desktop",
    ensure  => 'present',
    source  => 'puppet:///modules/cpp_devel/cath-tools_konsole.desktop',
    replace => 'yes',
    mode    => '0644',
  }

  file { 'Install eclipse.desktop shortcut' :
    path    => "$desktop_files_dir/eclipse.desktop",
    ensure  => 'present',
    source  => 'puppet:///modules/cpp_devel/eclipse.desktop',
    replace => 'yes',
    mode    => '0644',
  }

  vcsrepo { 'clone cath-tools git repository' :
    path     => "$repos_root_dir/cath-tools",
    ensure   => present,
    provider => git,
    source   => $cath_tools_url,
    owner    => $repos_user,
    group    => $repos_group,
  }->
  file { 'put symlink to cath-tools in the root directory' :
    name   => '/cath-tools',
    ensure => 'link',
    target => "$repos_root_dir/cath-tools",
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
  git::config { 'Set user Git config alias.st to status' :
    user  => $repos_user,
    scope => 'global',
    key   => 'alias.st',
    value => 'status',
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
