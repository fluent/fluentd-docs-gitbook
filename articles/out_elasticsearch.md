# Elasticsearch Output Plugin

The `out_elasticsearch` Output plugin writes records into Elasticsearch.
By default, it creates records by bulk write operation. This means that
when you first import records using the plugin, no record is created
immediately.

The record will be created when the `chunk_keys` condition has been met.
To change the output frequency, please specify the `time` in chunk\_keys
and specify `timekey` value in conf.

This document doesn\'t describe all parameters. If you want to know full
features, check the Further Reading section.


## Installation

Since `out_elasticsearch` has been included in the standard distribution
of td-agent since v3.0.1, td-agent users do not need to install it
manually.

If you have installed Fluentd without td-agent, please install this
plugin using `fluent-gem`.

``` {.CodeRay}
$ fluent-gem install fluent-plugin-elasticsearch
```


## Example Configuration

The following is a simple working configuration. This should serve as a
good starting point for most users.

``` {.CodeRay}
<match my.logs>
  @type elasticsearch
  host localhost
  port 9200
  logstash_format true
</match>
```

For more details on each option, read [the section on
Parameters](#parameters).


## Plugin helpers

-   [event\_emitter](/articles/api-plugin-helper-event_emitter.md)
-   [compat\_parameters](/articles/api-plugin-helper-compat_parameters.md)


## Parameters

[]{#@type-(required)}

### \@type (required)

This option must be always `elasticsearch`.


### host (optional)

The hostname of your Elasticsearch node (default: `localhost`).


### port (optional)

The port number of your Elasticsearch node (default: `9200`).


### hosts (optional)

If you want to connect to more than one Elasticsearch nodes, specify
this option in the following format:

``` {.CodeRay}
hosts host1:port1,host2:port2,host3:port3
# or
hosts https://customhost.com:443/path,https://username:password@host-failover.com:443
```

If you use this option, the `host` and `port` options are ignored.


### user, password (optional)

The login credentials to connect to the Elasticsearch node (default:
`nil`)

``` {.CodeRay}
user fluent
password mysecret
```


### scheme (optional)

Specify `https` if your Elasticsearch endpoint supports SSL (default:
`http`)


### path (optional)

The REST API endpoint of Elasticsearch to post write requests (default:
`nil`)


### index\_name (optional)

The index name to write events to (default: `fluentd`).

This option supports the placeholder syntax of Fluentd plugin API. For
example, if you want to partition the index by tags, you can specify as
below:

``` {.CodeRay}
index_name fluentd.${tag}
```

Here is a more practical example which partitions the Elasticsearch
index by tags and timestamps:

``` {.CodeRay}
index_name fluentd.${tag}.%Y%m%d
```

Time placeholder needs to set up tag and time in chunk\_keys. Also it
needs to specify timekey for time slice of chunk:

``` {.CodeRay}
<buffer tag, time>
  timekey 1h # chunks per hours ("3600" also available)
</buffer>
```


### logstash\_format (optional)

With this option set `true`, Fluentd uses the conventional index name
format `logstash-%Y.%m.%d` (default: `false`). This option supersedes
the `index_name` option.

#### \@log\_level option

The `@log_level` option allows the user to set different levels of
logging for each plugin. The supported log levels are: `fatal`, `error`,
`warn`, `info`, `debug`, and `trace`.

Please see the [logging article](/articles/logging.md) for further details.


## Miscellaneous

You can use `%{}` style placeholders to escape for URL encoding needed
characters.

``` {.CodeRay}
user %{demo+}
password %{@secret}
```

are valid configuration.

``` {.CodeRay}
hosts https://%{j+hn}:%{passw@rd}@host1:443/elastic/,http://host2
```

are also valid configuration.

But,

``` {.CodeRay}
user demo+
password @secret
```

are invalid configuration.


## Common Output / Buffer parameters

For common output / buffer parameters, please check the following
articles.

-   [Output Plugin Overview](/articles/output-plugin-overview.md)
-   [Buffer Section Configuration](/articles/buffer-section.md)


## Troubleshooting

Please refer to [the elasticsearch README's troubleshooting
section](https://github.com/uken/fluent-plugin-elasticsearch#troubleshooting).


## Further Reading

-   [fluent-plugin-elasticsearch
    repository](https://github.com/uken/fluent-plugin-elasticsearch)


------------------------------------------------------------------------

If this article is incorrect or outdated, or omits critical information,
please [let us know](https://github.com/fluent/fluentd-docs/issues?state=open).
[Fluentd](http://www.fluentd.org/) is a open source project under [Cloud Native Computing Foundation (CNCF)](https://cncf.io/). All components
are available under the Apache 2 License.
