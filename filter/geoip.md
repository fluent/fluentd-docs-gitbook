# geoip

The `filter_geoip` Filter plugin adds geographic location information to logs using the Maxmind GeoIP databases.

This document does not describe all the parameters. If you want to know full features, check the Further Reading section.

## Prerequisites

Install GeoIP library:

```text
# for RHEL/CentOS
$ sudo yum group install "Development Tools"
$ sudo yum install geoip-devel --enablerepo=epel

# for Ubuntu/Debian
$ sudo apt install build-essential
$ sudo apt install libgeoip-dev

# for macOS (brew)
$ brew install geoip
```

`libmaxminddb` for GeoIP2 is bundled with `geoip2_c`.

## Install

`filter_geoip` is not included in `td-agent`. All users must install the `fluent-plugin-geoip` gem using the following command:

```text
$ fluent-gem install fluent-plugin-geoip
$ sudo /usr/sbin/td-agent-gem install fluent-plugin-geoip
```

For more details, see [Plugin Management](../deployment/plugin-management.md).

## Example Configuration

This configuration adds the geolocation information to `apache.access`:

```text
<filter access.apache>
  @type geoip

  # Specify one or more geoip lookup field which has ip address (default: host)
  geoip_lookup_keys  host

  # Specify optional geoip database (using bundled GeoLiteCity database by default)
  # geoip_database    "/path/to/your/GeoIPCity.dat"
  # Specify optional geoip2 database (using bundled GeoLite2 database by default)
  # geoip2_database   "/path/to/your/GeoLite2-City.mmdb"
  # Specify backend library (geoip2_c, geoip, geoip2_compat)
  backend_library geoip2_c

  # Set adding field with placeholder (more than one settings are required.)
  <record>
    city            ${city.names.en["host"]}
    latitude        ${location.latitude["host"]}
    longitude       ${location.longitude["host"]}
    country         ${country.iso_code["host"]}
    country_name    ${country.names.en["host"]}
    postal_code     ${postal.code["host"]}
    region_code     ${subdivisions.0.iso_code["host"]}
    region_name     ${subdivisions.0.names.en["host"]}
  </record>

  # To avoid get stacktrace error with `[null, null]` array for elasticsearch.
  skip_adding_null_record  true
</filter>
```

See [fluent-plugin-geoip README](https://github.com/y-ken/fluent-plugin-geoip#readme) for further details.

## Plugin helpers

* [`compat_parameters`](../plugin-helper-overview/api-plugin-helper-compat_parameters.md)
* [`inject`](../plugin-helper-overview/api-plugin-helper-inject.md)

## Parameters

See [Common Parameters](../configuration/plugin-common-parameters.md).

### `geoip_database`

| type | default | version |
| :--- | :--- | :--- |
| string | bundled | 1.0.0 |

Path to GeoIP database file.

### `geoip2_database`

| type | default | version |
| :--- | :--- | :--- |
| string | bundled | 1.0.0 |

Path to GeoIP2 database file.

### `geoip_lookup_keys`

| type | default | version |
| :---: | :---: | :---: |
| array | \["host"\] | 1.2.0 |

Specifies one or more geoip lookup fields containing the IP address.

See [`record_accessor`](../plugin-helper-overview/api-plugin-helper-record_accessor.md) about nested attributes.

**NOTE**: Since v1.3.0 does not interpret `host.ip` as a nested attribute.

### `geoip_lookup_key`

| type | default | version |
| :--- | :--- | :--- |
| string | host | 1.0.0 |

Specifies one or more geoip lookup fields containing the ip address.

This parameter has been deprecated since v1.2.0.

### `skip_adding_null_record`

| type | default | version |
| :--- | :--- | :--- |
| bool | false | 1.0.0 |

Set to `true` to skip adding the field with `[null, null]` array.

This is useful for Elasticsearch.

### `backend_library`

| type | default | available values | version |
| :--- | :--- | :--- | :--- |
| enum | geoip2\_c | geoip, geoip2\_compat, geoip2\_c | 1.0.0 |

Set backend library.

## Use cases

#### Plot Realtime Access Statistics on a World Map using Elasticsearch and Kibana

The `country_code` field is needed to visualize access statistics on a world map using [Kibana](http://www.elasticsearch.org/overview/kibana/).

Required plugins:

* `fluent-plugin-geoip`
* `fluent-plugin-elasticsearch`

```text
<filter apache.access>
  @type geoip
  backend_library geoip2_c

  # Set key name for the client ip address values
  geoip_lookup_keys     host

  # Specify key name for the country_code values
  <record>
    country_code ${country.iso_code["host"]}
    country_name ${country.names.en["host"]}
  </record>
</filter>

<match apache.access>
  @type           elasticsearch
  host            localhost
  port            9200
  type_name       apache
  logstash_format true
  flush_interval  10s
</match>
```

## Further Reading

* [`fluent-plugin-geoip`](https://github.com/y-ken/fluent-plugin-geoip)

If this article is incorrect or outdated, or omits critical information, please [let us know](https://github.com/fluent/fluentd-docs-gitbook/issues?state=open). [Fluentd](http://www.fluentd.org/) is an open-source project under [Cloud Native Computing Foundation \(CNCF\)](https://cncf.io/). All components are available under the Apache 2 License.

