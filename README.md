# Carbon

[![Build Status](https://travis-ci.org/jbussdieker/puppet-carbon.svg?branch=master)](https://travis-ci.org/jbussdieker/puppet-carbon)

## Beginning with Carbon

To install Carbon with the default parameters

```puppet
class { 'carbon': }
```

Installing a specific version

```puppet
class { 'carbon':
  revision => '0.9.11',
}
```

Installing and configuring using Hiera

```yaml
classes:
 - carbon
carbon::revision: 0.9.11
```

## Resources

### Aggregation Rules

```puppet
carbon::aggregation_rule { 'rollup':
  output_template => 'foo.*',
  frequency       => '60',
  method          => 'sum',
  input_pattern   => 'bar.*',
}
```

### Storage Schema

```puppet
carbon::storage_schema { 'carbon':
  pattern    => '^carbon\.',
  retentions => '60:90d',
}
```

### Storage Aggregation

```puppet
carbon::storage_aggregation { 'sum':
  pattern            => '\.count$',
  x_files_factor     => 0,
  aggregation_method => 'sum',
}
```

### Relay Rules

```puppet
carbon::relay_rule { 'auditing':
  pattern      => 'auditing.*',
  destinations => '1.2.3.4:2004:a',
}

carbon::relay_rule { 'default':
  destinations => '127.0.0.1:2004:a',
}

```
