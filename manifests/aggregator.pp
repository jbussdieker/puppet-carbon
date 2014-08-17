class carbon::aggregator(
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

  concat::fragment { 'aggregator':
    target  => "${prefix}/conf/carbon.conf",
    content => template('carbon/aggregator.erb'),
    order   => 30,
  }

}
