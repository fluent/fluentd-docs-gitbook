# HTTP Input Plugin

![](/images/plugins/input/http.png)

The `in_http` Input plugin allows you to send events through HTTP
requests. Using this plugin, you can trivially launch a REST endpoint to
gather data.


## Configuration

The following snippet shows an example configuration.

```
<source>
  @type http
  port 9880
  bind 0.0.0.0
  body_size_limit 32m
  keepalive_timeout 10s
</source>
```

For the full list of the configurable options, see [the "Parameters" section](#parameters).


## Basic Usage

Here is a simple example to post a record using `curl`.

```
# Post a record with the tag "app.log"
$ curl -X POST -d 'json={"foo":"bar"}' http://localhost:9880/app.log
```

By default, timestamps are assigned to each record on arrival. You can
override the timestamp using the `time` parameter.

```
# Overwrite the timestamp to 2018-02-16 04:40:37.3137116
$ curl -X POST -d 'json={"foo":"bar"}' \
  http://localhost:9880/test.tag?time=1518756037.3137116
```

Here is another example in JavaScript.

```
// Post a record using XMLHttpRequest
var form = new FormData();
form.set('json', JSON.stringify({"foo": "bar"}));

var req = new XMLHttpRequest();
req.open('POST', 'http://localhost:9880/debug.log');
req.send(form);
```

For more advanced usage, please read [the "Tips & Tricks"
section](#tips-&-tricks).


## Parameters

[Common Parameters](/configuration/plugin-common-parameters.md)


### @type (required)

The value must be `http`.


### port

| type    | default | version |
|:--------|:--------|:--------|
| integer | 9880    | 0.14.0  |

The port to listen to.


### bind

| type   | default                 | version |
|:-------|:------------------------|:--------|
| string | 0.0.0.0 (all addresses) | 0.14.0  |

The bind address to listen to.


### body\_size\_limit

| type | default | version |
|:-----|:--------|:--------|
| size | 32MB    | 0.14.0  |

The size limit of the POSTed element.


### keepalive\_timeout

| type | default      | version |
|:-----|:-------------|:--------|
| size | 10 (seconds) | 0.14.0  |

The timeout limit for keeping the connection alive.


### add\_http\_headers

| type | default | version |
|:-----|:--------|:--------|
| bool | false   | 0.14.0  |

Add `HTTP_` prefix headers to the record.


### add\_remote\_addr

| type | default | version |
|:-----|:--------|:--------|
| bool | false   | 0.14.0  |

Add `REMOTE_ADDR` field to the record. The value of `REMOTE_ADDR` is the
client's address.

If your system set multiple `X-Forwarded-For` headers in the request,
`in_http` uses first one. For example:

```
X-Forwarded-For: host1, host2
X-Forwarded-For: host3
```

If send above multiple headers, `REMOTE_ADDR` value is `host1`.


### cors\_allow\_origins

| type  | default       | version |
|:------|:--------------|:--------|
| array | nil(disabled) | 0.14.0  |

White list domains for CORS.

If you set `["domain1", "domain2"]` to `cors_allow_origins`, `in_http`
returns `403` to access from other domains. Since Fluentd v1.2.6, you
can use a wildcard character `*` to allow requests from any origins (see
the following example).

```
<source>
  @type http
  port 9880
  cors_allow_origins ["*"]
</source>
```


### respond\_with\_empty\_img

| type | default | version |
|:-----|:--------|:--------|
| bool | false   | 0.12.0  |

Respond with an empty gif image of 1x1 pixel (rather than an emtpy
string).

### &lt;transport&gt; section

| type | default | available values | version |
|:-----|:--------|:-----------------|:--------|
| enum | tcp     | tls      | 1.5.0  |

This section is for using SSL transport.

```
<transport tls>
  cert_path /path/to/fluentd.crt
  # other parameters
</transport>
```

See "How to Enable TLS Encryption" section for how to use and see
["Configuration example" in "Server Plugin Helper" article](/developer/api-plugin-helper-server.md#configuration-example) for
supported parameters

Without `<transport tls>`, in\_http uses HTTP.


### format (deprecated)

Deprecated parameter. Use the `<parse>` directive [as explained below](#handle-various-formats-using-parser-plugins) instead.


## Tips & Tricks


### How to send data in MessagePack format

You can post data in MessagePack format by adding the `msgpack=` prefix.

```
# Send data in msgpack format
$ msgpack=`echo -e "\x81\xa3foo\xa3bar"`
$ curl -X POST -d "msgpack=$msgpack" http://localhost:9880/app.log
```


### How to use HTTP Content-Type header

`in_http` plugin recognizes HTTP 'Content-Type' header in the incoming
requests. For example, you can send a JSON payload without the `json=`
prefix.

```
$ curl -X POST -d '{"foo":"bar"}' -H 'Content-Type: application/json' \
  http://localhost:9880/app.log
```

To use MessagePack, set the content type to `application/msgpack`.

```
$ msgpack=`echo -e "\x81\xa3foo\xa3bar"`
$ curl -X POST -d "$msgpack" -H 'Content-Type: application/msgpack' \
  http://localhost:9880/app.log
```


### Handle other formats using parser plugins

You can handle various input formats by using the `<parser>` directive.
For example, add the following settings to the configuration file:

```
<source>
  @type http
  port 9880
  <parse>
    @type regexp
    expression /^(?<field1>\d+):(?<field2>\w+)$/
  </parse>
</source>
```

Now you can post custom-format records as below:

```
# This will be parsed into {"field1":"123456","field2":"awesome"}
$ curl -X POST -d '123456:awesome' http://localhost:9880/app.log
```

Many other formats (e.g. csv/syslog/nginx) are also supported as well.
You can find the full list of supported formats in ["Parser Plugin Overview"](/plugins/parsers/README.md).

Note that parser plugins do not support [the batch mode](#handle-large-data-with-batch-mode). So if you want to use bulk
insertion for handling a large data set, please consider to keep using
the default JSON (or MessagePack) format.


## Enhance Performance


### Handle large data with batch mode

You can post multiple records with a single request by packing data into
a JSON/MessagePack array.

```
# Send multiple events as a JSON array
$ curl -X POST -d "json=[{"foo":"bar"},{"abc":"def"},{"xyz":"123"}]" \
  http://localhost:9880/app.log
```

This significantly improves the throughput since it reduces the number
of HTTP requests. Here is a simple bechmark result on MacBook Pro with
ruby 2.3:

| json            | msgpack         | msgpack array(10 items) |
|:----------------|:----------------|:------------------------|
| 2100 events/sec | 2400 events/sec | 10000 events/sec        |

Tested configuration and ruby script is
[here](https://gist.github.com/repeatedly/672ac73abf7cbcb629aaec791838cf6d).


### Use compression to reduce bandwidth overhead

Since v1.2.3, Fluentd can handle gzip-compressed payloads. To enable
this feature, you need to add the 'Content-Encoding' header to your
requests.

```
# Send gzip-compressed payload
$ echo 'json={"foo":"bar"}' | gzip > json.gz
$ curl --data-binary @json.gz -H "Content-Encoding: gzip" \
  http://localhost:9880/app.log
```

You do not need any configuration to enable this feature.


### Multi-process environment

If you use this plugin under multi-process environment, port will be
shared.

```
<system>
  workers 3
</system>
<source>
  @type http
  port 9880
</source>
```

With this configuration, 3 workers share 9880 port. No need additional
port. Incoming data will be routed to 3 workers automatically.


## Troubleshooting


### Why in\_http removes '+' from my log?

This is HTTP spec, not fluentd problem. You need to encode your payload
properly or use multipart request. Here is ruby example:

```
# OK
URI.encode_www_form({json: {"message" => "foo+bar"}.to_json})

# NG
"json=#{"message" => "foo+bar"}.to_json}"
```

curl command example:

```
# OK
curl -X POST -H 'Content-Type: multipart/form-data' -F 'json={"message":"foo+bar"}' http://localhost:9880/app.log

# NG
curl -X POST -F 'json={"message":"foo+bar"}' http://localhost:9880/app.log
```


## Learn More

-   [Input Plugin Overview](/plugins/input/README.md)

## Tips


### How to Enable TLS Encryption

Since v1.5.0, `in_http` support TLS tranport. Here is configuration example with HTTPS client.

- in_tcp

```
<source>
  @type http
  bind 0.0.0.0
  <transport tls>
    insecure true
  </transport>
</source>
```

- https client

```
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

------------------------------------------------------------------------

If this article is incorrect or outdated, or omits critical information, please [let us know](https://github.com/fluent/fluentd-docs-gitbook/issues?state=open).
[Fluentd](http://www.fluentd.org/) is a open source project under [Cloud Native Computing Foundation (CNCF)](https://cncf.io/). All components are available under the Apache 2 License.
