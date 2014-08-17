define carbon::cache(
) {

  concat::fragment { "cache_${title}":
    target  => "${prefix}/conf/carbon.conf",
    content => template('carbon/cache.erb'),
  }

}
