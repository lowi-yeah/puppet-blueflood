# == Class blueflood::params
#
# This class is meant to be called from blueflood.
# It sets variables according to platform.
#
class blueflood::params {

  $base_dir         = '/opt/blueflood'
  $config              = "${base_dir}/config/blueflood.properties"
  $logging_config      = "${base_dir}/config/blueflood-log4j.properties"
  $jar                 = "${base_dir}/blueflood-all/target/blueflood-all-2.0.0-SNAPSHOT-jar-with-dependencies.jar"
  $config_template     = 'blueflood/blueflood.properties'
  $logging_template    = 'blueflood/blueflood-log4j.properties'

  $jmx_port = 9180

  $blueflood_config_opts          = "-Dblueflood.config=file:${config}"
  $blueflood_gc_log_opts          = '-verbose:gc -XX:+PrintGCDetails -XX:+PrintGCDateStamps'
  $blueflood_heap_opts            = '-Xms512M -Xmx512M'
  $blueflood_jmx_opts             = "-Dcom.sun.management.jmxremote.authenticate=false -Dcom.sun.management.jmxremote.ssl=false  -Dcom.sun.management.jmxremote.port=${jmx_port}"
  $blueflood_jvm_performance_opts = '-server -XX:+UseCompressedOops -XX:+UseParNewGC -XX:+UseConcMarkSweepGC -XX:+CMSClassUnloadingEnabled -XX:+CMSScavengeBeforeRemark -XX:+DisableExplicitGC -Djava.awt.headless=true'
  $blueflood_log4j_opts           = "-Dlog4j.configuration=file:${logging_config}"
  $blueflood_cp_opts              = "-classpath ${jar} com.rackspacecloud.blueflood.service.BluefloodServiceStarter"

  $command             = "$JAVA_HOME/bin/java ${$blueflood_config_opts} ${$blueflood_gc_log_opts} ${$blueflood_heap_opts} ${$blueflood_jmx_opts} ${$blueflood_jvm_performance_opts} ${$blueflood_log4j_opts} ${$blueflood_cp_opts$}"

  $gid                 = 53073
  $group               = 'blueflood'
  $group_ensure        = 'present'
  $package_name        = 'blueflood'
  $package_ensure      = 'present'
  $service_autorestart = true
  $service_enable      = true
  $service_ensure      = 'present'
  $service_manage      = true
  $service_name        = 'blueflood-db'
  $service_retries     = 999
  $service_startsecs   = 10
  $service_stopsecs    = 10
  $service_stderr_logfile_keep    = 10
  $service_stderr_logfile_maxsize = '20MB'
  $service_stdout_logfile_keep    = 5
  $service_stdout_logfile_maxsize = '20MB'
  $shell               = '/bin/bash'
  $uid                 = 53073
  $user                = 'blueflood'
  $user_description    = 'Blueflood system account'
  $user_ensure         = 'present'
  $user_home           = '/home/blueflood'
  $user_manage         = true
  $user_managehome     = true
  

  case $::osfamily {
    'RedHat': {}
    default: {
      fail("The ${module_name} module is not supported on a ${::osfamily} based system.")
    }
  }
}
