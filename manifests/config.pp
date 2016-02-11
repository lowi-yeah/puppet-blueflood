# == Class blueflood::config
#
# This class is called from blueflood for service config.
#
class blueflood::config {
  file { "${::blueflood::install_location}/blueflood.properties":
    ensure  => present,
    owner   => grid,
    group   => grid,
    mode    => '0644',
    content => template('blueflood/blueflood.properties.erb'),
  }->
  file { "${::blueflood::install_location}/blueflood-log4j.properties":
    ensure  => present,
    owner   => grid,
    group   => grid,
    mode    => '0644',
    content => template('blueflood/blueflood-log4j.properties.erb'),
  }
  file { "${::blueflood::install_location}/run.sh":
    ensure  => present,
    owner   => grid,
    group   => grid,
    mode    => '0755',
    content => template('blueflood/run.sh.erb'),
  }
  file { "${::blueflood::install_location}/logs":
    ensure  => directory,
    owner   => grid,
    group   => grid,
    mode    => '0644',
    require => Vcsrepo[$::blueflood::install_location],
  }
  file { '/var/log/blueflood':
    ensure => link,
    target => "${::blueflood::install_location}/logs",
  }
}
