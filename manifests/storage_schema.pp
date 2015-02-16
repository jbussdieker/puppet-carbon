# == Class: carbon::storage_schema
#
# Configures a carbon storage schema entry
#
define carbon::storage_schema(
  $pattern,
  $retentions,
  $prefix = '/opt/graphite',
  $order = 10,
) {

  concat::fragment { $title:
    target  => "${prefix}/conf/storage-schemas.conf",
    content => template('carbon/storage-schema.erb'),
    order   => $order,
  }

}
