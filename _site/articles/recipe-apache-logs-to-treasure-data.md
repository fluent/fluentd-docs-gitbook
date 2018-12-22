# Getting Data From Apache Logs Into Treasure Data Using Fluentd

Looking to get data out of apache logs into treasure data? You can do
that with [fluentd](//fluentd.org) in **10 minutes**!

![](/images/plugin_icon/apache_logs.png)


![](/images/plugin_icon/treasure_data.png)

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
  @type tail
  path /var/log/httpd-access.log #...or where you placed your Apache access log
  pos_file /var/log/td-agent/httpd-access.log.pos # This is where you record file position
  tag apache.access #fluentd tag!
  format apache2 # Do you have a custom format? You can write your own regex.
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
fluentd in production, consider using [td-agent](/articles/td-agent.md), the
enterprise version of Fluentd packaged and maintained by [Treasure Data,
Inc.](//www.treasure-data.com).


------------------------------------------------------------------------

If this article is incorrect or outdated, or omits critical information, please [let us know](https://github.com/fluent/fluentd-docs/issues?state=open).
[Fluentd](http://www.fluentd.org/) is a open source project under [Cloud Native Computing Foundation (CNCF)](https://cncf.io/). All components are available under the Apache 2 License.
