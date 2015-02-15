# == Class: carbon::aggregation_rule
#
# Configures a carbon aggregation rule entry
#
define carbon::aggregation_rule(
  $output_template = '',
  $frequency = '',
  $method = '',
  $input_pattern = '',
  $prefix = '/opt/graphite',
  $order = 10,
) {

  concat::fragment { $title:
    target  => "${prefix}/conf/aggregation-rules.conf",
    content => template('carbon/aggregation_rule.erb'),
    order   => $order,
  }

}
