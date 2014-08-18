class carbon(
  $prefix = '/opt/graphite',
  $source = 'https://github.com/graphite-project/carbon.git',
  $path = '/usr/local/src/carbon',
  $revision = 'master',
  $schemas = {
    'carbon' => {
      pattern    => '^carbon\.',
      retentions => '60:90d',
    },
    'default_1min_for_1day' => {
      pattern    => '.*',
      retentions => '60s:1d',
    },
  },
) {

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
    owner => 'root',
    group => 'root',
    mode  => '0644',
  }

  concat { "${prefix}/conf/storage-schemas.conf":
    owner => 'root',
    group => 'root',
    mode  => '0644',
  }

  create_resources('carbon::schema', $schemas)

}
