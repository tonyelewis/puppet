# == Class: general_desktop
#
# Description of class general_desktop here.
#
# === Parameters
#
# Document parameters here.
#
# [*sample_parameter*]
#   Explanation of what this parameter affects and what it defaults to.
#   e.g. "Specify one or more upstream ntp servers as an array."

class general_desktop {
  include stdlib # For file_line

  $user     = 'lewis'
  $home_dir = "/home/${::general_desktop::user}"

  $desktop_files_dir = '/usr/share/applications'

  # Set a sensible path so that binaries' paths don't have to be fully qualified
  Exec {
    path => [
      '/usr/bin',
      '/usr/sbin',
      '/bin',
      '/sbin'
    ]
  }

#  # Execute 'apt-get update'
#  exec { 'apt-update':
#    command => 'apt-get update'
#  }
#  # Execute 'apt-get upgrade'
#  exec { 'apt-upgrade':
#    command => 'apt-get upgrade -y',
#    require => Exec['apt-update'],
#  }
#  # Execute 'apt-get dist-upgrade'
#  exec { "apt-dist-upgrade":
#    command     => 'apt-get dist-upgrade -y',
#    refreshonly => true,
#    subscribe   => Exec[ 'apt-upgrade' ],
#  }
#  # Execute 'apt-get autoremove'
#  exec { "apt-autoremove":
#    command     => 'apt-get autoremove -y',
#    refreshonly => true,
#    subscribe   => Exec[ 'apt-upgrade' ],
#  }
#  
#  
#  # Ensure that an apt-get upgrade (and before that apt-get update) has been run before any package commands
#  Exec['apt-upgrade'] -> Package <| |>

  # Install standard desktop packages
  package { [
      #'sddm-theme-elarun',               # Should add this for 15.04 <= Ubuntu <= 16.10 if
      #                                   # encountering problems with entering   username at login
      'augeas-tools',
      'bat',
      'entr',
      'expect',                          # Contains unbuffer which is useful for tricking clang-tidy into thinking it's talking directly to a tty
      'gconf2',                          # For Atom
      'gnuplot',
      'graphviz',
      'gwenview',
      'htop',
      'inkscape',
      'kubuntu-desktop',
      'latex-mk',
      'libappindicator1',                # For Chrome
      'libasound2-dev',                  # For MXX
      'libcurl4-gnutls-dev',             # For MXX
      'libgd-perl',                      # For plotting pictures in Perl
      'libimage-exiftool-perl',
      'libindicator7',                   # For Chrome
      'libipc-run3-perl',                # For general Perl use
      'liblog-log4perl-perl',            # For general Perl use
      'libmoosex-params-validate-perl',  # MooseX::Params::Validate for General Perl use and for gen_cmake_list.pl in   particular
      'libmoosex-types-path-class-perl', #
      'libpath-class-perl',              # For General Perl use and for makeoutputparser.pl in particular
      'libreadonly-perl',                #
      'libsamplerate0-dev',              # For MXX
      'meld',
      'mesa-common-dev',                 # For MXX
      'mkdocs',
      'mkdocs-doc',
      'ncdu',
      'nedit',
      'okular',
      'perl-doc',                        # To enable perldoc command
      'ps2eps',
      'psutils',
      'puppet',
      'puppet-lint',                     # For Puppet in VSCode
      'puppet-module-puppetlabs-stdlib',
      'pymol',
      'python3-click',                   # Required for mkdocs
      'r-base',
      'rasmol',
      'sshfs',
      'subversion',
      'synaptic',
      'tcsh',                            # Used by ~/bin/grep
      'tree',
      'vim',
      'virtualbox',
      'vlc',
      'wget',
      'zsh',
      'zsh-common'
    ] :
    ensure => 'latest',
  }

  # file { 'oh-my-zsh-install-file' :
  #   ensure  => file,
  #   mode    => 'a+rx',
  #   path    => '/opt/oh-my-zsh.install.sh',
  #   replace => 'false',
  #   require => Package[ 'zsh' ],
  #   source  => 'https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh',
  # }->
  # exec { 'install oh-my-zsh' :
  #   command   => '/bin/sh -c `cat /opt/oh-my-zsh.install.sh`',
  #   creates   => "${::general_desktop::home_dir}/.oh-my-zsh/README.md",
  #   logoutput => 'true',
  #   require   => User[ 'lewis with zsh' ],
  #   user      => 'lewis',
  # }

  class { 'ohmyzsh': }

