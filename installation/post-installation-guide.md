# Post Installation Guide

This article discusses the post-installation steps for new Fluentd users assuming that Fluentd has been installed using the `td-agent` package.

## System Administration

### For `td-agent`

#### Configuration File

After successful installation, a `td-agent` instance will be up and running with a predefined template configuration file.

The default path for this configuration file is:

```text
/etc/td-agent/td-agent.conf
```

You may edit this configuration file according to your own use case.

After editing the configuration file, restart `td-agent` using `systemctl` command:

```text
$ sudo systemctl restart td-agent
```

#### Logging

By default, `td-agent` writes its operation logs to the following file:

```text
/var/log/td-agent/td-agent.log
```

For more verbose logs, read the article on [Troubleshooting](../deployment/trouble-shooting.md).

### For `calyptia-fluentd`

#### Configuration File

After the successful installation, a `calyptia-fluentd` instance will be up and running with a predefined template configuration file.

The default path for this configuration file is:

```text
/etc/calyptia-fluentd/calyptia-fluentd.conf
```

You may edit this configuration file according to your own use case.

After editing the configuration file, restart `calyptia-fluentd` using `systemctl` command:

```text
$ sudo systemctl restart calyptia-fluentd
```

#### Logging

By default, `calyptia-fluentd` writes its operation logs to the following file:

```text
/var/log/calyptia-fluentd/calyptia-fluentd.log
```

For more verbose logs, read the article on [Troubleshooting](../deployment/trouble-shooting.md).

## Connect to the Other Services

### How It Works

In Fluentd, the most important part of data input/output is managed by plugins. Each plugin knows how to interface with an external endpoint and is solely responsible for managing one pipeline to forward data streams.

Plugins use a certain naming convention. For example, if it receives data and interfaces with Apache Kafka, it is called `in_kafka`. In the same way, if it publishes data and connects to MongoDB, it is called `out_mongo`.

The following configuration uses the `in_forward` plugin as an input source and `out_file` plugin as an output endpoint:

```text
<source>
  @type forward
  port 9999
</source>
<match app.**>
  @type file
  path /var/log/app/data.log
  compress gzip
</match>
```

### Plugin Management

Fluentd manages plugins as Ruby gems but stores them in their dedicated directory separated from the normal Ruby gems.

#### `td-agent`

A special program `td-agent-gem` is used to manage plugin gems. For example, the following command installs a plugin to connect to S3 \(including both `in_s3` and `out_s3` plugins\):

```text
 $ sudo /usr/sbin/td-agent-gem install fluent-plugin-s3
```

#### `calyptia-fluentd`

A special program `calyptia-fluentd-gem` is used to manage plugin gems. For example, the following command installs a plugin to connect to S3 \(including both `in_s3` and `out_s3` plugins\):

```text
 $ sudo /usr/sbin/calyptia-fluentd-gem install fluent-plugin-s3
```

### Available Plugins

See the [List Of All Plugins](https://www.fluentd.org/plugins) to explore the available third-party plugins.

Note that a number of plugins are bundled with the standard distribution of `td-agent` so you do not need to install them manually.

## Configuration Syntax

### Data Source

A configuration file consists of a number of setting blocks or sections e.g. `<source>`. Each block contains a set of options for a specific data endpoint.

For example, if you want to create an endpoint to receive data from [syslog](../input/syslog.md), you need to add a `<source>` block and set up its settings like this:

```text
<source>
  @type syslog
  port 5140
  tag system
</source>
```

The `@type` parameter specifies which plugin to use. Note that the plugin type prefix i.e. `in_`, `out_`, etc. is not needed here. In this example, the input plugin is specified as `syslog`, not `in_syslog`.

### Output Endpoint

To add an output endpoint for the data stream, you need to define a `<match>` block. Syntactically, `<match>` is slightly different from `<source>` in the sense that it requires a filter expression as an argument.

For example, if you want to output events tagged with `debug.log`, you need to mention this tag as an argument in `<match>` like this:

```text
<match debug.log>
  @type kafka2
  port 5140
  brokers kafka-server:9092
  tag system
  # ...
</match>
```

The wildcard character `*` can be used in the filter expression. For example, `debug.*` matches `debug.log`, `debug.foo`, etc.

To catch all the descendent tags, use double asterisks `**`. For example, `debug.**` matches not only `debug.log`, but also `debug.log.bar` or `debug.log.level.critical`, etc.

### Further Reading

* [Configuration File Syntax](../configuration/config-file.md)

If this article is incorrect or outdated, or omits critical information, please [let us know](https://github.com/fluent/fluentd-docs-gitbook/issues?state=open). [Fluentd](http://www.fluentd.org/) is an open-source project under [Cloud Native Computing Foundation \(CNCF\)](https://cncf.io/). All components are available under the Apache 2 License.

