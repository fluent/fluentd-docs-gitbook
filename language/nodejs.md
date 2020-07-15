# Centralize Logs from Node.js Applications

The [`fluent-logger-node`](https://github.com/fluent/fluent-logger-node)
library is used to post records from Node.js applications to Fluentd.

This article explains how to use it.


## Prerequisites

-   Basic knowledge of Node.js and NPM
-   Basic knowledge of Fluentd
-   Node.js 6.0 or higher


## Installing Fluentd

Please refer to the following documents to install fluentd:

-   [Install Fluentd with rpm Package](/install/install-by-rpm.md)
-   [Install Fluentd with deb Package](/install/install-by-deb.md)
-   [Install Fluentd with Ruby Gem](/install/install-by-gem.md)
-   [Install Fluentd from source](/install/install-from-source.md)


## Modifying the Config File

Configure Fluentd to use the [`forward`](/plugins/input/forward.md) input plugin
as its data source:

```
<source>
  @type forward
  port 24224
</source>
<match fluentd.test.**>
  @type stdout
</match>
```

Restart agent after configuring.

```
# for rpm/deb only
$ sudo /etc/init.d/td-agent restart

# or systemd
$ sudo systemctl restart td-agent.service
```


## Using `fluent-logger-node`


### Obtaining the Most Recent Version

The most recent version of `fluent-logger-node` can be found
[here](https://www.npmjs.com/package/fluent-logger).


### A Sample Application

Here is a sample [Express](http://expressjs.com/) app using `fluent-logger-node`:

#### `package.json`

```
{
  "name": "node-example",
  "version": "0.0.1",
  "dependencies": {
    "express": "^4.16.0",
    "fluent-logger": "^3.2.0"
  }
}
```

Use `npm` to install dependencies locally:

```
$ npm install
```


#### `index.js`

This is a simple web app:

```
const express = require('express');
const logger = require('fluent-logger');
const app = express();

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
const port = process.env.PORT || 3000;
app.listen(port, function() {
  console.log("Listening on " + port);
});
```

Run the app and go to `http://localhost:3000/` in your browser to send
the logs to Fluentd:

```
$ node index.js
```

The logs should be output to `/var/log/td-agent/td-agent.log` or the standard
output of the Fluentd process via [`stdout`](/plugins/output/stdout.md) output
plugin.


## Production Deployments


### Output Plugins

Various [output plugins](/plugins/output/README.md) are available for
writing records to other destinations:

-   Examples
    -   [Store Apache Logs into Amazon S3](/guides/apache-to-s3.md)
    -   [Store Apache Logs into MongoDB](/guides/apache-to-mongodb.md)
    -   [Data Collection into HDFS](/guides/http-to-hdfs.md)
-   List of Plugin References
    -   [Output to Another Fluentd](/plugins/output/forward.md)
    -   [Output to MongoDB](/plugins/output/mongo.md) or [MongoDB ReplicaSet](/plugins/output/mongo_replset.md)
    -   [Output to Hadoop](/plugins/output/webhdfs.md)
    -   [Output to File](/plugins/output/file.md)
    -   [etc...](http://fluentd.org/plugin/)


### High-Availability Configurations of Fluentd

For high-traffic websites (more than 5 application nodes), we recommend using
high-availability configuration for `td-agent`. This will improve the
reliability of data transfer and query performance.

-   [High-Availability Configurations of Fluentd](/deployment/high-availability.md)


### Monitoring

Monitoring Fluentd itself is also important. The article below describes
general monitoring methods for `td-agent`.

-   [Monitoring Fluentd](/deployment/monitoring.md)


------------------------------------------------------------------------

If this article is incorrect or outdated, or omits critical information, please
[let us know](https://github.com/fluent/fluentd-docs-gitbook/issues?state=open).
[Fluentd](http://www.fluentd.org/) is an open-source project under [Cloud Native
Computing Foundation (CNCF)](https://cncf.io/). All components are available
under the Apache 2 License.
