# == Class: carbon::storage_schema
#
# Configures a carbon storage schema entry
#
define carbon::storage_schema(
  $pattern,
  $retentions,
  $order = 10,
) {

  if $::carbon::prefix {
    $prefix = $::carbon::prefix
  } else {
    $prefix = '/opt/graphite'
  }

  concat::fragment { $title:
    target  => "${prefix}/conf/storage-schemas.conf",
    content => template('carbon/storage-schema.erb'),
    order   => $order,
  }

}
