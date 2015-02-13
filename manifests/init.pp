# == Class: carbon
#
# Main class to install and configure carbon from package (default) or from source.
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
) {

  class { 'carbon::install':
    prefix   => $prefix,
    source   => $source,
    path     => $path,
    revision => $revision,
  }

  class { 'carbon::config':
    prefix  => $prefix,
    caches  => $caches,
    relays  => $relays,
    schemas => $schemas,
    require => Class['carbon::install'],
  }

}
