# == Class: blueflood
#
# Deploys a Blueflood database.
#
# === Parameters
#
# TODO: Document each class parameter.
#
# [*blueflood_gc_log_opts*]
#   Use this parameter for all Java Garbage Collection settings with the exception of configuring `-Xloggc:...`.
#   Use $gc_log_file for the latter.
#
# [*blueflood_log4j_opts*]
#   Use this parameter for all logging settings with the exception of configuring `-Dlog4j.configuration.file=...`.
#   Use $logging_config for the latter.
#

class blueflood (
$base_dir                         = $blueflood::params::base_dir,
$config                           = $blueflood::params::config,
$logging_config                   = $blueflood::params::logging_config,
$jar                              = $blueflood::params::jar,
$config_template                  = $blueflood::params::config_template,
$logging_template                 = $blueflood::params::logging_template,
$jmx_port                         = $blueflood::params::jmx_port,
$blueflood_config_opts            = $blueflood::params::blueflood_config_opts,
$blueflood_gc_log_opts            = $blueflood::params::blueflood_gc_log_opts,
$blueflood_heap_opts              = $blueflood::params::blueflood_heap_opts,
$blueflood_jmx_opts               = $blueflood::params::blueflood_jmx_opts,
$blueflood_jvm_performance_opts   = $blueflood::params::blueflood_jvm_performance_opts,
$blueflood_log4j_opts             = $blueflood::params::blueflood_log4j_opts,
$blueflood_cp_opts                = $blueflood::params::blueflood_cp_opts,
$command                          = $blueflood::params::command,
$gid                              = $blueflood::params::gid,
$group                            = $blueflood::params::group,
$group_ensure                     = $blueflood::params::group_ensure,
$package_name                     = $blueflood::params::package_name,
$package_ensure                   = $blueflood::params::package_ensure,
$service_ensure                   = $blueflood::params::service_ensure,
$service_name                     = $blueflood::params::service_name,
$service_retries                  = $blueflood::params::service_retries,
$service_startsecs                = $blueflood::params::service_startsecs,
$service_stopsecs                 = $blueflood::params::service_stopsecs,
$service_stderr_logfile_keep      = $blueflood::params::service_stderr_logfile_keep,
$service_stderr_logfile_maxsize   = $blueflood::params::service_stderr_logfile_maxsize,
$service_stdout_logfile_keep      = $blueflood::params::service_stdout_logfile_keep,
$service_stdout_logfile_maxsize   = $blueflood::params::service_stdout_logfile_maxsize,
$shell                            = $blueflood::params::shell,
$uid                              = $blueflood::params::uid,
$user                             = $blueflood::params::user,
$user_description                 = $blueflood::params::user_description,
$user_ensure                      = $blueflood::params::user_ensure,
$user_home                        = $blueflood::params::user_home,


$service_autorestart              = hiera('blueflood::service_autorestart', $blueflood::params::service_autorestart),
$service_enable                   = hiera('blueflood::service_enable',      $blueflood::params::service_enable),
$service_manage                   = hiera('blueflood::service_manage',      $blueflood::params::service_manage),
$user_manage                      = hiera('blueflood::user_manage',         $blueflood::params::user_manage),
$user_managehome                  = hiera('blueflood::user_managehome',     $blueflood::params::user_managehome),

  
) inherits kafka::params {

  validate_absolute_path($base_dir)
  validate_absolute_path($config)
  validate_absolute_path($logging_config)
  validate_absolute_path($jar)
  validate_string($config_template)
  validate_string($logging_template)
  if !is_integer($jmx_port) { fail('The $jmx_port parameter must be an integer number') }
  validate_string($blueflood_config_opts)                
  validate_string($blueflood_gc_log_opts)                
  validate_string($blueflood_heap_opts)                
  validate_string($blueflood_jmx_opts)                
  validate_string($blueflood_jvm_performance_opts)                
  validate_string($blueflood_log4j_opts)                
  validate_string($blueflood_cp_opts)                
  validate_string($command)
  if !is_integer($gid) { fail('The $gid parameter must be an integer number') }
  validate_string($group)
  validate_string($group_ensure)                  
  validate_string($package_name)                  
  validate_string($package_ensure)                
  validate_bool($service_autorestart)                
  validate_bool($service_enable)                
  validate_bool($service_manage)                
  validate_string($service_ensure)                
  validate_string($service_name)      
  if !is_integer($service_retries) { fail('The $service_retries parameter must be an integer number') }
  if !is_integer($service_startsecs) { fail('The $service_startsecs parameter must be an integer number') }
  if !is_integer($service_stopsecs) { fail('The $service_stopsecs parameter must be an integer number') }
  if !is_integer($service_stderr_logfile_keep) { fail('The $service_stderr_logfile_keep parameter must be an integer number') }
  validate_string($service_stderr_logfile_maxsize)
  if !is_integer($service_stdout_logfile_keep) { fail('The $service_stdout_logfile_keep parameter must be an integer number') }
  validate_string($service_stdout_logfile_maxsize)
  validate_absolute_path($shell)
  if !is_integer($uid) { fail('The $uid parameter must be an integer number') }
  validate_string($user)
  validate_string($user_description)
  validate_string($user_ensure)
  validate_absolute_path($user_home)
  validate_bool($user_manage)
  validate_bool($user_managehome)


  include '::blueflood::users'
  include '::blueflood::install'
  include '::blueflood::config'
  include '::blueflood::service'

  # Anchor this as per #8040 - this ensures that classes won't float off and
  # mess everything up. You can read about this at:
  # http://docs.puppetlabs.com/puppet/2.7/reference/lang_containment.html#known-issues
  anchor { 'blueflood::begin': }
  anchor { 'blueflood::end': }

  Anchor['blueflood::begin']
  -> Class['::blueflood::users']
  -> Class['::blueflood::install']
  -> Class['::blueflood::config']
  ~> Class['::blueflood::service']
  -> Anchor['blueflood::end']
}
