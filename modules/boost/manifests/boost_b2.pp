# TODO: What types are available?
#       Can these be constrained to valid directories?
#       Can these be constrained to arrays of strings?

define boost::boost_b2 (
  $working_dir,
  $command,
  $creates = []
) {
  Exec {
    environment => [
      'EXPAT_INCLUDE=/usr/include',
      'EXPAT_LIBPATH=/usr/lib'
    ],
  }

  exec { "perform_b2_${command}" :
    command     =>   $command,
    cwd         =>   $working_dir,
    path        => [ $working_dir, '/usr/bin', '/bin', ],
    creates     =>   $creates,
    timeout     => 7200,
  }
}