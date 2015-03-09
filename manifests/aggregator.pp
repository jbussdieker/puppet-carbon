# == Class: carbon::aggregator
#
# Configures an instance of carbon-aggregator
#
define carbon::aggregator(
  $line_receiver_interface = undef,
  $line_receiver_port = undef,
  $pickle_receiver_interface = undef,
  $pickle_receiver_port = undef,
  $rules = undef,
  $destinations = undef,
  $replication_factor = undef,
  $max_queue_size = undef,
  $use_flow_control = undef,
  $max_datapoints_per_message = undef,
  $max_aggregation_intervals = undef,
  $write_back_frequency = undef,
  $use_whitelist = undef,
  $carbon_metric_prefix = undef,
  $carbon_metric_interval = undef,
  $log_listener_conn_success = undef,
) {

  $user = $::carbon::user

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
        Anchor['whisper::end'],
      ],
    }
    $fragment_notify = Service["carbon-aggregator-${name}"]
    $fragment_order = 60
  } else {
    $fragment_notify = []
    $fragment_order = 50
  }

  concat::fragment { "aggregator_${name}":
    target  => "${prefix}/conf/carbon.conf",
    content => template('carbon/aggregator.erb'),
    order   => $fragment_order,
    notify  => $fragment_notify,
  }

}
