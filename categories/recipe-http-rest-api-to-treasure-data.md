::: {#main .section}
::: {#page}
::: {.topic_content}
::: {style="text-align:right"}
::: {style="text-align:right"}
Versions \| ***v0.12* (td-agent2) **
:::
:::

------------------------------------------------------------------------

Getting Data From Http Rest Api Into Treasure Data Using Fluentd
================================================================

Looking to get data out of http rest api into treasure data? You can do
that with [fluentd](//fluentd.org) in **10 minutes**!

![](/images/plugin_icon/http_rest_api.png)
:::
:::
:::

[→]{style="font-size:50px"}

![](/images/plugin_icon/treasure%20data.png)

Here is how:

``` {.CodeRay}
$ gem install fluentd
$ gem install fluent-plugin-td
$ touch fluentd.conf
```

`fluentd.conf` should look like this (just copy and paste this into
fluentd.conf):

``` {.CodeRay}
<source>
  @type http
  port 8888
  bind 0.0.0.0
  body_size_limit 32m
  keepalive_timeout 10s
  # tag is part of the URL, e.g.,
  # curl -X POST -d 'json={"action":"login","user":2}' http://localhost:8888/tag.here
</source>

<match **>
  @type tdlog
  apikey <Treasure Data API key> # You get your API key by signing up for Treasure Data
  auto_create_table
  buffer_type file
  buffer_path /var/log/td-agent/buffer/td
</match>
```

After that, you can start fluentd and everything should work:

``` {.CodeRay}
$ fluentd -c fluentd.conf
```

Of course, this is just a quick example. If you are thinking of running
fluentd in production, consider using [td-agent](articles/td-agent), the
enterprise version of Fluentd packaged and maintained by [Treasure Data,
Inc.](//www.treasure-data.com).

::: {style="text-align:right"}
Last updated: 2016-06-13 06:11:23 UTC
:::

------------------------------------------------------------------------

::: {style="text-align:right"}
Versions \| ***v0.12* (td-agent2) **
:::

------------------------------------------------------------------------

If this article is incorrect or outdated, or omits critical information,
please [let us
know](https://github.com/fluent/fluentd-docs/issues?state=open).
[Fluentd](http://www.fluentd.org/) is a open source project under [Cloud
Native Computing Foundation (CNCF)](https://cncf.io/). All components
are available under the Apache 2 License.
