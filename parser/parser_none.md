none Parser Plugin
==================

The `none` parser plugin parses the line as-is with single field. This
format is to defer parsing/structuring the data.


Parameters
----------

### message\_key

Specify field name to contain logs. Default is `message`.

Example
-------

``` {.CodeRay}
Hello world. I am a line of log!
```

This incoming event is parsed as:

``` {.CodeRay}
time:
1362020400 (current time)

record:
{"message":"Hello world. I am a line of log!"}
```


------------------------------------------------------------------------

If this article is incorrect or outdated, or omits critical information,
please [let us know](https://github.com/fluent/fluentd-docs/issues?state=open).
[Fluentd](http://www.fluentd.org/) is a open source project under [Cloud
Native Computing Foundation (CNCF)](https://cncf.io/). All components
are available under the Apache 2 License.
