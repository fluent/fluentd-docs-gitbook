# http

The `out_http` Output plugin writes records via HTTP/HTTPS.

This plugin is introduced since fluentd v1.7.0.

It is included in Fluentd's core.

## Example Configuration

```text
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

Please see the [Configuration File](../configuration/config-file.md) article for the basic structure and syntax of the configuration file.

For `<buffer>`, refer to [Buffer Section Configuration](../configuration/buffer-section.md).

## Parameters

### `@type`

The value must be `http`.

### `endpoint`

| type | default | version |
| :--- | :--- | :--- |
| string | required | 1.7.0 |

The endpoint for HTTP request. If you want to use HTTPS, use `https` prefix.

```text
# Use HTTP
endpoint http://example.com/api

# Use HTTPS. You can set additional HTTPS parameters like tls_xxx
endpoint https://example.com/api
```

The `endpoint` parameter supports placeholders, so you can embed time, tag and record fields in the endpoint. Placeholders also require the buffer section in order to work. Here is an example:

```text
endpoint http://example.com/api/${tag}-${key}
<buffer tag,key>
  # buffer parameters
</buffer>
```

See [Buffer Section Configurations](../configuration/buffer-section.md) for more details.

### `http_method`

| type | default | available values | version |
| :--- | :--- | :--- | :--- |
| enum | post | post/put | 1.7.0 |

The method for HTTP request.

### `proxy`

| type | default | version |
| :--- | :--- | :--- |
| string | optional | 1.7.0 |

The proxy for HTTP request.

### `content_type`

| type | default | version |
| :--- | :--- | :--- |
| string | nil | 1.7.0 |

`Content-Type` for HTTP request. `out_http` automatically set `Content-Type` for built-in formatters when this parameter is not specified.

Here is a table:

* `json` with `json_array false`: `application/x-ndjson`
* `json` with `json_array true`: `application/json`
* `csv`: `text/csv`
* `tsv`, `ltsv`: `text/tab-separated-values`
* `msgpack`: `application/x-msgpack`
* `out_file`, `single_value`, `stdout`, `hash`: `text/plain`

### `json_array`

| type | default | version |
| :--- | :--- | :--- |
| bool | false | 1.10.4 |

Using the array format of JSON. This parameter is used and valid only for json format. When `json_array` as true, Content-Type should be `application/json` and be able to use JSON data for the HTTP request body.

* `json_array true`

```text
[
  {"key":"value", ...},
  {"key":"value", ...},
  ...
]
```

* `json_array false`

```text
{"key":"value", ...}
{"key":"value", ...}
...
```

### `compress`

| type | default | available values | version |
| :--- | :--- | :--- | :--- |
| enum | text | text/gzip | 1.17.1 |

The option to compress HTTP request body.

### `<format>` Directive

The format of the payload. The default `@type` is `json`.

Here is `single_value` example:

```text
<format>
  @type single_value
</format>
```

See [`formatter`](../formatter/) article for more detail.

### `headers`

| type | default | version |
| :--- | :--- | :--- |
| hash | nil | 1.7.0 |

Additional headers for HTTP request.

```text
headers {"key1":"value1", "key2":"value2"}
```

### headers\_from\_placeholders

| type | default | version |
| :--- | :--- | :--- |
| hash | nil | 1.12.1 |

Additional placeholder based headers for HTTP request. If you want to use tag or record field, use this parameter instead of `headers`.

```text
headers_from_placeholders {"x-foo-bar":"${$.foo.bar}","x-tag":"app-${tag}"}
<buffer tag,$.foo.bar>
  # buffer parameters...
