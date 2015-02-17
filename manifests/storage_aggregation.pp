# == Class: carbon::storage_aggregation
#
# Configures a carbon storage aggregation entry
#
define carbon::storage_aggregation(
  $pattern,
  $x_files_factor = undef,
  $aggregation_method = undef,
  $order = 10,
) {

  if $::carbon::prefix {
    $prefix = $::carbon::prefix
  } else {
    $prefix = '/opt/graphite'
  }

  concat::fragment { $title:
    target  => "${prefix}/conf/storage-aggregation.conf",
    content => template('carbon/storage-aggregation.erb'),
    order   => $order,
  }

}
