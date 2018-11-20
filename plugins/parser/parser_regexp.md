# regexp Parser Plugin

The `regexp` parser plugin parses logs by given regexp pattern. If the
parameter value starts and ends with "/", it is considered to be a
regexp. The regexp must have at least one named capture
(?\<NAME\>PATTERN). If the regexp has a capture named `time`, this is
configurable, it is used as the time of the event. You can specify the
time format using the time\_format parameter.

``` {.CodeRay}
format /.../ # regexp parser is used
format json  # json parser is used
```


## Parameters

### time\_key

Specify the field for event time. Default is `time`.

### time\_format

Specify time format for `time_key`.

See
[Time\#strptime](http://ruby-doc.org/stdlib-2.4.1/libdoc/time/rdoc/Time.html#method-c-strptime)
for additional format information.

### keep\_time\_key

If you want to keep time field in the record, set `true`. Default is
`false`.

### types

Although every parsed field has type `string` by default, you can
specify other types. This is useful when filtering particular fields
numerically or storing data with sensible type information.

The syntax is

``` {.CodeRay}
types <field_name_1>:<type_name_1>,<field_name_2>:<type_name_2>,...
```

e.g.,

``` {.CodeRay}
types user_id:integer,paid:bool,paid_usd_amount:float
```

As demonstrated above, "," is used to delimit field-type pairs while ":"
is used to separate a field name with its intended type.

Unspecified fields are parsed at the default string type.

The list of supported types are shown below:

-   string
-   bool
-   integer ("int" would NOT work!)
-   float
-   time
-   array

For the `time` and `array` types, there is an optional third field after
the type name. For the "time" type, you can specify a time format like
you would in `time_format`.

For the "array" type, the third field specifies the delimiter (the
default is ","). For example, if a field called "item\_ids" contains the
value "3,4,5", `types item_ids:array` parses it as \["3", "4", "5"\].
Alternatively, if the value is "Adam\|Alice\|Bob",
`types item_ids:array:|` parses it as \["Adam", "Alice", "Bob"\].

## Example

``` {.CodeRay}
format /^\[(?<logtime>[^\]]*)\] (?<name>[^ ]*) (?<title>[^ ]*) (?<id>\d*)$/
time_key logtime
time_format %Y-%m-%d %H:%M:%S %z
types id:integer
```

With this config:

``` {.CodeRay}
[2013-02-28 12:00:00 +0900] alice engineer 1
```

This incoming log is parsed as:

``` {.CodeRay}
time:
1362020400 (22013-02-28 12:00:00 +0900)

record:
{
  "name" : "alice",
  "title": "engineer",
  "id"   : 1
}
```

## FAQ

### How to debug my regexp pattern?

[fluentd-ui's in\_tail editor](/deployment/fluentd-ui.md/#intail-setting)
helps your regexp testing. Another way,
[Fluentular](http://fluentular.herokuapp.com/) is a great website to
test your regexp for Fluentd configuration.

NOTE: You may hit Application Error at Fluentular due to [heroku free
plan limitation](https://www.heroku.com/pricing). Retry a few hours
later or use fluentd-ui instead.


------------------------------------------------------------------------

If this article is incorrect or outdated, or omits critical information,
please [let us know](https://github.com/fluent/fluentd-docs/issues?state=open).
[Fluentd](http://www.fluentd.org/) is a open source project under [Cloud
Native Computing Foundation (CNCF)](https://cncf.io/). All components
are available under the Apache 2 License.
