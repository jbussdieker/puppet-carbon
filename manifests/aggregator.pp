# == Class: carbon::aggregator
#
# Configures an instance of carbon-aggregator
#
define carbon::aggregator(
  $is_default = false,
  $prefix = '/opt/graphite',
  $line_receiver_interface = '0.0.0.0',
  $line_receiver_port = 2023,
  $pickle_receiver_interface = '0.0.0.0',
  $pickle_receiver_port = 2024,
  $rules = 'aggregation-rules.conf',
  $destinations = '127.0.0.1:2004',
  $replication_factor = 1,
  $max_queue_size = 10000,
  $use_flow_control = true,
  $max_datapoints_per_message = 500,
  $max_aggregation_intervals = 5,
  $write_back_frequency = 0,
  $use_whitelist = false,
  $carbon_metric_prefix = 'carbon',
  $carbon_metric_interval = 60,
  $log_listener_conn_success = true,
) {

  concat::fragment { "aggregator_${name}":
    target  => "${prefix}/conf/carbon.conf",
    content => template('carbon/aggregator.erb'),
    order   => 30,
  }

  file { "/etc/init/carbon-aggregator-${name}.conf":
    ensure  => present,
    mode    => '0644',
    owner   => 'root',
    group   => 'root',
    content => template('carbon/aggregator.init.erb'),
    notify  => Service["carbon-aggregator-${name}"],
    require => File["${prefix}/conf/carbon.conf"],
  }

  service { "carbon-aggregator-${name}":
    ensure  => running,
    enable  => true,
    require => File["/etc/init/carbon-aggregator-${name}.conf"],
  }

}
