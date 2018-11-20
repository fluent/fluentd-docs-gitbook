# Amazon S3 Output Plugin

The `out_s3` Output plugin writes records into the Amazon S3 cloud
object storage service. By default, it creates files on an hourly basis.
This means that when you first import records using the plugin, no file
is created immediately.

The file will be created when the `timekey` condition has been met. To
change the output frequency, please modify the `timekey` value in buffer
section. In more detail, please refer to [the time chunk keys in
bufferdocument](https://docs.fluentd.org/articles/buffer-section#time).

This document doesn\'t describe all parameters. If you want to know full
features, check the Further Reading section.


## Installation

`out_s3` is included in td-agent by default. Fluentd gem users will need
to install the fluent-plugin-s3 gem. In order to install it, please
refer to the [Plugin Management](/articles/plugin-management.md) article.


## Example Configuration

``` {.CodeRay}
<match pattern>
  @type s3

  aws_key_id YOUR_AWS_KEY_ID
  aws_sec_key YOUR_AWS_SECRET_KEY
  s3_bucket YOUR_S3_BUCKET_NAME
  s3_region ap-northeast-1
  path logs/
  # if you want to use ${tag} or %Y/%m/%d/ like syntax in path / s3_object_key_format,
  # need to specify tag for ${tag} and time for %Y/%m/%d in <buffer> argument.
  <buffer tag,time>
    @type file
    path /var/log/fluent/s3
    timekey 3600 # 1 hour partition
    timekey_wait 10m
    timekey_use_utc true # use utc
    chunk_limit_size 256m
  </buffer>
</match>
```

Please see the [Store Apache Logs into Amazon S3](/articles/apache-to-s3.md) article
for real-world use cases.

Please see the [Config File](/articles/config-file.md) article for the basic
structure and syntax of the configuration file.

For \<buffer\> section, please check [Buffer section cofiguration](/articles/buffer-section.md). This plugin uses [file buffer](/articles/buf_file.md)
by default.


## Parameters

[]{#@type-(required)}

### \@type (required)

The value must be `s3`.


### aws\_key\_id

    type         default        version
  -------- ------------------- ---------
   string   required/optional    1.0.0

The AWS access key id. This parameter is required when your agent is not
running on an EC2 instance with an IAM Instance Profile.


### aws\_sec\_key

    type         default        version
  -------- ------------------- ---------
   string   required/optional    1.0.0

The AWS secret key. This parameter is required when your agent is not
running on an EC2 instance with an IAM Instance Profile.


### s3\_bucket

    type    default    version
  -------- ---------- ---------
   string   required    1.0.0

The Amazon S3 bucket name.


### buffer

The buffer of the S3 plugin. The default settings is time sliced buffer.

See [buffer article](/articles/buffer-plugin-overview.md) for more detail.


### s3\_region

    type                  default                 version
  -------- ------------------------------------- ---------
   string   ENV\["AWS\_REGION"\] or "us-east-1"    1.0.0

The Amazon S3 region name. Please select the appropriate region name and
confirm that your bucket has been created in the correct region. Here
are the region examples.

-   us-east-1
-   us-west-1
-   eu-central-1
-   ap-southeast-1
-   sa-east-1

The full list can be found [official AWS
document](http://docs.aws.amazon.com/general/latest/gr/rande.html#s3_region).


### s3\_endpoint

    type    default   version
  -------- --------- ---------
   string     nil      1.0.0

This option is deprecated because latest aws-sdk ignores this option.
Please use `s3_region` instead.

The Amazon S3 enpoint name. Please select the appropriate endpoint name
from the list below and confirm that your bucket has been created in the
correct region.

-   s3.amazonaws.com
-   s3-us-west-1.amazonaws.com
-   s3-us-west-2.amazonaws.com
-   s3.sa-east-1.amazonaws.com
-   s3-eu-west-1.amazonaws.com
-   s3-ap-southeast-1.amazonaws.com
-   s3-ap-northeast-1.amazonaws.com

The most recent versions of the endpoints can be found
[here](http://docs.aws.amazon.com/general/latest/gr/rande.html#s3_region).

[]{#<format>-directive}

### \<format\> directive

The format of the object content. The default is `out_file`.

Here is json example:

``` {.CodeRay}
<format>
  @type json
</format>
```

See [formatter article](/articles/formatter-plugin-overview.md) for more detail.


### format

Deprecated parameter. Use `<format>` instead.


### time\_slice\_format

    type    default    version
  -------- ---------- ---------
   string   ISO-8601    1.0.0

The format of the time written in files.


### path

    type    default   version
  -------- --------- ---------
   string     ""       1.0.0

The path prefix of the files on S3. The default is "" (no prefix).

The actual path on S3 will be:
"{path}{time\_slice\_format}\_{sequential\_index}.gz" (see
\`s3\_object\_key\_format\`)


### s3\_object\_key\_format

    type                          default                          version
  -------- ------------------------------------------------------ ---------
   string   "%{path}%{time\_slice}\_%{index}.%{file\_extension}"    1.0.0

The actual S3 path. This is interpolated to the actual path (ex: Ruby's
variable interpolation).

-   path: the value of the `path` parameter above
-   time\_slice: the time string as formatted by `time_slice_format`
-   index: the index for the given path. Incremented per buffer flush
-   file\_extension: as determined by the `store_as` parameter.

For example, if

-   `s3_object_key_format` is as default
-   `path` is "hello"
-   `time_slice_format` is "%Y%m%d"
-   `store_as` is "json"

Then, "hello20141111\_0.json" would be an example actual S3 path.

This parameter is for advanced users. Most users should NOT modify it.
Also, always make sure that %{index} appears in the customized
\`s3\_object\_key\_format\` (Otherwise, multiple buffer flushes within
the same time slice throws an error).


### store\_as

    type    default   version
  -------- --------- ---------
   string   "gzip"     1.0.0

The compression type. You can also choose "lzo", "json", or "txt".


### proxy\_uri

    type    default   version
  -------- --------- ---------
   string     nil      1.0.0

The proxy url. The default is nil.


### ssl\_verify\_peer

   type   default   version
  ------ --------- ---------
   bool    true      1.0.0

Verify SSL certificate of the endpoint. Set false when you want to
ignore the endpoint SSL certificate.

#### \@log\_level option

The `@log_level` option allows the user to set different levels of
logging for each plugin. The supported log levels are: `fatal`, `error`,
`warn`, `info`, `debug`, and `trace`.

Please see the [logging article](/articles/logging.md) for further details.


## Further Reading

This page doesn't describe all the possible configurations. If you want
to know about other configurations, please check the link below.

-   [fluent-plugin-s3
    repository](https://github.com/fluent/fluent-plugin-s3)


------------------------------------------------------------------------

If this article is incorrect or outdated, or omits critical information,
please [let us know](https://github.com/fluent/fluentd-docs/issues?state=open).
[Fluentd](http://www.fluentd.org/) is a open source project under [Cloud Native Computing Foundation (CNCF)](https://cncf.io/). All components
are available under the Apache 2 License.
