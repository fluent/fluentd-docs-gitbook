# HTTP Output Plugin

The `out_http` Output plugin writes records via HTTP/HTTPS.

This plugin is introduced since fluentd v1.7.0.

It is included in Fluentd's core.


## Example Configuration

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

Please see the [Configuration File](/configuration/config-file.md) article for
the basic structure and syntax of the configuration file.

For `<buffer>`, refer to [Buffer Section Configuration](/configuration/buffer-section.md).


## Parameters

### `@type`

The value must be `http`.


### `endpoint`

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

See [Buffer Section Configurations](/configuration/buffer-section.md) for more
details.


### `http_method`

| type | default | available values | version |
|:-----|:--------|:-----------------|:--------|
| enum | post    | post/put         | 1.7.0   |

The method for HTTP request.


### `proxy`

| type   | default  | version |
|:-------|:---------|:--------|
| string | optional | 1.7.0   |

The proxy for HTTP request.


### `content_type`

| type   | default | version |
|:-------|:--------|:--------|
| string | nil     | 1.7.0   |

`Content-Type` for HTTP request. `out_http` automatically set `Content-Type` for built-in formatters when this parameter is not specified.

Here is a table:

* `json(json_array: false)`: `application/x-ndjson`
* `json(json_array: true)`: `application/json`
* `csv`: `text/csv`
* `tsv`, `ltsv`: `text/tab-separated-values`
* `msgpack`: `application/x-msgpack`
* `out_file`, `single_value`, `stdout`, `hash`: `text/plain`


### `json_array`

| type   | default | version |
|:-------|:--------|:--------|
| bool   | false   | 1.10.4  |

Using array format of JSON. This parameter is used and valid only for json format.
When `json_array` as true, Content-Type should be `application/json` and be able to use JSON data for the HTTP request body.


### `<format>` Directive

The format of the payload. The default `@type` is `json`.

Here is `single_value` example:

```
<format>
  @type single_value
</format>
```

See [`formatter`](/plugins/formatter/README.md) article for more detail.


### `headers`

| type   | default | version |
|:-------|:--------|:--------|
| hash   | nil     | 1.7.0   |

Additional headers for HTTP request.

```
headers {"key1":"value1", "key2":"value2"}
```


### `open_timeout`

| type   | default | version |
|:-------|:--------|:--------|
| integer| nil     | 1.7.0   |

