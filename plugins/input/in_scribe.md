# scribe Input Plugin

The `in_scribe` Input plugin enables Fluentd to retrieve records through
the Scribe protocol. [Scribe](https://github.com/facebook/scribe) is
another log collector daemon that is open-sourced by Facebook.

Since Scribe hasn't been well maintained recently, this plugin is useful
for existing Scribe users who want to use Fluentd with an existing
Scribe infrastructure.


## Install

`in_scribe` is included in td-agent by default. Fluentd gem users will
need to install the fluent-plugin-scribe gem using the following
command.

``` {.CodeRay}
$ fluent-gem install fluent-plugin-scribe
```

## Example Configuration

``` {.CodeRay}
<source>
  @type scribe
  port 1463

  bind 0.0.0.0
  msg_format json
</source>
```
Please see the [Config File](/configuration/config-file.md) article for the basic
structure and syntax of the configuration file.

### Example Usage

We assume that you're already familiar with the Scribe protocol. This
[Ruby example code](https://github.com/fluent/fluent-plugin-scribe/blob/master/bin/fluent-scribe-remote)
posts logs to `in_scribe`.

Scribe's `category` field becomes the `tag` of the Fluentd event log and
Scribe's `message` field becomes the record itself. The `msg_format`
parameter specifies the format of the `message` field.

## Parameters

#### type (required)

The value must be `scribe`.

#### port

The port to listen to. Default Value = 1463

#### bind

The bind address to listen to. Default Value = 0.0.0.0 (all addresses)

#### msg\_format

The message format can be 'text', 'json', or 'url\_param' (default:
text)

For `json`, Fluentd's record is organized as follows. Scribe's message
field must be a valid JSON string representing Hash; otherwise, the
record is ignored.

``` {.CodeRay}
tag: $category
record: $message
```

For `text`, Fluentd's record is organized as follows. Scribe's message
can be any arbitrary string, but JSON is recommended for ease of use
with the subsequent analytics pipeline.

``` {.CodeRay}
tag: $category
record: {'message': $message}
```

For `url_param`, Fluentd's record is organized as follows. Scribe's
message field must contain URL parameter style key-value pairs with URL
encoding (e.g. key1=val1&key2=val2).

``` {.CodeRay}
tag: $url_param
record: {$key1: $val1, $key2: $val2, ...}
```

#### is\_framed

Specifies whether to use Thrift's framed protocol or not (default:
true).

#### server\_type

Chooses the server architecture. Options are 'simple', 'threaded',
'thread\_pool', or 'nonblocking' (default: nonblocking).

#### add\_prefix

The prefix string which will always be added to the tag (default: nil).

#### log\_level option

The `log_level` option allows the user to set different levels of
logging for each plugin. The supported log levels are: `fatal`, `error`,
`warn`, `info`, `debug`, and `trace`.

Please see the [logging article](/deployment/logging.md) for further details.


------------------------------------------------------------------------


If this article is incorrect or outdated, or omits critical information,
please [let us know](https://github.com/fluent/fluentd-docs/issues?state=open).
[Fluentd](http://www.fluentd.org/) is a open source project under [Cloud Native Computing Foundation (CNCF)](https://cncf.io/). All components
are available under the Apache 2 License.
