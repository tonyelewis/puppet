# == Class: plasma_user
#
# Description of class plasma_user here.
#
# === Parameters
#
# Document parameters here.
#
# [*sample_parameter*]
#   Explanation of what this parameter affects and what it defaults to.
#   e.g. "Specify one or more upstream ntp servers as an array."

class plasma_user {
  $user            = 'lewis'
  $group           = 'lewis'
  $home_dir        = "/home/${::plasma_user::user}"
#  $user            = 'ucbctnl'
#  $group           = 'users'
#  $home_dir        = "/cath/homes2/${::plasma_user::user}"
  $config_dir      = "${::plasma_user::home_dir}/.config"
  $kde_config_dir  = "${::plasma_user::home_dir}/.kde/share/config"
  $user_bin_dir    = "${::plasma_user::home_dir}/bin"
  $user_src_dir    = "${::plasma_user::home_dir}/source"
  $sublime_dir     = "${::plasma_user::config_dir}/sublime-text-3"
  $sublime_pkg_dir = "${::plasma_user::sublime_dir}/Packages"
  $sublime_usr_dir = "${::plasma_user::sublime_pkg_dir}/User"


  user { 'theuser' :
    name    => $user,
    ensure  => 'present',
    shell   => '/bin/zsh',
    require => Package[ zsh ]
  }

  Exec {
    path => [
      '/usr/bin',
      '/usr/sbin',
      '/bin',
      '/sbin',
    ]
  }

  #package { [
  #    #'wget',
  #    #'kde-l10n-engb', # To prevent annoying pop-ups about installing additional language support
  #  ] :
  #  ensure => 'latest',
  #}



  File {
    owner => $user,
    group => $group,
  }

  file_line { 'shortcut for switch one desktop down' :
    path  => "${::plasma_user::config_dir}/kglobalshortcutsrc",
    match => '^Switch One Desktop Down=.*Down,Switch One Desktop Down$',
    line  => 'Switch One Desktop Down=Ctrl+Alt+Down,Meta+Ctrl+Down,Switch One Desktop Down',
  }
  file_line { 'shortcut for switch one desktop up' :
    path  => "${::plasma_user::config_dir}/kglobalshortcutsrc",
    match => '^Switch One Desktop Up=.*Up,Switch One Desktop Up$',
    line  => 'Switch One Desktop Up=Ctrl+Alt+Up,Meta+Ctrl+Up,Switch One Desktop Up',
  }
  file_line { 'shortcut for switch one desktop left' :
    path  => "${::plasma_user::config_dir}/kglobalshortcutsrc",
    match => '^Switch One Desktop to the Left=.*Left,Switch One Desktop to the Left$',
    line  => 'Switch One Desktop to the Left=Ctrl+Alt+Left,Meta+Ctrl+Left,Switch One Desktop to the Left',
  }
  file_line { 'shortcut for switch one desktop right' :
    path  => "${::plasma_user::config_dir}/kglobalshortcutsrc",
    match => '^Switch One Desktop to the Right=.*Right,Switch One Desktop to the Right$',
    line  => 'Switch One Desktop to the Right=Ctrl+Alt+Right,Meta+Ctrl+Right,Switch One Desktop to the Right',
  }

  # Just do this manually - don't waste time on it
  # systemsettings => Shortcuts -> KWin -> type 'window one' and update the four options
  # file_line { 'shortcut for drag window one desktop down' :
  #   path  => "${::plasma_user::config_dir}/kglobalshortcutsrc",
  #   match => '^Window One Desktop Down=[^A]*$',
  #   line  => 'Window One Desktop Down=Ctrl+Alt+Shift+Down\tMeta+Ctrl+Shift+Down,Meta+Ctrl+Shift+Down,Window One Desktop Down',
  # }
  # file_line { 'shortcut for drag window one desktop up' :
  #   path  => "${::plasma_user::config_dir}/kglobalshortcutsrc",
  #   match => '^Window One Desktop Up=[^A]*$',
  #   line  => 'Window One Desktop Up=Ctrl+Alt+Shift+Up\tMeta+Ctrl+Shift+Up,Meta+Ctrl+Shift+Up,Window One Desktop Up',
  # }
  # file_line { 'shortcut for drag window one desktop left' :
  #   path  => "${::plasma_user::config_dir}/kglobalshortcutsrc",
  #   match => '^Window One Desktop to the Left=[^A]*$',
  #   line  => 'Window One Desktop Left=Ctrl+Alt+Shift+Left\tMeta+Ctrl+Shift+Left,Meta+Ctrl+Shift+Left,Window One Desktop Left',
  # }
  # file_line { 'shortcut for drag window one desktop right' :
  #   path  => "${::plasma_user::config_dir}/kglobalshortcutsrc",
  #   match => '^Window One Desktop to the Right=[^A]*$',
  #   line  => 'Window One Desktop Right=Ctrl+Alt+Shift+Right\tMeta+Ctrl+Shift+Right,Meta+Ctrl+Shift+Right,Window One Desktop Right',
  # }
  
