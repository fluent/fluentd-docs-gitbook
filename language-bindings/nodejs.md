# Nodejs

The [`@fluent-org/logger`](https://github.com/fluent/fluent-logger-forward-node) library is used to post records from Node.js applications to Fluentd. 

This article explains how to use it.

NOTE: The previous NPM package, [`fluent-logger`](https://github.com/fluent/fluent-logger-node) has been deprecated in favor of `@fluent-org/logger`.

## Prerequisites

* Basic knowledge of Node.js and NPM
* Basic knowledge of Fluentd
* Node.js 12.0 or higher

## Installing Fluentd

Please refer to the following document to install Fluentd:

* [Installation](../installation/)

## Modifying the Config File

Configure Fluentd to use the [`forward`](../input/forward.md) input plugin as its data source:

```text
<source>
  @type forward
  port 24224
</source>
<match fluentd.test.**>
  @type stdout
</match>
```

Restart agent after configuring.

```text
# for rpm/deb only
$ sudo /etc/init.d/td-agent restart

# or systemd
$ sudo systemctl restart td-agent.service
```

## Using `@fluent-org/logger`

### Obtaining the Most Recent Version

The most recent version of `@fluent-org/logger` can be found [here](https://www.npmjs.com/package/@fluent-org/logger).

### A Sample Application

Here is a sample [Express](http://expressjs.com/) app using `@fluent-org/logger`:

#### `package.json`

```text
{
  "name": "node-example",
  "version": "0.0.1",
  "dependencies": {
    "express": "^4.16.0",
    "@fluent-org/logger": "^1.0.2"
  }
}
```

Use `npm` to install dependencies locally:

```text
$ npm install
```

#### `index.js`

This is a simple web app:

```text
const express = require('express');
const FluentClient = require('@fluent-org/logger').FluentClient;
const app = express();

// The 2nd argument can be omitted. Here is a default value for options.
const logger = new FluentClient('fluentd.test', {
  socket: {
    host: 'localhost',
    port: 24224,
    timeout: 3000, // 3 seconds
  }
});

app.get('/', function(request, response) {
  logger.emit('follow', {from: 'userA', to: 'userB'});
  response.send('Hello World!');
});
const port = process.env.PORT || 3000;
app.listen(port, function() {
  console.log("Listening on " + port);
});
```

Run the app and go to `http://localhost:3000/` in your browser to send the logs to Fluentd:

```text
$ node index.js
```

The logs should be output to `/var/log/td-agent/td-agent.log` or the standard output of the Fluentd process via [`stdout`](../output/stdout.md) output plugin.

## Production Deployments

### Output Plugins

Various [output plugins](../output/) are available for writing records to other destinations:

* Examples
  * [Store Apache Logs into Amazon S3](../how-to-guides/apache-to-s3.md)
  * [Store Apache Logs into MongoDB](../how-to-guides/apache-to-mongodb.md)
  * [Data Collection into HDFS](../how-to-guides/http-to-hdfs.md)
* List of Plugin References
  * [Output to Another Fluentd](../output/forward.md)
  * [Output to MongoDB](../output/mongo.md) or [MongoDB ReplicaSet](../output/mongo_replset.md)
  * [Output to Hadoop](../output/webhdfs.md)
  * [Output to File](../output/file.md)
  * [etc...](http://fluentd.org/plugin/)

### High-Availability Configurations of Fluentd

For high-traffic websites \(more than 5 application nodes\), we recommend using the high-availability configuration for `td-agent`. This will improve the reliability of data transfer and query performance.

* [High-Availability Configurations of Fluentd](../deployment/high-availability.md)

### Monitoring

Monitoring Fluentd itself is also important. The article below describes the general monitoring methods for `td-agent`.

* [Monitoring Fluentd](../monitoring-fluentd/overview.md)

If this article is incorrect or outdated, or omits critical information, please [let us know](https://github.com/fluent/fluentd-docs-gitbook/issues?state=open). [Fluentd](http://www.fluentd.org/) is an open-source project under [Cloud Native Computing Foundation \(CNCF\)](https://cncf.io/). All components are available under the Apache 2 License.

