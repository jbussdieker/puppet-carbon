# == Class: carbon::blacklist
#
# Configures a carbon blacklist entry
#
define carbon::blacklist(
  $regex,
  $order = 10,
) {

  if $::carbon::prefix {
    $prefix = $::carbon::prefix
  } else {
    $prefix = '/opt/graphite'
  }

  concat::fragment { "carbon_blacklist_${title}":
    target  => "${prefix}/conf/blacklist.conf",
    content => template('carbon/blacklist.erb'),
    order   => $order,
  }

}
