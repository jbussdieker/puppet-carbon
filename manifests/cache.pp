define carbon::cache(
  $prefix = '/opt/graphite',
  $local_data_dir = '/opt/graphite/storage/whisper/',
  $user = '',
  $max_cache_size = 'inf',
  $max_updates_per_second = 500,
  $max_updates_per_second_on_shutdown = 1000,
  $max_creates_per_minute = 50,
  $line_receiver_interface = '0.0.0.0',
  $line_receiver_port = 2003,
  $enable_udp_listener = false,
  $udp_receiver_interface = '0.0.0.0',
  $udp_receiver_port = 2003,
  $pickle_receiver_interface = '0.0.0.0',
  $pickle_receiver_port = 2004,
  $use_insecure_unpickler = false,
  $cache_query_interface = '0.0.0.0',
  $cache_query_port = 7002,
  $use_flow_control = true,
  $log_updates = false,
  $log_cache_hits = false,
  $whisper_autoflush = false,
  $whisper_sparse_create = false,
  $whisper_fallocate_create = false,
  $whisper_lock_writes = false,
  $use_whitelist = false,
  $carbon_metric_prefix = 'carbon',
  $enable_amqp = false,
  $amqp_verbose = false,
  $amqp_host = 'localhost',
  $amqp_port = 5672,
  $amqp_vhost = '/',
  $amqp_user = 'guest',
  $amqp_password = 'guest',
  $amqp_exchange = 'graphite',
  $amqp_metric_name_in_body = false,
  $enable_manhole = false,
  $manhole_interface = '127.0.0.1',
  $manhole_port = 7222,
  $manhole_user = 'admin',
  $manhole_public_key = 'ssh-rsa AAAAB3NzaC1yc2EAAAABiwAaAIEAoxN0sv/e4eZCPpi3N3KYvyzRaBaMeS2RsOQ/cDuKv11dlNzVeiyc3RFmCv5Rjwn/lQ79y0zyHxw67qLyhQ/kDzINc4cY41ivuQXm2tPmgvexdrBv5nsfEpjs3gLZfJnyvlcVyWK/lId8WUvEWSWHTzsbtmXAF2raJMdgLTbQ8wE=',
  $bind_patterns = '#'
) {

  concat::fragment { "cache_${name}":
    target  => "${prefix}/conf/carbon.conf",
    content => template('carbon/cache.erb'),
    order   => 10,
    notify  => Service["carbon-cache-${name}"],
  }

  file { "/etc/init/carbon-cache-${name}.conf":
    ensure  => present,
    mode    => '0644',
    owner   => 'root',
    group   => 'root',
    content => template('carbon/cache.init.erb'),
    notify  => Service["carbon-cache-${name}"],
  }

  service { "carbon-cache-${name}":
    ensure  => running,
    require => File["/etc/init/carbon-cache-${name}.conf"],
  }

}
