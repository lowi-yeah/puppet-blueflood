# == blueflood kafka::service
#
class blueflood::service(
   $service_environment = '',
) inherits blueflood {

  if !($service_ensure in ['present', 'absent']) {
    fail('service_ensure parameter must be "present" or "absent"')
  }

  if $service_manage == true {
    supervisor::service { 
      $service_name:
        ensure                 => $blueflood::service_ensure,
        enable                 => $blueflood::service_enable,
        command                => "${blueflood::command}",
        directory              => $blueflood::base_dir,
        environment            => $service_environment,
        # environment            => "JMX_PORT=${jmx_port},${kafka_gc_log_opts_real},${kafka_heap_opts_real},${kafka_jmx_opts_real},${kafka_jvm_performance_opts_real},${kafka_log4j_opts_real},${kafka_opts_real}",
        user                   => $blueflood::user,
        group                  => $blueflood::group,
        autorestart            => $blueflood::service_autorestart,
        startsecs              => $blueflood::service_startsecs,
        stopwait               => $blueflood::service_stopsecs,
        retries                => $blueflood::service_retries,
        stdout_logfile_maxsize => $blueflood::service_stdout_logfile_maxsize,
        stdout_logfile_keep    => $blueflood::service_stdout_logfile_keep,
        stderr_logfile_maxsize => $blueflood::service_stderr_logfile_maxsize,
        stderr_logfile_keep    => $blueflood::service_stderr_logfile_keep,
        stopsignal             => 'INT',
        stopasgroup            => true,
        require                => [Class['mosquitto::config'], Class['::supervisor']],
    }

    if $blueflood::service_enable == true {
      exec { 'restart-blueflood-database':
        command     => "supervisorctl restart ${blueflood::service_name}",
        path        => ['/usr/bin', '/usr/sbin', '/sbin', '/bin'],
        user        => 'root',
        refreshonly => true,
        subscribe   => File[$config],
        onlyif      => 'which supervisorctl &>/dev/null',
        require     => Class['::supervisor'],
      }
    }
  }
}