The connection open timeout in seconds. See also [Ruby document](https://docs.ruby-lang.org/en/master/Net/HTTP.html#attribute-i-open_timeout).


### `read_timeout`

| type   | default | version |
|:-------|:--------|:--------|
| integer| nil     | 1.7.0   |

The read timeout in seconds. See also [Ruby document](https://docs.ruby-lang.org/en/master/Net/HTTP.html#attribute-i-read_timeout).


### `ssl_timeout`

| type   | default | version |
|:-------|:--------|:--------|
| integer| nil     | 1.7.0   |

The TLS timeout in seconds.


### `tls_ca_cert_path`

| type   | default | version |
|:-------|:--------|:--------|
| string | nil     | 1.7.0   |

The CA certificate path for TLS.


### `tls_client_cert_path`

| type   | default | version |
|:-------|:--------|:--------|
| string | nil     | 1.7.0   |

The client certificate path for TLS.


### `tls_private_key_path`

| type   | default | version |
|:-------|:--------|:--------|
| string | nil     | 1.7.0   |

The client private key path for TLS.


### `tls_private_key_passphrase`

| type   | default | version |
|:-------|:--------|:--------|
| string | nil     | 1.7.0   |

The client private key passphrase for TLS.


### `tls_verify_mode`

| type | default | available values | version |
|:-----|:--------|:-----------------|:--------|
| enum | peer    | peer/none        | 1.7.0   |

The verify mode of TLS.


### `tls_version`

| type | default | available values | version |
|:-----|:--------|:-----------------|:--------|
| enum | TLSv1_2 | TLSv1_2/TLSv1_1  | 1.7.0   |

The default version of TLS.


### `tls_ciphers`

| type   | default                  | version |
|:-------|:-------------------------|:--------|
| string | ALL:!aNULL:!eNULL:!SSLv2 | 1.7.0   |

The cipher suites configuration of TLS.


### `error_response_as_unrecoverable`

| type   | default | version |
|:-------|:--------|:--------|
| bool   | true    | 1.7.0   |

Raise `UnrecoverableError` when the response code is not success, 1xx/3xx/4xx/5xx. If `false`, `out_http` logs error message instead of raising `UnrecoverableError`.

See also [Handling Unrecoverable Errors](/buffer/README.md#handling-unrecoverable-errors).


### `retryable_response_codes`

| type         | default | version |
|:-------------|:--------|:--------|
| array of int | [503]   | 1.7.0   |

The list of retryable response code. If the response code is included in this list, `out_http` retries the buffer flush.


### `<auth>` Section

Specifies HTTP authentication:

```
<auth>
  method basic
  username fluentd
  password hello
</auth>
```

#### `method`

| type | default | available values | version |
|:-----|:--------|:-----------------|:--------|
| enum | basic   | basic            | 1.7.0   |

The method for HTTP authentication. Now only `basic`.


#### `username`

| type   | default | version |
|:-------|:--------|:--------|
| string | nil     | 1.7.0   |

The username for basic authentication.


#### `password`

| type   | default | version |
|:-------|:--------|:--------|
| string | nil     | 1.7.0   |

The password for basic authentication.


## Common Output / Buffer parameters

For common output / buffer parameters, please check the following articles:

-   [Output Plugin Overview](/plugins/output/README.md)
-   [Buffer Section Configuration](/configuration/buffer-section.md)


## The Payload Content

`out_http`'s request body depends on `<format>` configuration. For example, the default setting generates newline delimited JSON like this:

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

## Troubleshooting

### 400 Bad request between `out_http` and `in_http`

When getting the following error:

```
#0 got unrecoverable error in primary and no secondary error_class=Fluent::UnrecoverableError error="400 Bad Request 400 Bad Request\n'json' or 'msgpack' parameter is required\n"
#0 bad chunk is moved to /tmp/fluent/backup/worker0/object_3ff8a73edae8/5a71a08ca19b1b343c8dce1b74c9a963.log
```

Users should specify `json` format with `json_array` as true for `out_http` configuration:

```
<match **>
  @type http
  endpoint http://some.your.http.endpoint:9811/your-awesome-path
  <format>
    @type json
  </format>
  json_array true
  <buffer>
    flush_interval 2s
  </buffer>
</match>
```

And receiver `in_http` configuration should be:

```
<source>
  @type http
  port 9811
  bind 0.0.0.0
  <parse>
    @type json
  </parse>
</source>
```

Or specify `msgpack` format:

```
<match **>
  @type http
  endpoint http://some.your.http.endpoint:9882/your-awesome-path
  <format>
    @type msgpack
  </format>
  <buffer>
    flush_interval 2s
  </buffer>
</match>
```

And, receiver `in_http` configuration should be:

```
<source>
  @type http
  port 9882
  bind 0.0.0.0
  <parse>
    @type msgpack
  </parse>
  <format>
    @type json
  </format>
</source>
```

But, we recommend to use in/out [`forward`](forward.md) plugin to communicate
with two Fluentd instances due to `at-most-once` and `at-least-once` semantics
for rigidity.


------------------------------------------------------------------------

If this article is incorrect or outdated, or omits critical information, please
[let us know](https://github.com/fluent/fluentd-docs-gitbook/issues?state=open).
[Fluentd](http://www.fluentd.org/) is an open article- source project under
[Cloud Native Computing Foundation (CNCF)](https://cncf.io/). All components are
available under the Apache 2 License.
