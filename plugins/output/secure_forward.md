# Secure Forward Output Plugin

The `out_secure_forward` output plugin sends messages via **SSL with
authentication** (cf. [in\_secure\_forward](/plugins/input/secure_forward.md)).
This document doesn't describe all parameters. If you want to know full
features, check the Further Reading section.


## Installation

`out_secure_forward` is **not** included in either `td-agent` package or
`fluentd` gem. In order to install it, please refer to the [Plugin Management](/deployment/plugin-management.md) article.

## Example Configurations

This section provides some example configurations for
`out_secure_forward`.

### Minimalist Configuration

At first, generate private CA file on side of input plugin by
`secure-forward-ca-generate`, then copy that file to output plugin side
by safe way (scp, or anyway else).

``` {.CodeRay}
<match secret.data.**>
  @type secure_forward
  shared_key secret_string
  self_hostname client.fqdn.local
  secure true
  ca_cert_path /path/to/certificate/ca_cert.pem

  <server>
    host server.fqdn.local  # or IP
    # port 24284
  </server>
</match>
```

Without hostname ACL (not yet implemented), \`self\_hostname\` is not
checked in any state. The \`\"\#{Socket.gethostname}\"\` placeholder is
available for such cases.

``` {.CodeRay}
<match secret.data.**>
  @type secure_forward
  shared_key secret_string
  self_hostname "#{Socket.gethostname}"
  secure true
  ca_cert_path /path/to/certificate/ca_cert.pem

  <server>
    host server.fqdn.local  # or IP
    # port 24284
  </server>
</match>
```

### Multiple Forward Destinations over SSL

When two or more `<server>...</server>` clauses are specified,
`out_secure_forward` uses these server nodes in a round-robin order. The
servers with `standby yes` are NOT selected until all non-standby
servers go down.

If a server requires username & password, set \`username\` and
\`password\` in the \`\` section:

``` {.CodeRay}
<match secret.data.**>
  @type secure_forward
  shared_key secret_string
  self_hostname client.fqdn.local
  secure true
  ca_cert_path /path/to/certificate/ca_cert.pem

  <server>
    host first.fqdn.local
    username repeatedly
    password sushi
  </server>
  <server>
    host second.fqdn.local
    username sasatatsu
    password karaage
  </server>
  <server>
    host standby.fqdn.local
    username kzk
    password hawaii
    standby  yes
  </server>
</match>
```

Use the `keepalive` parameter to specify keepalive timeouts. For
example, the configuration below disconnects and re-connects its SSL
connection every hour. By default, `keepalive` is set to 0 and the
connection does NOT get disconnected unless there is a connection issue
(This feature is for DNS name updates and refreshing SSL common keys).

``` {.CodeRay}
<match secret.data.**>
  @type secure_forward
  shared_key secret_string
  self_hostname client.fqdn.local
  keepalive 3600
  secure true
  ca_cert_path /path/to/certificate/ca_cert.pem

  <server>
    host server.fqdn.local  # or IP
    # port 24284
  </server>
</match>
```

### Secure Sender-Receiver Setup

Example to send and receive several different kinds of logs (format is
set to none for simplicity here).

#### Sender

``` {.CodeRay}
# td-agent secured client (sender)

<source>
  @type tail
  path /appbase/logs/apache/apache_access_log
  pos_file /var/log/td-agent/tmp/apache.access.pos
  tag apache.access
  format none
</source>

<source>
  @type tail
  path /appbase/logs/apache/apache_error_log
  pos_file /var/log/td-agent/tmp/apache.error.pos
  tag apache.error
  format none
</source>

<source>
  @type tail
  path /appbase/logs/webapp/elastic_search.log
  pos_file /var/log/td-agent/tmp/elastic.search.pos
  tag elastic.search
  format none
</source>

<source>
  @type tail
  path /appbase/logs/webapp/elastic_search_poller.log
  pos_file /var/log/td-agent/tmp/elastic.search.poller.pos
  tag elastic.poller
  format none
</source>

<source>
  @type tail
  path /appbase/logs/webapp/ldap.log
  pos_file /var/log/td-agent/tmp/ldap.log.pos
  tag ldap.log
  format none
