class carbon(
  $prefix = '/opt/graphite',
  $source = 'https://github.com/graphite-project/carbon.git',
  $path = '/usr/local/src/carbon',
  $revision = 'master',
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
  }

}
