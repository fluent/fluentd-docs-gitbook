# http

![](../.gitbook/assets/http.png)

The `in_http` Input plugin allows you to send events through HTTP requests. Using this plugin, you can trivially launch a REST endpoint to gather data.

## Configuration

Here is a sample configuration:

```text
<source>
  @type http
  port 9880
  bind 0.0.0.0
  body_size_limit 32m
  keepalive_timeout 10s
</source>
```

For the full list of the configurable options, see the [Parameters](http.md#parameters) section.

## Basic Usage

By default, the data format depends on the `Content-Type`.
In summary, you can send the following format.

* `json`
* `ndjson`
* `msgpack`

Here is a simple example to post a record using `curl`, which uses the default Content-Type `application/x-www-form-urlencoded`.

Example: post JSON data with the tag "app.log":

```bash
curl -X POST -d 'json={"foo":"bar"}' http://localhost:9880/app.log
```

Example: post NDJSON data with the tag "app.log":

```bash
ndjson=`echo -e 'ndjson={"k1":"v1"}\n{"k2":"v2"}\n'`
curl -X POST -d "$ndjson" http://localhost:9880/app.log
```

Example: post MessagePack data with the tag "app.log":

```bash
msgpack=`echo -e "msgpack=\x81\xa3foo\xa3bar"`
curl -X POST -d "$msgpack" http://localhost:9880/app.log
```

Some Media Types other than `application/x-www-form-urlencoded` support specific formats.
If those Media Types are specified with `Content-Type: `, the prefix such as `json=` is not necessary for posting data.

Example: Post JSON data with `Content-Type: application/json`:

```bash
curl -X POST -d '{"foo":"bar"}' -H 'Content-Type: application/json' \
  http://localhost:9880/app.log
```

**For more details regarding the message body syntax and `Content-Type` see [How to use HTTP Content-Type Header](http.md#how-to-use-http-content-type-header)**

By default, timestamps are assigned to each record on arrival. You can override the timestamp using the `time` parameter:

```text
# Overwrite the timestamp to 2018-02-16 04:40:37.3137116
$ curl -X POST -d 'json={"foo":"bar"}' \
  http://localhost:9880/test.tag?time=1518756037.3137116
```

Here is another example in JavaScript:

```text
// Post a record using XMLHttpRequest
var form = new FormData();
form.set('json', JSON.stringify({"foo": "bar"}));

var req = new XMLHttpRequest();
req.open('POST', 'http://localhost:9880/debug.log');
req.send(form);
```


For more advanced usage, please read the [Tips and Tricks](http.md#tips-and-tricks) section.

## Parameters

See [Common Parameters](../configuration/plugin-common-parameters.md).

### `@type` \(required\)

The value must be `http`.

### `port`

| type | default | version |
| :--- | :--- | :--- |
| integer | 9880 | 0.14.0 |

The port to listen to.

### `bind`

| type | default | version |
| :--- | :--- | :--- |
| string | 0.0.0.0 \(all addresses\) | 0.14.0 |

The bind address to listen to.

### `body_size_limit`

| type | default | version |
| :--- | :--- | :--- |
| size | 32MB | 0.14.0 |

The size limit of the POSTed element.

### `keepalive_timeout`

| type | default | version |
| :--- | :--- | :--- |
| size | 10 \(seconds\) | 0.14.0 |

The timeout limit for keeping the connection alive.

### `add_http_headers`

| type | default | version |
| :--- | :--- | :--- |
| bool | false | 0.14.0 |

Adds `HTTP_` prefix headers to the record.

### `add_remote_addr`

| type | default | version |
| :--- | :--- | :--- |
| bool | false | 0.14.0 |

Adds `REMOTE_ADDR` field to the record. The value of `REMOTE_ADDR` is the client's address.

If your system set multiple `X-Forwarded-For` headers in the request, `in_http` uses the first one. For example:

```text
X-Forwarded-For: host1, host2
X-Forwarded-For: host3
```

If the above multiple headers are sent, the value of `REMOTE_ADDR` will be `host1`.

### `cors_allow_origins`

| type | default | version |
| :--- | :--- | :--- |
| array | nil\(disabled\) | 0.14.0 |

Whitelist domains for CORS.

If you set `["domain1", "domain2"]` to `cors_allow_origins`, `in_http` returns `403` to access from other domains. Since Fluentd v1.2.6, you can use a wildcard character `*` to allow requests from any origins.

Example:

```text
<source>
  @type http
  port 9880
  cors_allow_origins ["*"]
</source>
```

### `cors_allow_credentials`

| type | default | version |
| :--- | :--- | :--- |
| bool | false | 1.14.0 |

Add [`Access-Control-Allow-Credentials`](https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Access-Control-Allow-Credentials) header. It's needed when a request's credentials mode is `include`. An example of use case is using [Beacon API](https://developer.mozilla.org/en-US/docs/Web/API/Beacon_API), its request mode is always `include`.

### `respond_with_empty_img`

| type | default | version |
| :--- | :--- | :--- |
| bool | false | 0.12.0 |

Responds with an empty GIF image of 1x1 pixel \(rather than an empty string\).

### `use_204_response`

| type | default | version |
| :--- | :--- | :--- |
| bool | false | v1.8.0 |

Respond status code with 204. This option will be deprecated at v2 because fluentd v2 will respond 204 as default.

### `<transport>` Section

| type | default | available values | version |
| :--- | :--- | :--- | :--- |
| enum | tcp | tcp, tls | 1.5.0 |

This section is for setting TLS transport or some general transport configurations.

#### General configuration

##### `linger_timeout`

| type | default | available transport type | version |
| :--- | :--- | :--- | :--- |
| integer | 0 | tcp, tls | 1.14.6 |

The timeout \(seconds\) to set `SO_LINGER`.

The default value `0` is to send RST rather than FIN to avoid lots of connections sitting in TIME_WAIT on closing on non-Windows.

You can set positive value to send FIN on closing on non-Windows.

(On Windows, Fluentd sends FIN when `linger_timeout` is `0` too).

```text
<transport tcp>
  linger_timeout 1
</transport>
```

#### TLS configuration

```text
<transport tls>
  cert_path /path/to/fluentd.crt
  # other parameters
</transport>
```

See **How to Enable TLS Encryption** section for how to use and see [Configuration Example](../plugin-helper-overview/api-plugin-helper-server.md#configuration-example) for all supported parameters.

Without `<transport tls>`, `in_http` uses HTTP.

### `<parse>` directive

Use the parser plugin to parse the incoming data. See also [Handle other formats using parser plugins](http.md#handle-other-formats-using-parser-plugins) section.

### `format` \(deprecated\)

Deprecated parameter. Use `<parse>` directive instead.

## Tips and Tricks

### How to send data in MessagePack format?

You can post data in MessagePack format by adding the `msgpack=` prefix:

```text
# Send data in msgpack format
$ msgpack=`echo -e "\x81\xa3foo\xa3bar"`
$ curl -X POST -d "msgpack=$msgpack" http://localhost:9880/app.log
```

### How to use HTTP Content-Type header?

`in_http` plugin recognizes HTTP `Content-Type` header in the incoming requests.

If you use the default `<parse>` setting, the data format depends on the `Content-Type`.
(If you set the `<parse>` directive to use a specific Parser, the `Content-Type` is not used).

By default `curl` uses `-H "Content-Type: application/x-www-form-urlencoded"`, which allows the use of the prefix `json=`, `ndjson=`, and `msgpack=` as seen on the previous examples.

On the other hand, some Media Types other than `application/x-www-form-urlencoded` support specific formats.
If those Media Types are specified with `Content-Type: `, the prefix such as `json=` is not necessary for posting data.

Here is the list of supported Media Types:

| Media Types              | data format | version |
| :---                     | :---        | :---    |
| `application/json`       | JSON        | -       |
| `application/csp-report` | JSON        | 1.17.0  |
| `application/msgpack`    | MessagePack | -       |
| `application/x-ndjson`   | NDJSON      | 1.14.5  |

Examples:

```bash
curl -X POST -d '{"foo":"bar"}' -H 'Content-Type: application/json' \
  http://localhost:9880/app.log
```

```bash
msgpack=`echo -e "\x81\xa3foo\xa3bar"`
curl -X POST -d "$msgpack" -H 'Content-Type: application/msgpack' \
  http://localhost:9880/app.log
```

Also, you can use `multipart/form-data`.
For more details about `multipart/form-data`, please see [Why `in_http` removes '+' from my log](http.md#why-in_http-removes--from-my-log).

### Handle Other Formats using Parser Plugins

You can handle various input formats by using the `<parse>` directive. For example, add the following settings to the configuration file:

```text
<source>
  @type http
  port 9880
  <parse>
    @type regexp
    expression /^(?<field1>\d+):(?<field2>\w+)$/
  </parse>
</source>
```

Now you can post custom-format records like this:

```text
# This will be parsed into {"field1":"123456","field2":"awesome"}
$ curl -X POST -d '123456:awesome' http://localhost:9880/app.log
```

Many other formats \(e.g. `csv`/`syslog`/`nginx`\) are also supported. For the full list of supported formats, see [Parser Plugin Overview](../parser/).

NOTE: Some parser plugins do not support the [batch mode](http.md#handle-large-data-with-batch-mode). So, if you want to use bulk insertion for handling a large data set, please consider keeping the default JSON \(or MessagePack\) format or write batch mode supported parser \(return array object\).

## Enhance Performance

### Handle Large Data with Batch Mode

You can post multiple records with a single request by packing data into a JSON/MessagePack array:

```text
# Send multiple events as a JSON array
$ curl -X POST -d 'json=[{"foo":"bar"},{"abc":"def"},{"xyz":"123"}]' \
  http://localhost:9880/app.log
```

This significantly improves the throughput since it reduces the number of HTTP requests. Here is a simple benchmark on MacBook Pro with Ruby 2.3:

| json | msgpack | msgpack array\(10 items\) |
| :--- | :--- | :--- |
| 2100 events/sec | 2400 events/sec | 10000 events/sec |

Tested configuration and Ruby script are [here](https://gist.github.com/repeatedly/672ac73abf7cbcb629aaec791838cf6d).

### Use Compression to Reduce Bandwidth Overhead

Since v1.2.3, Fluentd can handle gzip-compressed payloads. To enable this feature, you need to add the `Content-Encoding` header to your requests.

```text
# Send gzip-compressed payload
$ echo 'json={"foo":"bar"}' | gzip > json.gz
$ curl --data-binary @json.gz -H "Content-Encoding: gzip" \
  http://localhost:9880/app.log
```

You do not need any configuration to enable this feature.

### Multi-process Environment

If you use this plugin under the multi-process environment, the port will be shared.

```text
<system>
  workers 3
</system>
<source>
  @type http
  port 9880
</source>
```

With this configuration, three \(3\) workers share 9880 port. No need for an additional port. Incoming data will be routed to three \(3\) workers automatically.

## Troubleshooting

### Why `in_http` splits the messages from my log when using `json=` syntax ?

This happens when using the content type `application/x-www-form-urlencoded`. 
It is a limitation of the HTTP spec, you either need to encode the message or you can use the content type `application/json`.

For example:

```text

# bad
curl -X POST --location "http://localhost:9880/app.loge" \
        -d "json=[{\"log\":\"message ; remaining message\"}]"
# good
curl -X POST --location "http://localhost:9880/app.log" \
        -H "Content-Type: application/json" \
        -d "{\"log\":\"message ; remaining message\"}"
```


### Why `in_http` removes '+' from my log?

This is HTTP spec, not fluentd problem. You need to encode your payload properly or use multipart request. Here is a Ruby example:

```text
# Good
URI.encode_www_form({json: {"message" => "foo+bar"}.to_json})

# Bad
"json=#{"message" => "foo+bar"}.to_json}"
```

`curl` command example:

```text
# Good
curl -X POST -H 'Content-Type: multipart/form-data' -F 'json={"message":"foo+bar"}' http://localhost:9880/app.log

# Bad
curl -X POST -F 'json={"message":"foo+bar"}' http://localhost:9880/app.log
```

## Learn More

* [Input Plugin Overview](./)

## Tips

### How to Enable TLS Encryption?

Since v1.5.0, `in_http` support TLS transport. Here is a configuration example with HTTPS client:

```text
<source>
  @type http
  bind 0.0.0.0
  <transport tls>
    ca_path /etc/pki/ca.pem
    cert_path /etc/pki/cert.pem
    private_key_path /etc/pki/key.pem
    private_key_passphrase PASSPHRASE
  </transport>
</source>
```

* https client

```text
require 'net/http'
require 'net/https'
require 'msgpack'

record = { 'msgpack' => { 'k' => 'hello', 'k1' => 1234}.to_msgpack }

def post(path, params)
  http = Net::HTTP.new('127.0.0.1', 9880)
  http.use_ssl = true
  http.verify_mode = OpenSSL::SSL::VERIFY_NONE
  req = Net::HTTP::Post.new(path, {})
  req.set_form_data(params)
  http.request(req)
end

puts post("/test.http?time=#{Time.now.to_i}", record).body
```

### How to Enable TLS Mutual Authentication?

Fluentd supports [TLS mutual authentication](https://en.wikipedia.org/wiki/Mutual_authentication) \(i.e. client certificate auth\). If you want to use this feature, please set the `client_cert_auth` and `ca_path` options like this:

```text
<source>
  @type http
  <transport tls>
    ...
    client_cert_auth true
    ca_path /path/to/ca/cert
  </transport>
</source>
```

When this feature is enabled, Fluentd will check all the incoming requests for a client certificate signed by the trusted CA. Requests with an invalid client certificate will fail.

If this article is incorrect or outdated, or omits critical information, please [let us know](https://github.com/fluent/fluentd-docs-gitbook/issues?state=open). [Fluentd](http://www.fluentd.org/) is an open-source project under [Cloud Native Computing Foundation \(CNCF\)](https://cncf.io/). All components are available under the Apache 2 License.

