# == Class blueflood::service
#
# This class is meant to be called from blueflood.
# It ensure the service is running.
#
class blueflood::service {

  service { $::blueflood::service_name:
    ensure     => running,
    enable     => true,
    hasstatus  => true,
    hasrestart => true,
  }
}
