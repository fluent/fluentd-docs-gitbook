# Recipe Apache Logs To S3

Looking to get data out of apache logs into s3? You can do that with [fluentd](https://github.com/fluent/fluentd-docs-gitbook/tree/507e377b7e8e78a312dc49e76bd9a302c33fd058/fluentd.org) in **10 minutes**!

![](../.gitbook/assets/apache_logs%20%283%29%20%283%29%20%283%29%20%283%29%20%281%29.png)

![](../.gitbook/assets/s3%20%283%29%20%283%29%20%282%29.png)

Here is how:

```text
$ gem install fluentd
$ gem install fluent-plugin-s3
$ touch fluentd.conf
```

`fluentd.conf` should look like this \(just copy and paste this into fluentd.conf\):

```text
<source>
  @type tail
  path /var/log/httpd-access.log #...or where you placed your Apache access log
  pos_file /var/log/td-agent/httpd-access.log.pos # This is where you record file position
  tag apache.access #fluentd tag!
  format apache2 # Do you have a custom format? You can write your own regex.
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

```text
$ fluentd -c fluentd.conf
```

Of course, this is just a quick example. If you are thinking of running fluentd in production, consider using [td-agent](https://github.com/fluent/fluentd-docs-gitbook/tree/507e377b7e8e78a312dc49e76bd9a302c33fd058/articles/td-agent.md), the enterprise version of Fluentd packaged and maintained by [Treasure Data, Inc.](https://www.treasure-data.com).

If this article is incorrect or outdated, or omits critical information, please [let us know](https://github.com/fluent/fluentd-docs-gitbook/issues?state=open). [Fluentd](http://www.fluentd.org/) is a open source project under [Cloud Native Computing Foundation \(CNCF\)](https://cncf.io/). All components are available under the Apache 2 License.

