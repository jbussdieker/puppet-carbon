# == Class: carbon::aggregator
#
# Configures an instance of carbon-aggregator
#
define carbon::aggregator(
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

  if $name != 'default' {
    $service_template = 'carbon/aggregator.initd.erb'
    $service_file = "/etc/init.d/carbon-aggregator-${name}"

    file { $service_file:
      ensure  => present,
      mode    => '0755',
      owner   => 'root',
      group   => 'root',
      content => template($service_template),
      notify  => Service["carbon-aggregator-${name}"],
      require => File["${prefix}/conf/carbon.conf"],
    }

    service { "carbon-aggregator-${name}":
      ensure  => running,
      enable  => true,
      require => [
        File[$service_file],
        File["${prefix}/conf/storage-schemas.conf"],
      ],
    }
    $fragment_notify = Service["carbon-aggregator-${name}"]
  } else {
    $fragment_notify = []
  }

  concat::fragment { "aggregator_${name}":
    target  => "${prefix}/conf/carbon.conf",
    content => template('carbon/aggregator.erb'),
    order   => 30,
    notify  => $fragment_notify,
  }

}
