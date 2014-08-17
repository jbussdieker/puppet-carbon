define carbon::cache(
  $prefix = '/opt/graphite'
) {

  concat::fragment { "cache_${title}":
    target  => "${prefix}/conf/carbon.conf",
    content => template('carbon/cache.erb'),
    order   => 10,
  }

}