  # TODO: Is there best practice for this ensure-file-exists-then-augeas-it two-step?
  #
  # Ensure existence of the configuration file that can turn off the unwanted user-dirs (Music, Pictures, Videos etc)
  file { 'make_user_dirs_config_file' :
    path    => "${::plasma_user::config_dir}/user-dirs.conf",
    ensure  => 'present',
    source  => 'puppet:///modules/plasma_user/user-dirs.conf',
    replace => 'no',
    mode    => '0600',
  }->
  # Modify file to turn off the unwanted user-dirs
  augeas { 'turn_off_users_dirs_in_config_file' :
    lens    => 'Shellvars.lns',
    incl    => "${::plasma_user::config_dir}/user-dirs.conf",
    context => "/files/${::plasma_user::config_dir}/user-dirs.conf",
    changes => [
      'set enabled False',
    ],
  }->
  # Remove the unwanted user-dirs
  file {
    [
      "${::plasma_user::home_dir}/Desktop",
      "${::plasma_user::home_dir}/Documents",
      "${::plasma_user::home_dir}/Downloads",
      "${::plasma_user::home_dir}/Music",
      "${::plasma_user::home_dir}/Pictures",
      "${::plasma_user::home_dir}/Public",
      "${::plasma_user::home_dir}/Templates",
      "${::plasma_user::home_dir}/Videos",
    ] :
    ensure => 'absent',
    force  => 'true',
  }

#   augeas { 'Disable shift del doing cut' :
#     lens    => 'Rsyncd.lns',
#     incl    => "${::plasma_user::config_dir}/kdeglobals",
#     context => "/files/${::plasma_user::config_dir}/kdeglobals",
#     changes => [
#       "set Shortcuts/Cut \"Ctrl+X; ; Ctrl+X; Shift+Del\"",
#     ],
#   }

  if $facts['networking']['hostname'] == 'bigslide' {
    augeas { 'Force font dpi to 240' :
      lens    => 'Rsyncd.lns',
      incl    => "${::plasma_user::config_dir}/kcmfonts",
      context => "/files/${::plasma_user::config_dir}/kcmfonts",
      changes => [
        'set General/forceFontDPI 240',
      ],
    }

    augeas { 'Set touchpad keyboard autodisable timeout to 1.0s' :
      lens    => 'Rsyncd.lns',
      incl    => "${::plasma_user::config_dir}/touchpadrc",
      context => "/files/${::plasma_user::config_dir}/touchpadrc",
      changes => [
        'set autodisable/KeyboardActivityTimeoutMs 1000',
      ],
    }
    
    augeas { 'Set mouse acceleration to 3' :
      lens    => 'Rsyncd.lns',
      incl    => "${::plasma_user::config_dir}/kcminputrc",
      context => "/files/${::plasma_user::config_dir}/kcminputrc",
      changes => [
        'set Mouse/Acceleration 3',
      ],
    }
  }

  file { 'kwinrc owned by user' :
    ensure => 'file',
    owner  => $user,
    path   => "${::plasma_user::config_dir}/kwinrc",
  }
  ->augeas { 'Specify four desktops in two rows and meta as the modifier key' :
    lens    => 'Rsyncd.lns',
    incl    => "${::plasma_user::config_dir}/kwinrc",
    context => "/files/${::plasma_user::config_dir}/kwinrc",
    changes => [
      'set Desktops/Number 4',
      'set Desktops/Rows 2',
      'set MouseBindings/CommandAllKey Meta',
      'set Windows/RollOverDesktops false',
    ],
  }

  augeas { 'Set Greeeter (ie login-screen) wallpaper to plain color (since ugly standard Greeter wallpaper of Ubuntu 18.04)' :
    lens    => 'Rsyncd.lns',
    incl    => "${::plasma_user::config_dir}/kscreenlockerrc",
    context => "/files/${::plasma_user::config_dir}/kscreenlockerrc",
    changes => [
      'set Greeter/WallpaperPlugin "org.kde.color"',
    ],
  }

  file { 'Konsole config owned by user' :
    ensure => 'file',
    owner  => $user,
    path   => "${::plasma_user::config_dir}/konsolerc",
  }
  ->augeas { 'Set Konsole tabbar to top' :
    lens    => 'Rsyncd.lns',
    incl    => "${::plasma_user::config_dir}/konsolerc",
    context => "/files/${::plasma_user::config_dir}/konsolerc",
    changes => [
      'set TabBar/TabBarPosition Top',
    ],
  }

