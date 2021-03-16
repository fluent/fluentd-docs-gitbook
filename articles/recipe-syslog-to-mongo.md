# Recipe Syslog To Mongo

Looking to get data out of syslog into mongo? You can do that with [fluentd](https://github.com/fluent/fluentd-docs-gitbook/tree/507e377b7e8e78a312dc49e76bd9a302c33fd058/fluentd.org) in **10 minutes**!

![](../.gitbook/assets/syslog%20%281%29%20%281%29%20%281%29%20%281%29%20%281%29.png)

![](../.gitbook/assets/mongo%20%282%29%20%282%29%20%282%29%20%282%29.png)

Here is how:

```text
$ gem install fluentd
$ gem install fluent-plugin-mongo
$ touch fluentd.conf
```

`fluentd.conf` should look like this \(just copy and paste this into fluentd.conf\):

```text
<source>
  @type syslog
  port 5140
  bind 0.0.0.0
  tag system.local
</source>

<match **>
  @type mongo
  database <db name> #(required)
  collection <collection name> #(optional; default="untagged")
  host <hostname> #(optional; default="localhost")
  port <port> #(optional; default=27017)
</match>
```

After that, you can start fluentd and everything should work:

```text
$ fluentd -c fluentd.conf
```

Of course, this is just a quick example. If you are thinking of running fluentd in production, consider using [td-agent](https://github.com/fluent/fluentd-docs-gitbook/tree/507e377b7e8e78a312dc49e76bd9a302c33fd058/articles/td-agent.md), the enterprise version of Fluentd packaged and maintained by [Treasure Data, Inc.](https://www.treasure-data.com).

If this article is incorrect or outdated, or omits critical information, please [let us know](https://github.com/fluent/fluentd-docs-gitbook/issues?state=open). [Fluentd](http://www.fluentd.org/) is a open source project under [Cloud Native Computing Foundation \(CNCF\)](https://cncf.io/). All components are available under the Apache 2 License.

