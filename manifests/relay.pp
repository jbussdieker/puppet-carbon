# == Class: carbon::relay
#
# Configures an instance of carbon-relay
#
define carbon::relay(
  $line_receiver_interface = undef,
  $line_receiver_port = undef,
  $pickle_receiver_interface = undef,
  $pickle_receiver_port = undef,
  $relay_method = undef,
  $replication_factor = undef,
  $destinations = undef,
  $max_queue_size = undef,
  $max_datapoints_per_message = undef,
  $queue_low_watermark_pct = undef,
  $time_to_defer_sending = undef,
  $use_flow_control = undef,
  $use_whitelist = undef,
  $carbon_metric_prefix = undef,
  $carbon_metric_interval = undef,
  $log_listener_conn_success = undef,
  $use_ratio_reset = undef,
  $min_reset_stat_flow = undef,
  $min_reset_ratio = undef,
  $min_reset_interval = undef,
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
    $service_template = 'carbon/relay.initd.erb'
    $service_file = "/etc/init.d/carbon-relay-${name}"

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
      tag     => 'carbon',
      require => [
        File[$service_file],
        File["${prefix}/conf/storage-schemas.conf"],
        Anchor['whisper::end'],
      ],
    }
    $fragment_notify = Service["carbon-relay-${name}"]
    $fragment_order = 40
  } else {
    $fragment_notify = []
    $fragment_order = 30
  }

  concat::fragment { "carbon_relay_${name}":
    target  => "${prefix}/conf/carbon.conf",
    content => template('carbon/relay.erb'),
    order   => $fragment_order,
    notify  => $fragment_notify,
  }

}
