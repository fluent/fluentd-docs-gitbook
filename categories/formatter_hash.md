::: {#main .section}
::: {#page}
::: {.topic_content}
::: {style="text-align:right"}
::: {style="text-align:right"}
Versions \| [v1.0 (td-agent3)](/v1.0/articles/formatter_hash) \|
***v0.12* (td-agent2) **
:::
:::

------------------------------------------------------------------------

hash Formatter Plugin
=====================

The `hash` formatter plugin converts an event to ruby hash.

By default, `hash` formatter result doesn't contain `tag` and `time`
field.


### Table of Contents

[Parameters](#parameters)

-   [add\_newline (Boolean, Optional, defaults to
    true)](#add_newline-(boolean,-optional,-defaults-to-true))
-   [include\_time\_key (Boolean, Optional, defaults to
    false)](#include_time_key-(boolean,-optional,-defaults-to-false))
-   [time\_key (String, Optional, defaults to
    "time")](#time_key-(string,-optional,-defaults-to-%E2%80%9Ctime%E2%80%9D))
-   [time\_format (String. Optional)](#time_format-(string.-optional))
-   [include\_tag\_key (Boolean. Optional, defaults to
    false)](#include_tag_key-(boolean.-optional,-defaults-to-false))
-   [tag\_key (String, Optional, defaults to
    "tag")](#tag_key-(string,-optional,-defaults-to-%E2%80%9Ctag%E2%80%9D))
-   [localtime (Boolean. Optional, defaults to
    true)](#localtime-(boolean.-optional,-defaults-to-true))
-   [timezone (String. Optional)](#timezone-(string.-optional))
-   [time\_as\_epoch (Boolean, Optional, defaults to
    false)](#time_as_epoch-(boolean,-optional,-defaults-to-false))

[Example](#example)
:::

Parameters
----------

[]{#add_newline-(boolean,-optional,-defaults-to-true)}

### add\_newline (Boolean, Optional, defaults to true)

Add `\n` to the result.

[]{#include_time_key-(boolean,-optional,-defaults-to-false)}

### include\_time\_key (Boolean, Optional, defaults to false)

If true, the time field (as specified by the `time_key` parameter) is
kept in the record.

[]{#time_key-(string,-optional,-defaults-to-%E2%80%9Ctime%E2%80%9D)}

### time\_key (String, Optional, defaults to "time")

The field name for the time key.

[]{#time_format-(string.-optional)}

### time\_format (String. Optional)

By default, the output format is iso8601 (e.g. "2008-02-01T21:41:49").
One can specify their own format with this parameter.

[]{#include_tag_key-(boolean.-optional,-defaults-to-false)}

### include\_tag\_key (Boolean. Optional, defaults to false)

If true, the tag field (as specified by the `tag_key` parameter) is kept
in the record.

[]{#tag_key-(string,-optional,-defaults-to-%E2%80%9Ctag%E2%80%9D)}

### tag\_key (String, Optional, defaults to "tag")

The field name for the tag key.

[]{#localtime-(boolean.-optional,-defaults-to-true)}

### localtime (Boolean. Optional, defaults to true)

If true, use local time. Otherwise, UTC is used. This parameter is
overwritten by the `utc` parameter.

[]{#timezone-(string.-optional)}

### timezone (String. Optional)

By setting this parameter, one can parse the time value in the specified
timezone. The following formats are accepted:

1.  \[+-\]HH:MM (e.g. "+09:00")
2.  \[+-\]HHMM (e.g. "+0900")
3.  \[+-\]HH (e.g. "+09")
4.  Region/Zone (e.g. "Asia/Tokyo")
5.  Region/Zone/Zone (e.g. "America/Argentina/Buenos\_Aires")

The timezone set in this parameter takes precedence over
`localtime`\*\*, e.g., if `localtime` is set to `true` but `timezone` is
set to `+0000`, UTC would be used.

[]{#time_as_epoch-(boolean,-optional,-defaults-to-false)}

### time\_as\_epoch (Boolean, Optional, defaults to false)

Set integer event time instead of stringanized time to `time_key`.

[]{#example}

Example
-------

``` {.CodeRay}
tag:    app.event
time:   1362020400
record: {"host":"192.168.0.1","size":777,"method":"PUT"}
```

This incoming event is formatted to:

``` {.CodeRay}
{"host"=>"192.168.0.1","size"=>777,"method"=>"PUT"}
```

::: {style="text-align:right"}
Last updated: 2018-11-06 18:17:11 +0000
:::

------------------------------------------------------------------------

::: {style="text-align:right"}
Versions \| [v1.0 (td-agent3)](/v1.0/articles/formatter_hash) \|
***v0.12* (td-agent2) **
:::

------------------------------------------------------------------------

If this article is incorrect or outdated, or omits critical information,
please [let us
know](https://github.com/fluent/fluentd-docs/issues?state=open).
[Fluentd](http://www.fluentd.org/) is a open source project under [Cloud
Native Computing Foundation (CNCF)](https://cncf.io/). All components
are available under the Apache 2 License.
:::
:::
:::
