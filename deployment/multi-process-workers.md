# Multi Process Workers

This article describes how to use Fluentd's multi process workers
feature for high traffic. This feature launches two or more fluentd
workers to utilize multiple CPU powers.

This feature can replace fluent-plugin-multiprocess with simple way.


## How it works

By default, fluentd launches 1 supervisor and 1 worker in 1 instance. A
worker consists of input/filter/output plugins.

Multi process workers feature launches multiple workers in 1 instance
and use 1 process for each worker. In addition, fluentd provides several
features for multi process workers, so you can get multi process merits
with simple way.

![](/images/multi-process-workers.png)


## Configuration


### workers parameter

`<system>` directive has `workers` parameter for specifying the number
of workers.

```
<system>
  workers 4
</system>
```

With this configuration, fluentd launches 4 workers.


### &lt;worker N&gt; directive

Some plugins don't work on multi process worker, e.g. `in_tail`. For
such plugins, we can run any plugins in specific worker with
`<worker N>`. `N` is 0-origin worker index. For example, if you put
`<worker 0>`, plugins inside `<worker 0>` run on only worker 0.

```
<system>
  workers 4
</system>
# work on multi process workers. worker0 - worker3 run in_forward
<source>
  @type forward
</source>
# work on only worker 0. worker1 - worker3 don't run in_tail
<worker 0>
  <source>
    @type tail
  </source>
</worker>
# <worker 1>, <worker 2> or <worker 3> is also ok
```

With this directive, you can mix multi-process ready and
non-multi-process ready plugins in 1 instance.


### &lt;worker N-M&gt; directive

As of Fluentd v1.4.0, `<worker N-M>` syntax has been introduced:

    :::text
    <system>
      workers 6
    </system>

    <worker 0-1>
      <source>
        @type forward
      </source>

      <filter test>
        @type record_transformer
        enable_ruby
        <record>
          worker_id ${ENV['SERVERENGINE_WORKER_ID']}
        </record>
      </filter>

      <match test>
        @type stdout
      </match>
    </worker>
    # work on worker 0 and worker 1.

    <worker 2-3>
      <source>
        @type tcp
        <parse>
          @type none
        </parse>
        tag test
      </source>

      <filter test>
        @type record_transformer
        enable_ruby
        <record>
          worker_id ${ENV['SERVERENGINE_WORKER_ID']}
        </record>
      </filter>

      <match test>
        @type stdout
      </match>
    </worker>
    # work on worker 2 and worker 3.

    <worker 4-5>
      <source>
        @type udp
        <parse>
          @type none
        </parse>
        tag test
      </source>

      <filter test>
        @type record_transformer
        enable_ruby
        <record>
          worker_id ${ENV['SERVERENGINE_WORKER_ID']}
        </record>
      </filter>

      <match test>
        @type stdout
      </match>
    </worker>
    # work on worker 4 and worker 5.

With this directive, you can specify multiple workers per worker directive.


### root\_dir/@id parameter

These parameters must be specified when you use file buffer.

With multi process workers, you can't use fixed `path` configuration for
file buffer because it conflicts buffer file path between processes.

```
<system>
  workers 2
</system>

<match pattern>
  @type forward
  <buffer>
    @type file
    path /var/log/fluentd/forward # This is not allowed
  </buffer>
</match>
```

Instead of fixed configuration, fluentd provides dynamic buffer path
based on `root_dir` and `@id` parameters. The stored path is
`${root_dir}/worker${worker index}/${plugin @id}/buffer` directory.

```
<system>
  workers 2
  root_dir /var/log/fluentd
</system>

<match pattern>
  @type forward
  @id out_fwd
  <buffer>
    @type file
  </buffer>
</match>
```

With this configuration, `forward` output's buffer files are stored into
`/var/log/fluentd/worker0/out_fwd/buffer` and
`/var/log/fluentd/worker1/out_fwd/buffer` directories.


## Operation

Each worker consumes memory and disk spaces separately. You should take
care to configure buffer spaces, and to monitor memory/disk consumption.


## Multi process workers and Plugins


### Input plugin

There are 3 input plugin types.

-   feature supported and server helper based plugin

Server plugin helper based plugin can share port between workers. For
example, `forward` input plugin doesn't need multiple ports on multi
process workers. `forward` input's port is shared between workers.

```
<system>
  workers 4
</system>

<source>
  @type forward
  port 24224 # 4 workers accept events from this port
</source>
```

-   feature supported and plain plugin

Non server plugin helper based plugin setup socket/server in each
worker. For example, `monitor_agent` needs multiple ports on multi
process workers. Basically, port is assigned in sequential number.

```
<system>
  workers 4
</system>

<source>
  @type monitor_agent
  port 25000 # worker0 port is 25000, ... worker3 port is 25003
</source>
```

-   feature unsupported

Some plugins don't work on multi process workers. For example, `tail`
input doesn't work because in\_tail can't be implemented with multi
process.

You can run these plugins with `<worker N>` directive. See
"Configuration" section.


### Output plugin

No additional changes by default but some plugins need to specify
`worker_id` in the configuration. For example, `file`/`S3` plugins store
events into specified path. The problem is if the plugins under multi
process workers flush events at the same time. the destination path is
same and it causes data lost. To avoid this problem, an user need to set
`worker_id` or random string in the configuration.

```
# s3 plugin example
<match pattern>
  @type s3
  # Good
  path "logs/#{worker_id}/${tag}/%Y/%m/%d/"
  # Bad on multi process worker!
  path logs/${tag}/%Y/%m/%d/
</match>
```

See [Configuration File article](/configuration/config-file.md/#embedded-ruby-code) for
embbeded Ruby code feature.


## FAQ


### Fluentd can't start with multi process workers, why?

You may see following error in fluentd logs.

```
2018-10-01 10:00:00 +0900 [error]: config error file="/path/to/fluentd.conf" error_class=Fluent::ConfigError error="Plugin 'tail' does not support multi workers configuration (Fluent::Plugin::TailInput)"
```

This means configured plugin doesn't support multi process worker. All
configured plugins must support multi process workers. See "Multi
process worker and Plugins" section.


------------------------------------------------------------------------

If this article is incorrect or outdated, or omits critical information, please [let us know](https://github.com/fluent/fluentd-docs/issues?state=open).
[Fluentd](http://www.fluentd.org/) is a open source project under [Cloud Native Computing Foundation (CNCF)](https://cncf.io/). All components are available under the Apache 2 License.
