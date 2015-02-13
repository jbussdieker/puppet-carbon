define carbon::schema(
  $prefix = '/opt/graphite',
  $order = 10,
  $pattern,
  $retentions
) {

  concat::fragment { $title:
    target  => "${prefix}/conf/storage-schemas.conf",
    content => template('carbon/schema.erb'),
    order   => $order,
  }

}