  # Install ohmyzsh for lewis
  ohmyzsh::install { $user:
  }
  ->file_line { 'ohmyzsh prompt' :
    path  => "${::general_desktop::home_dir}/.oh-my-zsh/themes/robbyrussell.zsh-theme",
    match => '^PROMPT.*git_prompt_info',
    line  => "PROMPT+='%{\$fg_bold[white]%}%M %{\$fg[cyan]%}%d%{\$reset_color%} \$(git_prompt_info)'",
  }
  ->file { 'concat ohmyzsh .zshrc and my suffix':
    ensure  => file,
    path    => "${::general_desktop::home_dir}/.zshrc",
    content => template(
      "${::general_desktop::home_dir}/.oh-my-zsh/templates/zshrc.zsh-template",
      "${::general_desktop::home_dir}/puppet/dot_zshrc_suffix",
    ),
  }

  # As of May 2018, can't just use a file resource with http source here because
  # that doesn't follow the redirect
  # file { 'download VSCode .deb file' :
  #   path    => '/opt/vscode_amd64.deb',
  #   replace => false,
  #   source  => 'https://go.microsoft.com/fwlink/?LinkID=760868',
  # }
  general_desktop::download_file { 'download VSCode .deb file' :
    target => '/opt/code_1.39.2.amd64.deb',
    uri    => 'https://update.code.visualstudio.com/1.39.2/linux-deb-x64/stable',
  }
  ->package { 'Install VSCode package':
    ensure   => 'held',
    name     => 'code',
    provider => dpkg,
    source   => '/opt/code_1.39.2.amd64.deb',
  }
  ->file { 'VSCode projects directory' :
    ensure => 'directory',
    mode   => 'a+rX',
    owner  => $user,
    path   => "${home_dir}/.vscode-projects",
  }

  # Remove annoying would-you-like-to-install browser popups
  package { [
      'unity-webapps-service',
      'unity-webapps-qml',
      'unity-webapps-common',
      'libunity-webapps0',
      'webapp-container',
    ] :
    ensure => 'purged',
  }

  # Ensure there's a file /root/.vimrc, and that it contains the line: `set background=dark`
  file { '/root/.vimrc':
    ensure => file,
  }
  ->file_line { 'Add set background=dark to /root/.vimrc':
    path => '/root/.vimrc',
    line => 'set background=dark',
  }

  # Extras for LaTeX
  package {
    [
      'texlive-extra-utils',
      'texlive-font-utils',
      'texlive-fonts-extra',
      'texlive-fonts-extra-doc',
      'texlive-fonts-recommended',
      'texlive-fonts-recommended-doc',
      'texlive-latex-base-doc',
      'texlive-latex-extra',
      'texlive-latex-extra-doc',
      'texlive-latex-recommended-doc',
      'texlive-pictures-doc',
      'texlive-pstricks-doc',
    ] :
    ensure => 'latest'
  }

  # Desktop
  package { 'sddm':
    ensure       => 'latest',
    responsefile => 'puppet:///modules/general_desktop/sddm.preseed',
  }

  # Download the Google Chrome package and install it
  # general_desktop::download_file { 'Download of Chrome package file' :
  #   uri    => 'https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb',
  #   target => '/opt/google-chrome-stable_current_amd64.deb',
  # }
  file { 'Download of Chrome package file' :
    path    => '/opt/google-chrome-stable_current_amd64.deb',
    replace => false,
    source  => 'https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb',
  }
  ->package { 'google-chrome-stable':
    ensure   => installed,
    provider => dpkg,
    source   => '/opt/google-chrome-stable_current_amd64.deb',
    require  => Package[ 'libappindicator1', 'libindicator7' ],
  }

  ## $java_version_major = '8';
  ## $java_version_minor = ;
  ## $java_version_point = ;
  #general_desktop::download_file { 'Download of Java jdk file' :
  #  # wget --no-check-certificate --no-cookies --header "Cookie: oraclelicense=accept-securebackup-cookie"
  #  uri    => 'http://download.oracle.com/otn-pub/java/jdk/8u91-b14/jdk-8u91-linux-x64.tar.gz',
  #  target => '/opt/jdk-8u91-linux-x64.tar.gz',
  #}
  #update-alternatives --install "/usr/bin/java"   "java"   "/opt/jdk1.8.0_91/bin/java"   1
  #update-alternatives --install "/usr/bin/javac"  "javac"  "/opt/jdk1.8.0_91/bin/javac"  1
  #update-alternatives --install "/usr/bin/javaws" "javaws" "/opt/jdk1.8.0_91/bin/javaws" 1
  #update-alternatives --config java
  #update-alternatives --config javac
  #update-alternatives --config javaws

  # Download the GithHub Atom package and install it
  general_desktop::download_file { 'Download of Atom package file' :
    uri    => 'https://atom.io/download/deb',
    target => '/opt/atom-amd64.deb'
  }
  ->package { 'atom' : # Does this require package gconf2 ?
    ensure   => latest,
    provider => dpkg,
    require  => Package[ 'gconf2' ],
    source   => '/opt/atom-amd64.deb',
  }

