# == Class: carbon::relay_rule
#
# Configures a carbon relay rule entry
#
define carbon::relay_rule(
  $destinations,
  $pattern = undef,
  $continue = undef,
  $order = 10,
) {

  if $::carbon::prefix {
    $prefix = $::carbon::prefix
  } else {
    $prefix = '/opt/graphite'
  }

  concat::fragment { "carbon_relay_rule_${title}":
    target  => "${prefix}/conf/relay-rules.conf",
    content => template('carbon/relay_rule.erb'),
    order   => $order,
  }

}