</source>



#-- Application Logs

<match apache.*>
  @type copy
  <store>
    @type secure_forward
    shared_key Supers3cr3t
    allow_self_signed_certificate true
    self_hostname frontend01.dev.company.net
    secure true
    ca_cert_path /path/to/certificate/ca_cert.pem

    <server>
      host logserver01.prd.company.net
      port 2514
    </server>
    <server>
      host logserver02.prd.company.net
      port 2514
    </server>
  </store>
</match>

<match elastic.*>
  @type copy
  <store>
    @type secure_forward
    shared_key Supers3cr3t
    allow_self_signed_certificate true
    self_hostname frontend01.dev.company.net
    secure true
    ca_cert_path /path/to/certificate/ca_cert.pem

    <server>
      host logserver01.prd.company.net
      port 2514
    </server>
    <server>
      host logserver02.prd.company.net
      port 2514
    </server>
  </store>
</match>

<match ldap.*>
  @type copy
  <store>
    @type secure_forward
    shared_key Supers3cr3t
    allow_self_signed_certificate true
    self_hostname frontend01.dev.company.net
    secure true
    ca_cert_path /path/to/certificate/ca_cert.pem

    <server>
      host logserver01.prd.company.net
      port 2514
    </server>
    <server>
      host logserver02.prd.company.net
      port 2514
    </server>
  </store>
</match>

#-- NOTE for troubleshooting any actions afer "type copy",
#-- and receive more output in td-agent.log, add:
#--       <store>
#--           @type stdout
#--       </store>


#-- Fluent Internal Logs

<match **>
  @type secure_forward
  shared_key Supers3cr3t
  self_hostname frontend01.dev.company.net
  flush_interval 8s
  secure true
  ca_cert_path /path/to/certificate/ca_cert.pem

  <server>
    host logserver01.prd.company.net
    port 2514
  </server>
  <server>
    host logserver02.prd.company.net
    port 2514
  </server>
</match>
```

#### Receiver

``` {.CodeRay}
# td-agent secured receiver (server)

<source>
  @type secure_forward
  shared_key         Supers3cr3t
  self_hostname      logserver01.prd.company.net
  port 2514
  secure true
  ca_cert_path        /path/to/certificate/ca_cert.pem
  ca_private_key_path /path/to/certificate/ca_key.pem
  ca_private_key_passphrase passphrase_for_private_CA_secret_key
</source>


#-- Application Logs

<match *.access>
  @type file
  append true
  path /appbase/logs/received/access
  time_slice_format %Y%m%d
  time_slice_wait 5m
  time_format %Y%m%dT%H:%M:%S%z
</match>

<match *.error>
  @type file
  append true
  path /appbase/logs/received/error
  time_slice_format %Y%m%d
  time_slice_wait 5m
  time_format %Y%m%dT%H:%M:%S%z
</match>

<match elastic.search>
  @type file
  append true
  path /appbase/logs/received/elastic_search
  time_slice_format %Y%m%d
  time_slice_wait 5m
  time_format %Y%m%dT%H:%M:%S%z
</match>

<match elastic.poller>
  @type file
  append true
  path /appbase/logs/received/elastic_search_poller
  time_slice_format %Y%m%d
  time_slice_wait 5m
  time_format %Y%m%dT%H:%M:%S%z
</match>

<match ldap.*>
  @type file
  append true
  path /appbase/logs/received/ldap
  time_slice_format %Y%m%d
  time_slice_wait 5m
  time_format %Y%m%dT%H:%M:%S%z
</match>


#-- Fluent Internal Logs

<match fluent.info>
  @type file
  append true
  path /appbase/logs/received/fluent-info
</match>

<match fluent.warn>
  @type file
  append true
  path /appbase/logs/received/fluent-warn
