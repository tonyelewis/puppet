
define plasma_user::download_file (
  $uri,
  $target,
  $timeout       = 300,
  $unique_suffix = '',
) {
  exec { "Download URI \"${uri}\" to \"${target}\" [$unique_suffix]" :
    command => "wget -q '${uri}' -O ${target}.wget_temp && mv ${target}.wget_temp ${target}",
    creates => $target,
    timeout => $timeout,
    require => Package[ 'wget' ],
  }
}