  # # Eclipse
  # #$eclipse_stem             = 'eclipse-cpp-mars-R'
  # #$eclipse_archive_url_dir  = 'http://www.mirrorservice.org/sites/download.eclipse.org/eclipseMirror/technology/epp/downloads/release/mars/R'
  # #$eclipse_stem             = 'eclipse-cpp-mars-1'
  # #$eclipse_archive_url_dir  = 'http://www.mirrorservice.org/sites/download.eclipse.org/eclipseMirror/technology/epp/downloads/release/mars/1'
  # $eclipse_stem             = 'eclipse-cpp-neon-R'
  # $eclipse_archive_url_dir  = 'http://www.mirrorservice.org/sites/download.eclipse.org/eclipseMirror/technology/epp/downloads/release/neon/R'
  # $eclipse_archive_basename = "${eclipse_stem}-linux-gtk-x86_64.tar.gz"
  # $eclipse_archive_url      = "$eclipse_archive_url_dir/$eclipse_archive_basename"
  # $eclipse_parent_dir       = '/opt'
  # $eclipse_dir              = "$eclipse_parent_dir/$eclipse_stem"
  # $eclipse_archive_filename = "$eclipse_parent_dir/$eclipse_archive_basename"
  # $eclipse_sylink           = "$eclipse_parent_dir/eclipse"
  # general_desktop::download_file { 'Download of Eclipse archive (.tar.gz) file' :
  #   uri     => $eclipse_archive_url,
  #   target  => $eclipse_archive_filename,
  # }->
  # file { $eclipse_dir :
  #   ensure  => 'directory'
  # }->
  # exec { 'untar eclipse archive' :
  #   command => "tar -zxvf $eclipse_archive_filename --directory $eclipse_dir --strip-components=1",
  #   creates => "$eclipse_dir/configuration/org.eclipse.update/platform.xml",
  # }->
  # file { "$eclipse_sylink symlinks to correct eclipse" :
  #   path    => $eclipse_sylink,
  #   ensure  => 'link',
  #   target  => $eclipse_stem,
  # }

  general_desktop::download_file { 'Download of Sublime Text archive file' :
    #uri    => 'https://download.sublimetext.com/sublime_text_3_build_3114_x64.tar.bz2',
    #uri    => 'https://download.sublimetext.com/sublime_text_3_build_3124_x64.tar.bz2',
    #uri    => 'https://download.sublimetext.com/sublime_text_3_build_3126_x64.tar.bz2',
    #uri    => 'https://download.sublimetext.com/sublime_text_3_build_3143_x64.tar.bz2',
    #uri    => 'https://download.sublimetext.com/sublime_text_3_build_3170_x64.tar.bz2',
    #uri    => 'https://download.sublimetext.com/sublime_text_3_build_3176_x64.tar.bz2',
    uri    => 'https://download.sublimetext.com/sublime_text_3_build_3211_x64.tar.bz2',

    target => '/opt/sublime_text_3_build_3211_x64.tar.bz2',
  }
  ->file { '/opt/sublime_text_3' :
    ensure => 'directory'
  }
  ->exec { 'Untar Sublime Text archive' :
    command => 'tar -axvf "/opt/sublime_text_3_build_3211_x64.tar.bz2" --directory /opt/sublime_text_3 --strip-components=1',
    creates => '/opt/sublime_text_3/sublime_text',
  }
  ->file { 'Install sublime_text.desktop shortcut' :
    ensure  => 'present',
    path    => "${desktop_files_dir}/sublime_text.desktop",
    source  => 'puppet:///modules/general_desktop/sublime_text.desktop',
    replace => 'yes',
    mode    => '0644',
  }

  general_desktop::download_file { 'Download of cppreference archive (.tar.gz) file' :
    uri    => 'http://upload.cppreference.com/mwiki/images/c/ca/cppreference-doc-20181028.tar.xz',
    #uri    => 'http://upload.cppreference.com/mwiki/images/c/cb/cppreference-doc-20180311.tar.xz',
    #uri    => 'http://upload.cppreference.com/mwiki/images/b/bd/cppreference-doc-20170409.tar.gz',
    #uri    => 'http://upload.cppreference.com/mwiki/images/0/0d/cppreference-doc-20170214.tar.gz',
    #uri    => 'http://upload.cppreference.com/mwiki/images/d/d9/cppreference-doc-20161029.tar.gz',
    #uri    => 'http://upload.cppreference.com/mwiki/images/6/60/cppreference-doc-20151129.tar.gz',
    target => '/opt/cppreference-doc-20181028.tar.xz',
  }
  ->file { '/opt/cppreference-doc-20181028' :
    ensure  => 'directory'
  }
  ->exec { 'untar cppreference archive' :
    command => 'tar -axvf /opt/cppreference-doc-20181028.tar.xz --directory /opt/cppreference-doc-20181028 --strip-components=1',
    creates => '/opt/cppreference-doc-20181028/README.md',
  }
}
