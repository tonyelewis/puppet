

class boost::packages {
  
  package {
    [
      'boost',
      'boost141',
      'boost-devel',
      'boost141-devel',
      # Be careful about adding Boost packages to this purge list - 
      # they may remove lots of other useful packages with them
    ] :
    ensure => 'purged',
  }

  package { 'the-bzip2-devel-package' :
    name   => 
      # 'bzip2-devel', # For Boost (CentOS)
      'libbz2-dev',  # For Boost (Ubuntu)
    ensure => 'latest',
  }
  
  package { 'the-python-devel-package' :
    name   =>
      # 'python-devel', # For Boost (CentOS)
      'python-dev',   # For Boost (Ubuntu)
    ensure => 'latest',
  }
  
  package {
    [
      'python',                 # For Boost
      'wget',                   # To download file
    ] :
    ensure => 'latest',
  }

}
