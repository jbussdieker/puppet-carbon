# == Class: carbon::whitelist
#
# Configures a carbon whitelist entry
#
define carbon::whitelist(
  $regex,
  $order = 10,
) {

  if $::carbon::prefix {
    $prefix = $::carbon::prefix
  } else {
    $prefix = '/opt/graphite'
  }

  concat::fragment { "carbon_whitelist_${title}":
    target  => "${prefix}/conf/whitelist.conf",
    content => template('carbon/whitelist.erb'),
    order   => $order,
  }

}
