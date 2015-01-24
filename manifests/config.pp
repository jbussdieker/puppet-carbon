class carbon::config(
  $prefix = '/opt/graphite',
  $schemas = [],
) {

  concat { "${prefix}/conf/carbon.conf":
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
  }

  concat { "${prefix}/conf/storage-schemas.conf":
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
  }

  create_resources('carbon::schema', $schemas)

}
