# == Class: carbon::aggregation_rule
#
# Configures a carbon aggregation rule entry
#
define carbon::aggregation_rule(
  $output_template,
  $frequency,
  $method,
  $input_pattern,
  $order = 10,
) {

  if $::carbon::prefix {
    $prefix = $::carbon::prefix
  } else {
    $prefix = '/opt/graphite'
  }

  concat::fragment { $title:
    target  => "${prefix}/conf/aggregation-rules.conf",
    content => template('carbon/aggregation_rule.erb'),
    order   => $order,
  }

}