</buffer>
```

### `open_timeout`

| type | default | version |
| :--- | :--- | :--- |
| integer | nil | 1.7.0 |

The connection open timeout in seconds.

See also [Ruby document](https://docs.ruby-lang.org/en/master/Net/HTTP.html#attribute-i-open_timeout).

### `read_timeout`

| type | default | version |
| :--- | :--- | :--- |
| integer | nil | 1.7.0 |

The read timeout in seconds.

See also [Ruby document](https://docs.ruby-lang.org/en/master/Net/HTTP.html#attribute-i-read_timeout).

### `ssl_timeout`

| type | default | version |
| :--- | :--- | :--- |
| integer | nil | 1.7.0 |

The TLS timeout in seconds.

### `reuse_connections`

| type | default | version |
| :--- | :--- | :--- |
| bool | false | 1.17.0 |

Try to reuse connections. This will improve performance.

### `tls_ca_cert_path`

| type | default | version |
| :--- | :--- | :--- |
| string | nil | 1.7.0 |

The CA certificate path for TLS.

### `tls_client_cert_path`

| type | default | version |
| :--- | :--- | :--- |
| string | nil | 1.7.0 |

The client certificate path for TLS.

### `tls_private_key_path`

| type | default | version |
| :--- | :--- | :--- |
| string | nil | 1.7.0 |

The client private key path for TLS.

### `tls_private_key_passphrase`

| type | default | version |
| :--- | :--- | :--- |
| string | nil | 1.7.0 |

The client private key passphrase for TLS.

### `tls_verify_mode`

| type | default | available values | version |
| :--- | :--- | :--- | :--- |
| enum | peer | peer/none | 1.7.0 |

The verify mode of TLS.

### `tls_version`

| type | default | available values | version |
| :--- | :--- | :--- | :--- |
| enum | TLSv1\_2 | TLSv1\_2/TLSv1\_1 | 1.7.0 |

The default version of TLS.

### `tls_ciphers`

| type | default | version |
| :--- | :--- | :--- |
| string | ALL:!aNULL:!eNULL:!SSLv2 | 1.7.0 |

The cipher suites configuration of TLS.

### `error_response_as_unrecoverable`

| type | default | version |
| :--- | :--- | :--- |
| bool | true | 1.7.0 |

Raise `UnrecoverableError` when the response code is not SUCCESS, 1xx/3xx/4xx/5xx. If `false`, `out_http` logs error message instead of raising `UnrecoverableError`.

See also [Handling Unrecoverable Errors](../buffer/#handling-unrecoverable-errors).

### `retryable_response_codes`

| type | default | version |
| :--- | :--- | :--- |
| array of int | \[503\] | 1.7.0 |

The list of retryable response codes. If the response code is included in this list, `out_http` retries the buffer flush.

### `<auth>` Section

Specifies HTTP authentication.

#### `method`

| type | default | available values | version |
| :--- | :--- | :--- | :--- |
| enum | basic | basic/aws\_sigv4 | basic:1.7.0 / aws\_sigv4:1.17.0 |

The method for HTTP authentication.

* `basic`: basic authentication
* `aws_sigv4`: [AWS Signature Version 4](https://docs.aws.amazon.com/AmazonS3/latest/API/sig-v4-authenticating-requests.html)

#### Parameters for `method basic`

```text
<auth>
  method basic
  username fluentd
  password hello
</auth>
```

##### `username`

| type | default | version |
| :--- | :--- | :--- |
| string | nil | 1.7.0 |

The username for basic authentication.

##### `password`

| type | default | version |
| :--- | :--- | :--- |
| string | nil | 1.7.0 |

The password for basic authentication.

#### Parameters for `method aws_sigv4`

Parameters for [AWS Signature Version 4](https://docs.aws.amazon.com/AmazonS3/latest/API/sig-v4-authenticating-requests.html).

```text
<auth>
  method aws_sigv4
  aws_service osis
  aws_region us-east-1
  aws_role_arn arn:aws:iam::123456789012:role/MyRole
</auth>
```

##### `aws_service`

| type | default | version |
| :--- | :--- | :--- |
| string | nil | 1.17.0 |

The AWS service to authenticate against.

This parameter is required when you specify `aws_sigv4` for `method`.

##### `aws_region`

| type | default | version |
| :--- | :--- | :--- |
| string | nil | 1.17.0 |

The AWS region to use when authenticating.

This parameter is required when you specify `aws_sigv4` for `method`.

##### `aws_role_arn`

| type | default | version |
| :--- | :--- | :--- |
| string | nil | 1.17.0 |

The AWS role ARN to assume when authenticating.

This parameter is optional when you specify `aws_sigv4` for `method`. If you provide it, Fluentd will assume that AWS role and send requests signing from that role. Otherwise, Fluentd will use the credentials found by the [credential provider chain](https://docs.aws.amazon.com/sdk-for-ruby/v3/developer-guide/setup-config.html) as defined in the AWS documentation.

## Common Output / Buffer parameters

For common output / buffer parameters, please check the following articles:

* [Output Plugin Overview](./)
* [Buffer Section Configuration](../configuration/buffer-section.md)

## The Payload Content

`out_http`'s request body depends on `<format>` configuration. For example, the default setting generates newline delimited JSON like this:

```text
# \n is added by `add_newline true` parameter in <format>
{"key1":"value1","key2":"value2",...}\n
{"key1":"value1","key2":"value2",...}\n
{"key1":"value1","key2":"value2",...}\n
{"key1":"value1","key2":"value2",...}\n
...
```

With `@type single_value`:

```text
log line1\n
log line2\n
log line3\n
log line4\n
...
```

## Troubleshooting

### 400 Bad request between `out_http` and `in_http`

When getting the following error:

```text
#0 got unrecoverable error in primary and no secondary error_class=Fluent::UnrecoverableError error="400 Bad Request 400 Bad Request\n'json' or 'msgpack' parameter is required\n"
#0 bad chunk is moved to /tmp/fluent/backup/worker0/object_3ff8a73edae8/5a71a08ca19b1b343c8dce1b74c9a963.log
```

Users should specify `json` format with `json_array` as true for `out_http` configuration:

```text
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

```text
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

```text
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

```text
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

But, we recommend to use in/out [`forward`](forward.md) plugin to communicate with two Fluentd instances due to `at-most-once` and `at-least-once` semantics for rigidity.

If this article is incorrect or outdated, or omits critical information, please [let us know](https://github.com/fluent/fluentd-docs-gitbook/issues?state=open). [Fluentd](http://www.fluentd.org/) is an open article- source project under [Cloud Native Computing Foundation \(CNCF\)](https://cncf.io/). All components are available under the Apache 2 License.

