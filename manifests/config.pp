# == Class blueflood::config
class blueflood::config inherits blueflood {
  
  file { $config:
    ensure  => file,
    owner   => root,
    group   => root,
    mode    => '0644',
    content => template($blueflood::config_template),
  }

  file { $logging_config:
    ensure  => file,
    owner   => root,
    group   => root,
    mode    => '0644',
    content => template($blueflood::logging_config_template),
  }

  file { "${base_dir}/logs":
    ensure  => directory,
    owner   => root,
    group   => root,
    mode    => '0644',
    require => Vcsrepo[$base_dir],
  }
  
}
