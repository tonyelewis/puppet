# == Class: eclipse_user
#
# Description of class eclipse_user here.
#
# === Parameters
#
# Document parameters here.
#
# [*sample_parameter*]
#   Explanation of what this parameter affects and what it defaults to.
#   e.g. "Specify one or more upstream ntp servers as an array."

class eclipse_user {
  $user      = 'lewis'
  $group     = 'lewis'
  $home_dir  = "/home/${::eclipse_user::user}"
#  $user      = 'ucbctnl'
#  $group     = 'users' 
#  $home_dir  = "/cath/homes2/${::eclipse_user::user}"

  File {
    owner   => $user,
    group   => $group,
  }
  
  file { 'eclipse_conf_dir' :
    path    => "${::eclipse_user::home_dir}/.eclipse",
    ensure  => 'directory',
  }
  ->file { 'eclipse_user_dictionary' :
    path    => "${::eclipse_user::home_dir}/.eclipse/user_dictionary",
    ensure  => 'present',
    source  => 'puppet:///modules/eclipse_user/eclipse_user_dictionary',
    replace => 'no',
    mode    => '0644',
  }

}
