# HTTP Output Plugin

The `out_http` Output plugin writes records into via HTTP/HTTPS.

This plugin is introduced since fluentd v1.7.0.

## Example Configuration

`out_http` is included in Fluentd's core. No additional installation
process is required.

```
<match pattern>
  @type http

  endpoint http://logserver.com:9000/api
  open_timeout 2

  <format>
    @type json
  </format>
  <buffer>
    flush_interval 10s
  </buffer>
</match>
```

Please see the [Config File](/configuration/config-file.md) article for the basic
structure and syntax of the configuration file. For `<buffer>` section,
please check [Buffer section cofiguration](/configuration/buffer-section.md).


## Parameters

### @type

The value must be `http`.

### endpoint

| type   | default  | version |
|:-------|:---------|:--------|
| string | required | 1.7.0   |

The endpoint for HTTP request. If you want to use HTTPS, use `https` prefix.

```
# Use HTTP
endpoint http://example.com/api
# USe HTTPS. You can set additional HTTPS parameters like tls_xxx
endpoint https://example.com/api
```

The `endpoint` parameter supports placeholders, so you can embed time, tag and record fields in the endpoint. Here is an example:

```
endpoint http://example.com/api/${tag}-${key}
<buffer tag,key>
  # buffer parameters
</buffer>
```

See [Buffer section configurations](/configuration/buffer-section.md) for more details.

### http_method

| type | default | available values | version |
|:-----|:--------|:-----------------|:--------|
| enum | post    | post/put         | 1.7.0   |

The method for HTTP request

### proxy

| type   | default  | version |
|:-------|:---------|:--------|
| string | optional | 1.7.0   |

The proxy for HTTP request

### content_type

| type   | default | version |
|:-------|:--------|:--------|
| string | nil     | 1.7.0   |

Content-Type for HTTP request. `out_http` automatically set `Content-Type` for built-in formatters when this parameter is not specified. Here is a table:

* `json`: `application/x-ndjson`
* `csv`: `text/csv`
* `tsv`, `ltsv`: `text/tab-separated-values`
* `msgpack`: `application/x-msgpack`
* `out_file`, `single_value`, `stdout`, `hash`: `text/plain`

### &lt;format&gt; directive

The format of the payload. The default `@type` is `json`. Here is `single_value` example:

```
<format>
  @type single_value
</format>
```

See [formatter article](/plugins/formatter/README.md) for more detail.

### headers

| type   | default | version |
|:-------|:--------|:--------|
| hash   | nil     | 1.7.0   |

Additional headers for HTTP request

```
headers {"key1":"value1", "key2":"value2"}
```

### open_timeout

| type   | default | version |
|:-------|:--------|:--------|
| integer| nil     | 1.7.0   |

The connection open timeout in seconds. See also [Ruby document](https://docs.ruby-lang.org/en/master/Net/HTTP.html#attribute-i-open_timeout)

### read_timeout

| type   | default | version |
|:-------|:--------|:--------|
| integer| nil     | 1.7.0   |

The read timeout in seconds. See also [Ruby document](https://docs.ruby-lang.org/en/master/Net/HTTP.html#attribute-i-read_timeout)

### ssl_timeout

| type   | default | version |
|:-------|:--------|:--------|
| integer| nil     | 1.7.0   |

The TLS timeout in seconds

### tls_ca_cert_path

| type   | default | version |
|:-------|:--------|:--------|
| string | nil     | 1.7.0   |

The CA certificate path for TLS

### tls_client_cert_path

| type   | default | version |
|:-------|:--------|:--------|
| string | nil     | 1.7.0   |

The client certificate path for TLS

### tls_private_key_path

| type   | default | version |
|:-------|:--------|:--------|
| string | nil     | 1.7.0   |

The client private key path for TLS

### tls_private_key_passphrase

| type   | default | version |
|:-------|:--------|:--------|
| string | nil     | 1.7.0   |

The client private key passphrase for TLS

### tls_verify_mode

| type | default | available values | version |
|:-----|:--------|:-----------------|:--------|
| enum | peer    | peer/none        | 1.7.0   |

The verify mode of TLS

### tls_version

| type | default | available values | version |
|:-----|:--------|:-----------------|:--------|
| enum | TLSv1_2 | TLSv1_2/TLSv1_1  | 1.7.0   |

The default version of TLS

### tls_ciphers

| type   | default                  | version |
|:-------|:-------------------------|:--------|
| string | ALL:!aNULL:!eNULL:!SSLv2 | 1.7.0   |

The cipher suites configuration of TLS.

### error_response_as_unrecoverable

| type   | default | version |
|:-------|:--------|:--------|
| bool   | true    | 1.7.0   |

Raise `UnrecoverableError` when the response code is non success, 1xx/3xx/4xx/5xx. If `false`, `out_http` logs error message instead of raising `UnrecoverableError`.

See also [Handling Unrecoverable Errors](/buffer/README.md#handling-unrecoverable-errors)

### retryable_response_codes

| type         | default | version |
|:-------------|:--------|:--------|
| array of int | [503]   | 1.7.0   |

The list of retryable response code. If the response code is included in this list, `out_http` retries the buffer flush.

### &lt;auth&gt; section

Specify HTTP authentication.

```
<auth>
  method basic
  username fluentd
  password hello
</auth>
```

#### method

| type | default | available values | version |
|:-----|:--------|:-----------------|:--------|
| enum | basic   | basic            | 1.7.0   |

The method for HTTP authentication. Now only `basic`.

#### username

| type   | default | version |
|:-------|:--------|:--------|
| string | nil     | 1.7.0   |

The username for basic authentication

#### password

| type   | default | version |
|:-------|:--------|:--------|
| string | nil     | 1.7.0   |

The password for basic authentication

## Common Output / Buffer parameters

For common output / buffer parameters, please check the following
articles.

-   [Output Plugin Overview](/plugins/output/README.md)
-   [Buffer Section Configuration](/configuration/buffer-section.md)


## The payload content

`out_http`'s request body depends on `<format>` configuration. For example, the default setting generates newline delimited json like below:

```
# \n is added by `add_newline true` parameter in <format>
{"key1":"value1","key2":"value2",...}\n
{"key1":"value1","key2":"value2",...}\n
{"key1":"value1","key2":"value2",...}\n
{"key1":"value1","key2":"value2",...}\n
...
```

With `@type single_value`:

```
log line1\n
log line2\n
log line3\n
log line4\n
...
```

------------------------------------------------------------------------

If this article is incorrect or outdated, or omits critical information, please [let us know](https://github.com/fluent/fluentd-docs-gitbook/issues?state=open).
[Fluentd](http://www.fluentd.org/) is a open source project under [Cloud Native Computing Foundation (CNCF)](https://cncf.io/). All components are available under the Apache 2 License.
