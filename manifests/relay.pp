# == Class: carbon::relay
#
# Configures an instance of carbon-relay
#
define carbon::relay(
  $is_default = false,
  $line_receiver_interface = '0.0.0.0',
  $line_receiver_port = 2013,
  $pickle_receiver_interface = '0.0.0.0',
  $pickle_receiver_port = 2014,
  $relay_method = 'rules',
  $replication_factor = 1,
  $destinations = '127.0.0.1:2004',
  $max_queue_size = 10000,
  $max_datapoints_per_message = 500,
  $queue_low_watermark_pct = 0.8,
  $time_to_defer_sending = 0.0001,
  $use_flow_control = true,
  $use_whitelist = false,
  $carbon_metric_prefix = 'carbon',
  $carbon_metric_interval = 60,
  $log_listener_conn_success = true,
  $use_ratio_reset = false,
  $min_reset_stat_flow = 1000,
  $min_reset_ratio = 0.9,
  $min_reset_interval = 121
) {

  if $::carbon::user {
    $user = $::carbon::user
  } else {
    $user = ''
  }

  if $::carbon::prefix {
    $prefix = $::carbon::prefix
  } else {
    $prefix = '/opt/graphite'
  }

  $service_template = 'carbon/relay.initd.erb'
  $service_file = "/etc/init.d/carbon-relay-${name}"

  concat::fragment { "relay_${name}":
    target  => "${prefix}/conf/carbon.conf",
    content => template('carbon/relay.erb'),
    order   => 20,
    notify  => Service["carbon-relay-${name}"],
  }

  file { $service_file:
    ensure  => present,
    mode    => '0755',
    owner   => 'root',
    group   => 'root',
    content => template($service_template),
    notify  => Service["carbon-relay-${name}"],
    require => File["${prefix}/conf/carbon.conf"],
  }

  service { "carbon-relay-${name}":
    ensure  => running,
    enable  => true,
    require => [
      File[$service_file],
      File["${prefix}/conf/storage-schemas.conf"],
    ],
  }

}
