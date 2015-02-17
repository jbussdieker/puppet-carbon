# == Class: carbon
#
# Main class to install and configure carbon from package (default) or from 
# source.
#
# === Examples
#
# Install default operating system Carbon.
#
#  class { 'carbon': }
#
# Install specific version of Carbon
#
#  class { 'carbon': }
#    revision => '0.9.11',
#  }
#
# === Authors
#
# Joshua B. Bussdieker <jbussdieker@gmail.com>
#
# === Copyright
#
# Copyright 2015 Joshua B. Bussdieker, unless otherwise noted.
#
class carbon(
  $prefix = '/opt/graphite',
  $source = 'https://github.com/graphite-project/carbon.git',
  $path = '/usr/local/src/carbon',
  $revision = 'master',
  $user = undef,
  $caches = {},
  $relays = {},
  $aggregators = {},
  $storage_schemas = {
    'carbon' => {
      pattern    => '^carbon\.',
      retentions => '60:90d',
      order      => 1,
    },
    'default_1min_for_1day' => {
      pattern    => '.*',
      retentions => '60s:1d',
      order      => 99,
    },
  },
  $aggregation_rules = {},
  $relay_rules = {
    'default' => {
      destinations => '127.0.0.1:2004:a, 127.0.0.1:2104:b',
    },
  },
  $storage_aggregations = {
    'min' => {
      pattern            => '\.min$',
      x_files_factor     => 0.1,
      aggregation_method => 'sum',
      order              => 1,
    },
    'max' => {
      pattern            => '\.max$',
      x_files_factor     => 0.1,
      aggregation_method => 'max',
      order              => 2,
    },
    'sum' => {
      pattern            => '\.count$',
      x_files_factor     => 0,
      aggregation_method => 'sum',
      order              => 3,
    },
    'default_average' => {
      pattern            => '.*',
      x_files_factor     => 0.5,
      aggregation_method => 'average',
      order              => 4,
    },
  },
) {

  if $user {
    $real_user = $user
  } else {
    $real_user = 'root'
  }

  package { 'python-twisted':
    ensure => present,
  }

  vcsrepo { $path:
    ensure   => present,
    revision => $revision,
    source   => $source,
    provider => git,
  }

  exec { 'install_carbon':
    cwd     => $path,
    command => "/usr/bin/python setup.py install --install-lib ${prefix}/lib --prefix ${prefix}",
    creates => "${prefix}/bin/carbon-cache.py",
    require => Vcsrepo[$path],
  }

  file { $prefix:
    ensure  => directory,
    require => Exec['install_carbon'],
  }

  file { "${prefix}/conf":
    ensure => directory,
  }

  file { "${prefix}/storage":
    ensure => directory,
  }

  file { "${prefix}/storage/whisper":
    ensure => directory,
    owner  => $user,
    group  => $user,
  }

  concat { "${prefix}/conf/carbon.conf":
    owner => 'root',
    group => 'root',
    mode  => '0644',
    force => true,
  }

  concat { "${prefix}/conf/storage-schemas.conf":
    owner => 'root',
    group => 'root',
    mode  => '0644',
    force => true,
  }

  concat { "${prefix}/conf/storage-aggregation.conf":
    owner => 'root',
    group => 'root',
    mode  => '0644',
    force => true,
  }

  concat { "${prefix}/conf/aggregation-rules.conf":
    owner => 'root',
    group => 'root',
    mode  => '0644',
    force => true,
  }

  concat { "${prefix}/conf/relay-rules.conf":
    owner => 'root',
    group => 'root',
    mode  => '0644',
    force => true,
  }

  concat { "${prefix}/conf/whitelist.conf":
    owner => 'root',
    group => 'root',
    mode  => '0644',
    force => true,
  }

  concat { "${prefix}/conf/blacklist.conf":
    owner => 'root',
    group => 'root',
    mode  => '0644',
    force => true,
  }

  create_resources('carbon::storage_schema', $storage_schemas)
  create_resources('carbon::storage_aggregation', $storage_aggregations)
  create_resources('carbon::aggregation_rule', $aggregation_rules)
  create_resources('carbon::relay_rule', $relay_rules)

  create_resources('carbon::cache', $caches)
  create_resources('carbon::relay', $relays)
  create_resources('carbon::aggregator', $aggregators)

}
