# Getting Data From Syslog Into S3 Using Fluentd

Looking to get data out of syslog into s3? You can do that with
[fluentd](//fluentd.org) in **10 minutes**!

![](/images/plugin_icon/syslog.png)


![](/images/plugin_icon/s3.png)

Here is how:

``` {.CodeRay}
$ gem install fluentd
$ gem install fluent-plugin-s3
$ touch fluentd.conf
```

`fluentd.conf` should look like this (just copy and paste this into
fluentd.conf):

``` {.CodeRay}
<source>
  @type syslog
  port 5140
  bind 0.0.0.0
  tag system.local
</source>

<match **>
  @type s3
  path <s3 path> #(optional; default="")
  time_format <format string> #(optional; default is ISO-8601)
  aws_key_id <Your AWS key id> #(required)
  aws_sec_key <Your AWS secret key> #(required)
  s3_bucket <s3 bucket name> #(required)
  s3_endpoint <s3 endpoint name> #(required; ex: s3-us-west-1.amazonaws.com)
  s3_object_key_format <format string> #(optional; default="%{path}%{time_slice}_%{index}.%{file_extension}")
  auto_create_bucket <true/false> #(optional; default=true)
  check_apikey_on_start <true/false> #(optional; default=true)
  proxy_uri <proxy uri string> #(optional)
</match>
```

After that, you can start fluentd and everything should work:

``` {.CodeRay}
$ fluentd -c fluentd.conf
```

Of course, this is just a quick example. If you are thinking of running
fluentd in production, consider using [td-agent](/articles/td-agent.md),
the enterprise version of Fluentd packaged and maintained by [Treasure
Data, Inc.](//www.treasure-data.com).


------------------------------------------------------------------------

If this article is incorrect or outdated, or omits critical information, please [let us know](https://github.com/fluent/fluentd-docs-gitbook/issues?state=open).
[Fluentd](http://www.fluentd.org/) is a open source project under [Cloud Native Computing Foundation (CNCF)](https://cncf.io/). All components are available under the Apache 2 License.
