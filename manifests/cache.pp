class carbon::cache(
  $prefix = '/opt/graphite'
) {

  concat::fragment { "cache_${title}":
    target  => "${prefix}/conf/carbon.conf",
    content => template('carbon/cache.erb'),
    order   => 10,
  }

  file { '/etc/init/carbon-cache.conf':
    ensure  => present,
    mode    => '0644',
    owner   => 'root',
    group   => 'root',
    content => template('carbon/cache.init.erb'),
    notify  => Service['carbon-cache'],
  }

  service { 'carbon-cache':
    ensure  => running,
    require => File['/etc/init/carbon-cache.conf'],
  }

}
