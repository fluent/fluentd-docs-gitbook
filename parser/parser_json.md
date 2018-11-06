json Parser Plugin
==================

The `json` parser plugin parses JSON logs. One JSON map per line.


Parameters
----------

### time\_key

Specify time field for event time. Default is `time`.

If there is no time field in the record, this parser uses current time
as an event time.

### time\_format

If time field value is formatted string, e.g. "28/Feb/2013:12:00:00
+0900", you need to specify this parameter to parse it.

Default is `nil` and it means time field value is a second integer like
`1497915137`.

See
[Time\#strptime](http://ruby-doc.org/stdlib-2.4.1/libdoc/time/rdoc/Time.html#method-c-strptime)
for additional format information.

### keep\_time\_key

If you want to keep time field in the record, set `true`. Default is
`false`.

Example
-------

``` {.CodeRay}
{"time":1362020400,"host":"192.168.0.1","size":777,"method":"PUT"}
```

This incoming event is parsed as:

``` {.CodeRay}
time:
1362020400 (2013-02-28 12:00:00 +0900)

record:
{
  "host"  : "192.168.0.1",
  "size"  : 777,
  "method": "PUT",
}
```


------------------------------------------------------------------------

If this article is incorrect or outdated, or omits critical information,
please [let us
know](https://github.com/fluent/fluentd-docs/issues?state=open).
[Fluentd](http://www.fluentd.org/) is a open source project under [Cloud
Native Computing Foundation (CNCF)](https://cncf.io/). All components
are available under the Apache 2 License.
