# == Class: carbon::aggregation
#
# Configures a carbon aggregation entry
#
define carbon::aggregation(
  $output_template,
  $frequency,
  $method,
  $input_pattern,
  $prefix = '/opt/graphite',
  $order = 10,
) {

  concat::fragment { $title:
    target  => "${prefix}/conf/aggregation-rules.conf",
    content => template('carbon/aggregation.erb'),
    order   => $order,
  }

}
