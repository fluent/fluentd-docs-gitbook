# elasticsearch

![](../.gitbook/assets/elasticsearch%20%283%29.png)

The `out_elasticsearch` Output plugin writes records into Elasticsearch. By default, it creates records using [bulk api](https://www.elastic.co/guide/en/elasticsearch/reference/current/docs-bulk.html) which performs multiple indexing operations in a single API call. This reduces overhead and can greatly increase indexing speed. This means that when you first import records using the plugin, records are not immediately pushed to Elasticsearch.

Records will be sent to Elasticsearch when the `chunk_keys` condition has been met. To change the output frequency, please specify the `time` in `chunk_keys` and specify `timekey` value in the configuration.

This document does not describe all the parameters. For details, refer to the **Further Reading** section.

## Installation

Since `out_elasticsearch` has been included in the standard distribution of `td-agent` since v3.0.1, `td-agent` users do not need to install it manually.

If you have installed Fluentd without `td-agent`, please install this plugin using `fluent-gem`:

```text
$ fluent-gem install fluent-plugin-elasticsearch
```

## Example Configuration

Here is a simple working configuration which should serve as a good starting point for most users:

```text
<match my.logs>
  @type elasticsearch
  host localhost
  port 9200
  logstash_format true
</match>
```

For more details on each option, read the section on [Parameters](elasticsearch.md#parameters).

## Plugin Helpers

* [`event_emitter`](../plugin-helper-overview/api-plugin-helper-event_emitter.md)
* [`compat_parameters`](../plugin-helper-overview/api-plugin-helper-compat_parameters.md)

## Parameters

### `@type` \(required\)

This option must be always `elasticsearch`.

### `host` \(optional\)

The hostname of your Elasticsearch node \(default: `localhost`\).

### `port` \(optional\)

The port number of your Elasticsearch node \(default: `9200`\).

### `hosts` \(optional\)

If you want to connect to more than one Elasticsearch nodes, specify this option in the following format:

```text
hosts host1:port1,host2:port2,host3:port3
# or
hosts https://customhost.com:443/path,https://username:password@host-failover.com:443
```

If you use this option, the `host` and `port` options are ignored.

### `user`, `password` \(optional\)

The login credentials to connect to the Elasticsearch node \(default: `nil`\):

```text
user fluent
password mysecret
```

### `scheme` \(optional\)

Specify `https` if your Elasticsearch endpoint supports SSL \(default: `http`\).

### `path` \(optional\)

The REST API endpoint of Elasticsearch to post write requests \(default: `nil`\).

### `index_name` \(optional\)

The index name to write events to \(default: `fluentd`\).

This option supports the placeholder syntax of Fluentd plugin API. For example, if you want to partition the index by tags, you can specify it like this:

```text
index_name fluentd.${tag}
```

Here is a more practical example which partitions the Elasticsearch index by tags and timestamps:

```text
index_name fluentd.${tag}.%Y%m%d
```

Time placeholder needs to set up tag and time in `chunk_keys`. Also, it needs to specify timekey for time slice of chunk:

```text
<buffer tag, time>
  timekey 1h # chunks per hours ("3600" also available)
</buffer>
```

For more information about buffer options checkout the [Buffer Section Configuration](../configuration/buffer-section.md).

### `logstash_format` \(optional\)

If `true`, Fluentd uses the conventional index name format `logstash-%Y.%m.%d` \(default: `false`\). This option supersedes the `index_name` option.

#### `@log_level` option

The `@log_level` option allows the user to set different levels of logging for each plugin.

Supported log levels: `fatal`, `error`, `warn`, `info`, `debug`, `trace`.

Please see the [logging article](../deployment/logging.md) for further details.

### `logstash_prefix` \(optional\)

The logstash prefix index name to write events when `logstash_format` is `true` \(default: `logstash`\).

## Miscellaneous

You can use `%{}` style placeholders to escape for URL encoding needed characters.

Valid configuration:

```text
user %{demo+}
password %{@secret}
```

Valid configuration:

```text
hosts https://%{j+hn}:%{passw@rd}@host1:443/elastic/,http://host2
```

Invalid configuration:

```text
user demo+
password @secret
```

## Common Output / Buffer parameters

For common output / buffer parameters, please check the following articles:

* [Output Plugin Overview](./)
* [Buffer Section Configuration](../configuration/buffer-section.md)

## Troubleshooting

Please refer to the [Elasticsearch's troubleshooting](https://github.com/uken/fluent-plugin-elasticsearch#troubleshooting) section.

## Further Reading

* [`fluent-plugin-elasticsearch`](https://github.com/uken/fluent-plugin-elasticsearch)

If this article is incorrect or outdated, or omits critical information, please [let us know](https://github.com/fluent/fluentd-docs-gitbook/issues?state=open). [Fluentd](http://www.fluentd.org/) is an open-source project under [Cloud Native Computing Foundation \(CNCF\)](https://cncf.io/). All components are available under the Apache 2 License.

