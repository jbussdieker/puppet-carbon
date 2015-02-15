# == Class: carbon::schema
#
# Configures a carbon schema entry
#
define carbon::schema(
  $pattern,
  $retentions,
  $prefix = '/opt/graphite',
  $order = 10,
) {

  concat::fragment { $title:
    target  => "${prefix}/conf/storage-schemas.conf",
    content => template('carbon/schema.erb'),
    order   => $order,
  }

}
