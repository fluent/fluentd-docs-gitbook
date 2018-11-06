::: {#main .section}
::: {#page}
::: {.topic_content}
::: {style="text-align:right"}
::: {style="text-align:right"}
Versions \| [v1.0 (td-agent3)](/v1.0/articles/filter_grep) \| ***v0.12*
(td-agent2) **
:::
:::

------------------------------------------------------------------------

grep Filter Plugin
==================

The `filter_grep` filter plugin "greps" events by the values of
specified fields.

[]{#example-configurations}

::: {#table-of-contents .section}
### Table of Contents

[Example Configurations](#example-configurations)

[Parameters](#parameters)

-   [\<regexp\> directive
    (optional)](#%3Cregexp%3E-directive-(optional))
-   [regexpN (optional)](#regexpn-(optional))
-   [\<exclude\> directive
    (optional)](#%3Cexclude%3E-directive-(optional))
-   [excludeN (optional)](#excluden-(optional))

[Learn More](#learn-more)
:::

Example Configurations
----------------------

`filter_grep` is included in Fluentd's core. No installation required.

``` {.CodeRay}
<filter foo.bar>
  @type grep
  <regexp>
    key message
    pattern cool
  </regexp>
  <regexp>
    key hostname
    pattern ^web\d+\.example\.com$
  </regexp>
  <exclude>
    key message
    pattern uncool
  </exclude>
</filter>
```

The above example matches any event that satisfies the following
conditions:

1.  The value of the "message" field contains "cool"
2.  The value of the "hostname" field matches
    `web<INTEGER>.example.com`.
3.  The value of the "message" field does NOT contain "uncool".

Hence, the following events are kept:

``` {.CodeRay}
{"message":"It's cool outside today", "hostname":"web001.example.com"}
{"message":"That's not cool", "hostname":"web1337.example.com"}
```

whereas the following examples are filtered out:

``` {.CodeRay}
{"message":"I am cool but you are uncool", "hostname":"db001.example.com"}
{"hostname":"web001.example.com"}
{"message":"It's cool outside today"}
```

[]{#parameters}

Parameters
----------

[]{#<regexp>-directive-(optional)}

### \<regexp\> directive (optional)

Specify filtering rule. This directive contains two parameters. This
parameter is available since v0.12.38.

-   key

The field name to which the regular expression is applied.

-   pattern

The regular expression.

For example, the following filters out events unless the field "price"
is a positive integer.

``` {.CodeRay}
<regexp>
  key price
  pattern [1-9]\d*
</regexp>
```

The grep filter filters out UNLESS all `<regexp>`s are matched. Hence,
if you have

``` {.CodeRay}
<regexp>
  key price
  pattern [1-9]\d*
</regexp>
<regexp>
  key item_name
  pattern ^book_
</regexp>
```

unless the event's "item\_name" field starts with "book\_" and the
"price" field is an integer, it is filtered out.

For OR condition, you can use `|` operator of regular expressions. For
example, if you have

``` {.CodeRay}
<regexp>
  key item_name
  pattern (^book_|^article)
</regexp>
```

unless the event's "item\_name" field starts with "book*" or "article*",
it is filtered out.

Learn regular expressions for more patterns.

[]{#regexpn-(optional)}

### regexpN (optional)

This is deprecated parameter. Use `<regexp>` instead if you use v0.12.38
or later.

The "N" at the end should be replaced with an integer between 1 and 20
(ex: "regexp1"). regexpN takes two whitespace-delimited arguments.

Here is `regexpN` version of `<regexp>` example:

``` {.CodeRay}
regexp1 price [1-9]\d*
regexp2 item_name ^book_
```

[]{#<exclude>-directive-(optional)}

### \<exclude\> directive (optional)

Specify filtering rule to reject events. This directive contains two
parameters. This parameter is available since v0.12.38.

-   key

The field name to which the regular expression is applied.

-   pattern

The regular expression.

For example, the following filters out events whose "status\_code" field
is 5xx.

``` {.CodeRay}
<exclude>
  key status_code
  pattern ^5\d\d$
</exclude>
```

The grep filter filters out if any `<exclude>` is matched. Hence, if you
have

``` {.CodeRay}
<exclude>
  key status_code
  pattern ^5\d\d$
</exclude>
<exclude>
  key url
  pattern \.css$
</exclude>
```

Then, any event whose "status\_code" is 5xx OR "url" ends with ".css" is
filtered out.

[]{#excluden-(optional)}

### excludeN (optional)

This is deprecated parameter. Use `<exclude>` instead if you use
v0.12.38 or later.

The "N" at the end should be replaced with an integer between 1 and 20
(ex: "exclude1"). excludeN takes two whitespace-delimited arguments.

Here is `excludeN` version of `<exclude>` example:

``` {.CodeRay}
exclude1 status_code ^5\d\d$
exclude2 url \.css$
```
:::
:::
:::

If `<regexp>` and `<exclude>` are used together, both are applied.

[]{#learn-more}

Learn More
----------

-   [Filter Plugin Overview](filter-plugin-overview)
-   [record\_transformer Filter Plugin](filter_record_transformer)

::: {style="text-align:right"}
Last updated: 2016-09-21 02:58:49 UTC
:::

------------------------------------------------------------------------

::: {style="text-align:right"}
Versions \| [v1.0 (td-agent3)](/v1.0/articles/filter_grep) \| ***v0.12*
(td-agent2) **
:::

------------------------------------------------------------------------

If this article is incorrect or outdated, or omits critical information,
please [let us
know](https://github.com/fluent/fluentd-docs/issues?state=open).
[Fluentd](http://www.fluentd.org/) is a open source project under [Cloud
Native Computing Foundation (CNCF)](https://cncf.io/). All components
are available under the Apache 2 License.
