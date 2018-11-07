# Easy Data Stream Manipulation using Fluentd

Sometimes, you need to transform the data stream in a certain way. For
example, you might want to extract a potion of data for error reporting,
or need to append additional information to events for later inspection.

This article explains common data-manipulation techniques in details.


## How to Filter Events by Fields

[filter\_grep](/articles/filter_grep.md) is a built-in plugin that allows to filter
the data stream using regular expressions.

Suppose you are managing a web service, and try to monitor the access
logs using Fluentd. In this case, an event in the data stream will look
like:

``` {.CodeRay}
{
  "host": "192.168.1.1",
  "method": "GET",
  "path": "/index.html",
  "code": 200,
  "size": 2344,
  "referer": null
}
```

Let's filter out all the successful responses with 2xx status codes, so
that we can easily inspect if any error has occurred in the service:

``` {.CodeRay}
<filter apache.**>
  @type grep
  <exclude>
    key code
    pattern ^2\d\d$
  </exclude>
</filter>
```

You can also filter the data using multiple fields. For example, the
following example will keep all 5xx server errors, except those coming
from the test directory:

``` {.CodeRay}
<filter apache.**>
  @type grep
  <regexp>
    key code
    pattern ^5\d\d$
  </regexp>
  <exclude>
    key path
    pattern ^/test/
  </exclude>
</filter>
```


How to Inject Custom Fields into Events
---------------------------------------

[filter\_record\_transformer](/articles/filter_record_transformer.md) is a built-in
plugin that enables to inject arbitrary data into events.

Suppose you are running a web service on multiple web servers, and you
want to record which server handled each request. This can be
implemented trivially using this plugin:

``` {.CodeRay}
<filter apache.**>
  @type record_transformer
  <record>
    server "${hostname}"
  </record>
</filter>
```

This will produce an event like below:

``` {.CodeRay}
{
  "host": "192.168.1.1",
  "method": "GET",
  "path": "/index.html",
  "code": 200,
  "size": 2344,
  "referer": null,
  "server": "app1"
}
```

Note that `${hostname}` is a pre-defined variable supplied by the
plugin. You can also define a custom variable, or even evaluate
arbitrary ruby expressions. For details, please read [the manual page of
this plugin](/articles/filter_record_transformer.md).


------------------------------------------------------------------------

If this article is incorrect or outdated, or omits critical information,
please [let us know](https://github.com/fluent/fluentd-docs/issues?state=open).
[Fluentd](http://www.fluentd.org/) is a open source project under [Cloud
Native Computing Foundation (CNCF)](https://cncf.io/). All components
are available under the Apache 2 License.
