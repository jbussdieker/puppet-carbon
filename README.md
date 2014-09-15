# Carbon

[![Build Status](https://travis-ci.org/jbussdieker/puppet-carbon.svg?branch=master)](https://travis-ci.org/jbussdieker/puppet-carbon)

### Beginning with Carbon

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