</match>
```

## Parameters

### \@type

This parameter is required. Its value must be `secure_forward`.

### port (integer)

The default value is 24284.

### bind (string)

The default value is 0.0.0.0.

### secure (bool)

Indicate published connection is secure or not. Specify `yes` (or
`true`) if secure encryption needed.

### ca\_cert\_path (string)

The file path of private CA certificate file. This file must be shared
with input plugin. The default is blank, but this parameter must be
specified except for the case to use certificates signed by public CA.

### self\_hostname (string)

Default value of the auto-generated certificate common name (CN).

### shared\_key (string)

Shared key between nodes..

### keepalive (time)

The duration for keepalive. If this parameter is not specified,
keepalive is disabled.

### send\_timeout (time)

The send timeout value for sockets. The default value is 60 seconds.

### reconnect\_interval (time)

The interval between SSL reconnects. The default value is 5 seconds.

### read\_length (integer)

The number of bytes read per nonblocking read. The default value is
8MB=8*1024*1024 bytes.

### read\_interval\_msec (integer)

The interval between the non-blocking reads, in milliseconds. The
default value is 50.

### socket\_interval\_msec (integer)

The interval between SSL reconnects in milliseconds. The default value
is 200.

## Buffered Output Parameters

For advanced usage, you can tune Fluentd's internal buffering mechanism
with these parameters.

### buffer\_type

The buffer type is `memory` by default ([buf\_memory](/plugins/buffer/memory.md)) for
the ease of testing, however `file` ([buf\_file](/plugins/buffer/file.md)) buffer type
is always recommended for the production deployments. If you use `file`
buffer type, `buffer_path` parameter is required.

### buffer\_queue\_limit, buffer\_chunk\_limit

The length of the chunk queue and the size of each chunk, respectively.
Please see the [Buffer Plugin Overview](/plugins/buffer/README.md) article
for the basic buffer structure. The default values are 64 and 8m,
respectively. The suffixes "k" (KB), "m" (MB), and "g" (GB) can be used
for buffer\_chunk\_limit.

### flush\_interval

The interval between data flushes. The default is 60s. The suffixes "s"
(seconds), "m" (minutes), and "h" (hours) can be used.

### flush\_at\_shutdown

If set to true, Fluentd waits for the buffer to flush at shutdown. By
default, it is set to true for Memory Buffer and false for File Buffer.

### retry\_wait, max\_retry\_wait

The initial and maximum intervals between write retries. The default
values are 1.0 seconds and unset (no limit). The interval doubles (with
+/-12.5% randomness) every retry until `max_retry_wait` is reached.

Since td-agent will retry 17 times before giving up by default (see the
`retry_limit` parameter for details), the sleep interval can be up to
approximately 131072 seconds (roughly 36 hours) in the default
configurations.

### retry\_limit, disable\_retry\_limit

The limit on the number of retries before buffered data is discarded,
and an option to disable that limit (if true, the value of `retry_limit`
is ignored and there is no limit). The default values are 17 and false
(not disabled). If the limit is reached, buffered data is discarded and
the retry interval is reset to its initial value (`retry_wait`).

### num\_threads

The number of threads to flush the buffer. This option can be used to
parallelize writes into the output(s) designated by the output plugin.
Increasing the number of threads improves the flush throughput to hide
write / network latency. The default is 1.

### slow\_flush\_log\_threshold

The threshold for checking chunk flush performance. The default value is
`20.0` seconds. Note that parameter type is `float`, not `time`.

If chunk flush takes longer time than this threshold, fluentd logs
warning message like below:

``` {.CodeRay}
2016-12-19 12:00:00 +0000 [warn]: buffer flush took longer time than slow_flush_log_threshold: elapsed_time = 15.0031226690043695 slow_flush_log_threshold=10.0 plugin_id="foo"
```

#### log\_level option

The `log_level` option allows the user to set different levels of
logging for each plugin. The supported log levels are: `fatal`, `error`,
`warn`, `info`, `debug`, and `trace`.

Please see the [logging article](/deployment/logging.md) for further details.

## Further Reading

-   [fluent-plugin-secure-forward repository](https://github.com/tagomoris/fluent-plugin-secure-forward)


------------------------------------------------------------------------

If this article is incorrect or outdated, or omits critical information, please [let us know](https://github.com/fluent/fluentd-docs/issues?state=open).
[Fluentd](http://www.fluentd.org/) is a open source project under [Cloud Native Computing Foundation (CNCF)](https://cncf.io/). All components are available under the Apache 2 License.
