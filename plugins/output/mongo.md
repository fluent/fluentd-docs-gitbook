# MongoDB Output Plugin

![](/images/plugins/output/mongo.png)

The `out_mongo` Output plugin writes records into
[MongoDB](http://mongodb.org/), the emerging document-oriented database
system.

If you're using ReplicaSet, please see the
[out\_mongo\_replset](/plugins/output/mongo_replset.md) article instead.

This document doesn't describe all parameters. If you want to know full
features, check the Further Reading section.


## Why Fluentd with MongoDB?

Fluentd enables your apps to insert records to MongoDB asynchronously
with batch-insertion, unlike direct insertion of records from your apps.
This has the following advantages:

1.  less impact on application performance
2.  higher MongoDB insertion throughput while maintaining JSON record
    structure


## Install

`out_mongo` is not included in td-agent by default. Fluentd gem users
will need to install the fluent-plugin-mongo gem using the following
command.

``` {.CodeRay}
$ fluent-gem install fluent-plugin-mongo
```

For more details, see [Plugin Management](/deployment/plugin-management.md).


## Example Configuration

``` {.CodeRay}
# Single MongoDB
<match mongo.**>
  @type mongo
  host fluentd
  port 27017
  database fluentd
  collection test

  # for capped collection
  capped
  capped_size 1024m

  # authentication
  user michael
  password jordan

  <inject>
    # key name of timestamp
    time_key time
  </inject>

  <buffer>
    # flush
    flush_interval 10s
  </buffer>
</match>
```

Please see the [Store Apache Logs into MongoDB](/guides/apache-to-mongodb.md)
article for real-world use cases.

Please see the [Config File](/configuration/config-file.md) article for the basic
structure and syntax of the configuration file. For \<buffer\> section,
please check [Buffer section cofiguration](/configuration/buffer-section.md).


## Parameters


### type

The value must be `mongo`.


### host

| type   | default     | version |
|:-------|:------------|:--------|
| string | 'localhost' | 1.0.0   |

The MongoDB hostname.


### port (required)

| type    | default | version |
|:--------|:--------|:--------|
| integer | 27017   | 1.0.0   |

The MongoDB port.


### database

| type   | default            | version |
|:-------|:-------------------|:--------|
| string | required parameter | 1.0.0   |

The database name.


### collection (required, if not tag\_mapped)

| type   | default                                              | version |
|:-------|:-----------------------------------------------------|:--------|
| string | 'untagged' or required parameter if not `tag_mapped` | 1.0.0   |

The collection name.


### capped

| type   | default  | version |
|:-------|:---------|:--------|
| string | optional | 1.0.0   |

This option enables capped collection. This is always recommended
because MongoDB is not suited to storing large amounts of historical
data.

#### capped\_size

| type | default  | version |
|:-----|:---------|:--------|
| size | optional | 1.0.0   |

Sets the capped collection size.


### user

| type   | default | version |
|:-------|:--------|:--------|
| string | `nil`   | 1.0.0   |

The username to use for authentication.


### password

| type   | default | version |
|:-------|:--------|:--------|
| string | `nil`   | 1.0.0   |

The password to use for authentication.


### time\_key

| type   | default | version |
|:-------|:--------|:--------|
| string | `time`  | 1.0.0   |

The key name of timestamp. (default is "time")


### tag\_mapped

| type | default | version |
|:-----|:--------|:--------|
| bool | `false` | 1.0.0   |

This option will allow out\_mongo to use Fluentd's tag to determine the
destination collection. For example, if you generate records with tags
'mongo.foo', the records will be inserted into the `foo` collection
within the `fluentd` database.

``` {.CodeRay}
<match mongo.*>
  @type mongo
  host fluentd
  port 27017
  database fluentd

  # Set 'tag_mapped' if you want to use tag mapped mode.
  tag_mapped

  # If the tag is "mongo.foo", then the prefix "mongo." is removed.
  # The inserted collection name is "foo".
  remove_tag_prefix mongo.

  # This configuration is used if the tag is not found. The default is 'untagged'.
  collection misc
</match>
```

This option is useful for flexible log collection.


## Common Output / Buffer parameters

For common output / buffer parameters, please check the following
articles.

-   [Output Plugin Overview](/plugins/output/README.md)
-   [Buffer Section Configuration](/configuration/buffer-section.md)


## Further Reading

-   [fluent-plugin-mongo repository](https://github.com/fluent/fluent-plugin-mongo)


------------------------------------------------------------------------

If this article is incorrect or outdated, or omits critical information, please [let us know](https://github.com/fluent/fluentd-docs/issues?state=open).
[Fluentd](http://www.fluentd.org/) is a open source project under [Cloud Native Computing Foundation (CNCF)](https://cncf.io/). All components are available under the Apache 2 License.
