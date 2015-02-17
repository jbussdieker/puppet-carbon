# == Class: carbon::cache
#
# Configures an instance of carbon-cache
#
define carbon::cache(
  $local_data_dir = undef,
  $max_cache_size = undef,
  $max_updates_per_second = undef,
  $max_updates_per_second_on_shutdown = undef,
  $max_creates_per_minute = undef,
  $line_receiver_interface = undef,
  $line_receiver_port = undef,
  $enable_udp_listener = undef,
  $udp_receiver_interface = undef,
  $udp_receiver_port = undef,
  $pickle_receiver_interface = undef,
  $pickle_receiver_port = undef,
  $use_insecure_unpickler = undef,
  $cache_query_interface = undef,
  $cache_query_port = undef,
  $use_flow_control = undef,
  $log_updates = undef,
  $log_cache_hits = undef,
  $whisper_autoflush = undef,
  $whisper_sparse_create = undef,
  $whisper_fallocate_create = undef,
  $whisper_lock_writes = undef,
  $use_whitelist = undef,
  $carbon_metric_prefix = undef,
  $carbon_metric_interval = undef,
  $enable_amqp = undef,
  $amqp_verbose = undef,
  $amqp_host = undef,
  $amqp_port = undef,
  $amqp_vhost = undef,
  $amqp_user = undef,
  $amqp_password = undef,
  $amqp_exchange = undef,
  $amqp_metric_name_in_body = undef,
  $enable_manhole = undef,
  $manhole_interface = undef,
  $manhole_port = undef,
  $manhole_user = undef,
  $manhole_public_key = undef,
  $bind_patterns = undef
) {

  $user = $::carbon::user

  if $::carbon::prefix {
    $prefix = $::carbon::prefix
  } else {
    $prefix = '/opt/graphite'
  }

  if $name != 'default' {
    $service_template = 'carbon/cache.initd.erb'
    $service_file = "/etc/init.d/carbon-cache-${name}"

    file { $service_file:
      ensure  => present,
      mode    => '0755',
      owner   => 'root',
      group   => 'root',
      content => template($service_template),
      notify  => Service["carbon-cache-${name}"],
      require => File["${prefix}/conf/carbon.conf"],
    }

    service { "carbon-cache-${name}":
      ensure  => running,
      enable  => true,
      require => [
        File[$service_file],
        File["${prefix}/conf/storage-schemas.conf"],
      ],
    }
    $fragment_notify = Service["carbon-cache-${name}"]
    $fragment_order = 20
  } else {
    $fragment_notify = []
    $fragment_order = 10
  }

  concat::fragment { "cache_${name}":
    target  => "${prefix}/conf/carbon.conf",
    content => template('carbon/cache.erb'),
    order   => $fragment_order,
    notify  => $fragment_notify,
  }

}
