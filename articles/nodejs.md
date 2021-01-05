# Nodejs

The '[fluent-logger-node](https://github.com/fluent/fluent-logger-node)' library is used to post records from Node.js applications to Fluentd.

This article explains how to use the fluent-logger-node library.

## Prerequisites

* Basic knowledge of Node.js and NPM
* Basic knowledge of Fluentd
* Node.js 0.6 or higher

## Installing Fluentd

Please refer to the following documents to install fluentd.

* [Install Fluentd with rpm Package](install-by-rpm.md)
* [Install Fluentd with deb Package](install-by-deb.md)
* [Install Fluentd with Ruby Gem](install-by-gem.md)
* [Install Fluentd from source](install-from-source.md)

## Modifying the Config File

Next, please configure Fluentd to use the [forward Input plugin]() as its data source.

```text
<source>
  @type forward
  port 24224
</source>
<match fluentd.test.**>
  @type stdout
</match>
```

Please restart your agent once these lines are in place.

```text
# for rpm/deb only
$ sudo /etc/init.d/td-agent restart
```

## Using fluent-logger-node

### Obtaining the Most Recent Version

The most recent version of fluent-logger-node can be found [here](https://www.npmjs.com/package/fluent-logger).

### A Sample Application

A sample [Express](http://expressjs.com/) app using fluent-logger-node is shown below.

#### package.json

```text
{
  "name": "node-example",
  "version": "0.0.1",
  "dependencies": {
    "express": "^4.15.3",
    "fluent-logger": "^2.4.0"
  }
}
```

Now use _npm_ to install your dependencies locally:

```text
$ npm install
```

#### index.js

This is the simplest web app.

```text
var express = require('express');
var logger = require('fluent-logger');
var app = express();

// The 2nd argument can be omitted. Here is a default value for options.
logger.configure('fluentd.test', {
  host: 'localhost',
  port: 24224,
  timeout: 3.0,
  reconnectInterval: 600000 // 10 minutes
});

app.get('/', function(request, response) {
  logger.emit('follow', {from: 'userA', to: 'userB'});
  response.send('Hello World!');
});
var port = process.env.PORT || 3000;
app.listen(port, function() {
  console.log("Listening on " + port);
});
```

Run the app and go to `http://localhost:3000/` in your browser. This will send the logs to Fluentd.

```text
$ node index.js
```

The logs should be output to `/var/log/td-agent/td-agent.log` or stdout of the Fluentd process via the [stdout Output plugin]().

## Production Deployments

### Output Plugins

Various [output plugins]() are available for writing records to other destinations:

* Examples
  * [Store Apache Logs into Amazon S3](apache-to-s3.md)
  * [Store Apache Logs into MongoDB](apache-to-mongodb.md)
  * [Data Collection into HDFS](http-to-hdfs.md)
* List of Plugin References
  * [Output to Another Fluentd]()
  * [Output to MongoDB]() or [MongoDB ReplicaSet]()
  * [Output to Hadoop]()
  * [Output to File]()
  * [etc...](http://fluentd.org/plugin/)

### High-Availability Configurations of Fluentd

For high-traffic websites \(more than 5 application nodes\), we recommend using a high availability configuration of td-agent. This will improve data transfer reliability and query performance.

* [High-Availability Configurations of Fluentd](../deployment/high-availability.md)

### Monitoring

Monitoring Fluentd itself is also important. The article below describes general monitoring methods for td-agent.

* [Monitoring Fluentd](../deployment/monitoring.md)

If this article is incorrect or outdated, or omits critical information, please [let us know](https://github.com/fluent/fluentd-docs-gitbook/issues?state=open). [Fluentd](http://www.fluentd.org/) is a open source project under [Cloud Native Computing Foundation \(CNCF\)](https://cncf.io/). All components are available under the Apache 2 License.