  # Set the KDE keyboard to GB (and Dvorak GB)
  #  (should this be .kde/share/config/kxkbrc ?)
  file { 'KDE keyboard config owned by user' :
    ensure => 'file',
    owner  => $user,
    path   => "${::plasma_user::config_dir}/kxkbrc",
  }
  ->augeas { 'kde_keyboard_to_gb_plus_dvorak' :
    lens    => 'Rsyncd.lns',
    incl    => "${::plasma_user::config_dir}/kxkbrc",
    context => "/files/${::plasma_user::config_dir}/kxkbrc",
    changes => [
      # 'set Layout/DisplayNames ,',
      'set Layout/LayoutList gb,gb(dvorakukp)', # Necessary
      'set Layout/Model pc101',                 # Necessary
      'set Layout/Use true',
    ],
  }
  
  # Set the Plasma Breeze titlebar buttons to be small
  file { 'Breeze config owned by user' :
    ensure => 'file',
    owner  => $user,
    path   => "${::plasma_user::config_dir}/breezerc",
  }
  ->augeas { 'title_bar_buttons_to_small' :
    lens    => 'Rsyncd.lns',
    incl    => "${::plasma_user::config_dir}/breezerc",
    context => "/files/${::plasma_user::config_dir}/breezerc",
    changes => [
      'set Windeco/ButtonSize ButtonSmall',
    ],
  }
  
  
  
  ##############################################################
  
  
  # Emplace .vimrc file
  file { 'vim_rc_file' :
    path    => "${::plasma_user::home_dir}/.vimrc",
    ensure  => 'present',
    source  => 'puppet:///modules/plasma_user/vimrc',
    replace => 'no',
    mode    => '0644',
  }



  # Ensure that there's a user bin directory
  file { 'create_user_bin_dir' :
    path    => "${::plasma_user::user_bin_dir}",
    ensure  => 'directory',
  }->

  # Still need this even with oh-my-zsh's grep in order to make ` | xargs grep ` use colour
  file { 'make grep script that adds arguments whilst passing-through' :
    path    =>"${::plasma_user::user_bin_dir}/grep",
    ensure  => 'present',
    source  => 'puppet:///modules/plasma_user/grep',
    mode    => '0755',
  }->

  # Download vimcat to the user bin directory
  plasma_user::download_file { 'Download of vimcat file' :
    uri    => 'http://www.vim.org/scripts/download_script.php?src_id=21937',
    target => "${::plasma_user::user_bin_dir}/vimcat",
    require => File[ 'create_user_bin_dir' ],
  }->
  file { 'make vimcat executable' :
    path =>"${::plasma_user::user_bin_dir}/vimcat",
    ensure  => 'present',
    mode    => '0755',
  }

  # Ensure that there's a user source directory
  file { 'create_user_source_dir' :
    path    => "${::plasma_user::user_src_dir}",
    ensure  => 'directory',
  }
  
  # Ensure that there's an 'st' symlink to Sublime Text
  file { 'sublime_text_symlink_in_user_bin_dir' :
    path    => "${::plasma_user::user_bin_dir}/st",
    ensure  => 'link',
    target  => '/opt/sublime_text_3/sublime_text',
    require => File[ 'create_user_bin_dir' ],
  }->
  file { 'Sublime Text Dir' :
    path   => "${::plasma_user::sublime_dir}",
    ensure => 'directory',
  }
  file { 'Sublime Text Package directory' :
    path   => "${::plasma_user::sublime_pkg_dir}",
    ensure => 'directory',
  }->
  file { 'Sublime Text user configuration directory' :
    path   => "${::plasma_user::sublime_usr_dir}",
    ensure => 'directory',
  }->
  file { 'Sublime Text toggle_white_space function' :
    path    => "${::plasma_user::sublime_usr_dir}/toggle_white_space.py",
    ensure  => 'present',
    source  => 'puppet:///modules/plasma_user/sublime_text_toggle_white_space.py',
    replace => 'no',
    mode    => '0644',
  }->
  file { 'Sublime Text keymap file' :
    path    => "${::plasma_user::sublime_usr_dir}/Default (Linux).sublime-keymap",
    ensure  => 'present',
    source  => 'puppet:///modules/plasma_user/sublime_text_keymap',
    replace => 'no',
    mode    => '0644',
  }->
  file { 'Sublime Text user preferences file' :
    path    => "${::plasma_user::sublime_usr_dir}/Preferences.sublime-settings",
    ensure  => 'present',
    source  => 'puppet:///modules/plasma_user/sublime_text_user_preferences',
    replace => 'no',
    mode    => '0644',
  }->
  file { 'Sublime Text Default theme file' :
    path    => "${::plasma_user::sublime_usr_dir}/Default.sublime-theme",
    ensure  => 'present',
    source  => 'puppet:///modules/plasma_user/sublime_text_default_theme',
    replace => 'no',
    mode    => '0644',
  }
  
	file { 'create empty directory':
		ensure => 'directory',
		mode   => '0755',
		owner  => 'root',
		path   => '/opt/empty_directory',
	}

}
