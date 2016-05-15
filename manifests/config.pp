# == Class blueflood::config

include wget
class blueflood::config inherits blueflood {

  
 
  #file { $jar:
  #  ensure  => file,
  #  owner   => $blueflood::user,
  #  group   => $blueflood::group,
  #  mode    => '0755',
  #  # source  => "file:${jar_file}",
  #  # source  => "file:///${jar_file}",
  #  source  => $jar_file,
  #  # content => template($blueflood::config_template),
  #  require => File[$jar_dir],
  #}

 
  file { $config_dir:
    ensure  => directory,
    owner   => $blueflood::user,
    group   => $blueflood::group,
    mode    => '0644',
    require => Vcsrepo[$base_dir],
  }
  
  file { $config:
    ensure  => file,
    owner   => $blueflood::user,
    group   => $blueflood::group,
    mode    => '0644',
    content => template($blueflood::config_template),
    require => File[$config_dir],
  }

  file { $logging_config:
    ensure  => file,
    owner   => $blueflood::user,
    group   => $blueflood::group,
    mode    => '0644',
    content => template($blueflood::logging_config_template),
    require => File[$config_dir],
  }

  file { $log_dir:
    ensure  => directory,
    owner   => $blueflood::user,
    group   => $blueflood::group,
    mode    => '0644',
    require => Vcsrepo[$base_dir],
  }
  
}
