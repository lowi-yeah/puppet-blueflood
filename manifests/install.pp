# == Class blueflood::install
#
# This class is called from blueflood for install.
#
class blueflood::install {

  package { $::blueflood::package_name:
    ensure => present,
  }
}
