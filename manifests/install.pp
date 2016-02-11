# == Class blueflood::install
#
# This class is called from blueflood for install.
#
class blueflood::install {

  package { $::blueflood::package_name:
    ensure => present,
  }
  vcsrepo { $::blueflood::install_location:
    ensure   => present,
    provider => 'git',
    source   => 'https://github.com/rackerlabs/blueflood.git',
  }
  exec { 'build blueflood':
    path    => ['/usr/bin'],
    command => 'mvn package -P all-modules',
    creates => "${::blueflood::install_location}/blueflood-all/target/blueflood-all-2.0.0-SNAPSHOT-jar-with-dependencies.jar",
    cwd     => $::blueflood::install_location,
    require => Vcsrepo[$::blueflood::install_location],
  }
}
