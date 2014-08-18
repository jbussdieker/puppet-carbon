define carbon::schema($prefix = '/opt/graphite', $pattern, $retentions, $order = 10) {

  concat::fragment { $title:
    target  => "${prefix}/conf/storage-schemas.conf",
    content => template('carbon/schema.erb'),
    order   => $order,
  }

}
