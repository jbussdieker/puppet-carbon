# Carbon

[![Puppet Forge](http://img.shields.io/puppetforge/v/jbussdieker/carbon.svg)](https://forge.puppetlabs.com/jbussdieker/carbon)
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

Same resources can be order dependent in which case the `order` property should be specified.

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
  order      => 1,
}

carbon::storage_schema { 'default':
  pattern    => '.*',
  retentions => '60:90d',
  order      => 99,
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
  order        => 1,
}

carbon::relay_rule { 'default':
  destinations => '127.0.0.1:2004:a',
  order        => 99,
}

```

## Advanced Example

Most resources can be passed into the main class as a hash to support Hiera usage.

```puppet
class { 'carbon':
  revision => 'master',
  caches      => {
    'a' => {
      line_receiver_port   => 2003,
      pickle_receiver_port => 2004,
      cache_query_port     => 7002,
    },
    'b' => {
      line_receiver_port   => 2103,
      pickle_receiver_port => 2104,
      cache_query_port     => 7102,
    }
  },
  relays      => {
    'a' => {
      relay_method         => 'consistent-hashing',
      line_receiver_port   => 2013,
      pickle_receiver_port => 2014,
    },
    'b' => {
      relay_method         => 'consistent-hashing',
      line_receiver_port   => 2113,
      pickle_receiver_port => 2114,
    }
  },
  aggregators => {
    'a' => {
      line_receiver_port   => 2023,
      pickle_receiver_port => 2024,
    },
    'b' => {
      line_receiver_port   => 2123,
      pickle_receiver_port => 2124,
    }
  },
  storage_schemas => {
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
  storage_aggregations => {
    'carbon_agg_test' => {
      pattern            => '^carbon\.',
      x_files_factor     => '0.7',
      aggregation_method => 'sum',
    },
  },
  aggregation_rules => {
    'rollups' => {
      output_template => 'foo.*',
      frequency       => '60',
      method          => 'sum',
      input_pattern   => 'bar.*',
    }
  },
  relay_rules => {
    'test1' => {
      pattern      => 'test1.*',
      destinations => '127.0.0.1:2004',
      continue     => true,
      order        => 1,
    },
    'default' => {
      destinations => '127.0.0.1:2004',
      continue     => false,
      order        => 99,
    },
  },
}
```
