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
  $caches = {},
  $relays = {},
  $aggregators = {},
  $schemas = {
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
  $aggregations = {},
) {

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
    command => "/usr/bin/python setup.py install --prefix ${prefix}",
    creates => "${prefix}/bin/carbon-cache.py",
    require => Vcsrepo[$path],
  }

  concat { "${prefix}/conf/carbon.conf":
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    require => Exec['install_carbon'],
  }

  concat::fragment { 'header':
    target  => "${prefix}/conf/carbon.conf",
    content => "### PUPPET MANAGED ###\n",
    order   => 1,
  }

  concat { "${prefix}/conf/storage-schemas.conf":
    owner => 'root',
    group => 'root',
    mode  => '0644',
  }

  concat { "${prefix}/conf/aggregation-rules.conf":
    owner => 'root',
    group => 'root',
    mode  => '0644',
  }

  create_resources('carbon::schema', $schemas)
  create_resources('carbon::aggregation', $aggregations)

  create_resources('carbon::cache', $caches)
  create_resources('carbon::relay', $relays)
  create_resources('carbon::aggregator', $aggregators)

}
