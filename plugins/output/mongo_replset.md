# MongoDB ReplicaSet Output Plugin

![](/images/plugins/output/mongo_replset.png)

The `out_mongo_replset` Output plugin writes records into
[MongoDB](http://mongodb.org/), the emerging document-oriented database
system.

This plugin is for users using ReplicaSet. If you are not using
ReplicaSet, please see the [out\_mongo](/plugins/output/mongo.md) article instead.

This plugin has breaking changes since 0.8.0 due to mongo-ruby driver's
breaking changes. If you are using prior 0.7.x series, please be careful
to upgrade 1.0.0 or later versions.


## Why Fluentd with MongoDB?

Fluentd enables your apps to insert records to MongoDB asynchronously
with batch-insertion, unlike direct insertion of records from your apps.
This has the following advantages:

1.  less impact on application performance
2.  higher MongoDB insertion throughput while maintaining JSON record
    structure


## Install

`out_mongo_replset` is not included in td-agent by default. Fluentd gem
users will need to install the fluent-plugin-mongo gem using the
following command.

```
$ fluent-gem install fluent-plugin-mongo
```


## Example Configuration

```
# Single MongoDB
<match mongo.**>
  @type mongo_replset
  database fluentd
  collection test
  nodes localhost:27017,localhost:27018,localhost:27019

  # The name of the replica set
  replica_set myapp

  <buffer>
    # flush
    flush_interval 10s
  </buffer>
</match>
```

Please see the [Store Apache Logs into MongoDB](/guides/apache-to-mongodb.md)
article for real-world use cases.

Please see the [Config File](/configuration/config-file.md) article for the basic
structure and syntax of the configuration file. For `<buffer>` section,
please check [Buffer section cofiguration](/configuration/buffer-section.md).


## Parameters


### type

The value must be `mongo`.


### nodes

| type   | default            | version |
|:-------|:-------------------|:--------|
| string | required parameter | 1.0.0   |

The comma separated node strings (e.g.
host1:27017,host2:27017,host3:27017).


### database

| type   | default            | version |
|:-------|:-------------------|:--------|
| string | required parameter | 1.0.0   |

The database name.


### collection

| type   | default                                | version |
|:-------|:---------------------------------------|:--------|
| string | required parameter if not `tag_mapped` | 1.0.0   |

The collection name.


### capped

| type   | default  | version |
|:-------|:---------|:--------|
| string | optional | 1.0.0   |

This option enables capped collection. This is always recommended
because MongoDB is not suited to storing large amounts of historical
data.


### capped\_size

| type | default  | version |
|:-----|:---------|:--------|
| size | optional | 1.0.0   |

Sets the capped collection size.


### user

| type   | default  | version |
|:-------|:---------|:--------|
| string | optional | 1.0.0   |

The username to use for authentication.


### password

| type   | default  | version |
|:-------|:---------|:--------|
| string | optional | 1.0.0   |

The password to use for authentication.


### tag\_mapped

| type   | default  | version |
|:-------|:---------|:--------|
| string | optional | 1.0.0   |

This option will allow out\_mongo to use Fluentd's tag to determine the
destination collection.

For example, if you generate records with tags 'mongo.foo', the records
will be inserted into the `foo` collection within the `fluentd`
database.

```
<match mongo.*>
  @type mongo_replset
  database fluentd
  nodes localhost:27017,localhost:27018,localhost:27019

  # Set 'tag_mapped' if you want to use tag mapped mode.
  tag_mapped

  # If the tag is "mongo.foo", then the prefix "mongo." is removed.
  # The inserted collection name is "foo".
  remove_tag_prefix mongo.

  # This configuration is used if the tag is not found. The default is 'untagged'.
  collection misc
</match>
```


### replica\_set

| type   | default            | version |
|:-------|:-------------------|:--------|
| string | required parameter | 1.0.0   |

The name of the replica set.


### read

| type   | default | version |
|:-------|:--------|:--------|
| string | `nil`   | 1.0.0   |

The ReplicaSet read preference (e.g. secondary, etc).


### num\_retries

| type    | default | version |
|:--------|:--------|:--------|
| integer | 60      | 1.0.0   |

The ReplicaSet failover threshold. The default threshold is 60. If the
retry count reaches this threshold, the plugin raises an exception.


## Common Output / Buffer parameters

For common output / buffer parameters, please check the following
articles.

-   [Output Plugin Overview](/plugins/output/README.md)
-   [Buffer Section Configuration](/configuration/buffer-section.md)


## Further Readings

-   [fluent-plugin-webhdfs mongo](https://github.com/fluent/fluent-plugin-mongo)


------------------------------------------------------------------------

If this article is incorrect or outdated, or omits critical information, please [let us know](https://github.com/fluent/fluentd-docs-gitbook/issues?state=open).
[Fluentd](http://www.fluentd.org/) is a open source project under [Cloud Native Computing Foundation (CNCF)](https://cncf.io/). All components are available under the Apache 2 License.
