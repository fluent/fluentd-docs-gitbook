# Fluentd and Graylog for End-to-End Log Analysis

This article explains how to set up Fluentd with [Graylog](https://www.graylog.org).
Graylog is a popular log management server powered by Elasticsearch and MongoDB.
You can combine Fluentd and Graylog to create a scalable log analytics pipline.

## Prerequisites

 - Basic understanding of Fluentd
 - Linux server (The following article is tested with Ubuntu 18.04 LTS)

## How to Setup Graylog + Fluentd

### Dependencies

Install the dependencies with the following command.

    $ sudo apt install mongodb-server openjdk-8-jre-headless uuid-runtime

### Elasticsearch

Graylog requires Elasticsearch, which can be instantly launched using
the following commands.

    # Note that Graylog 2.4 doesn't support Elasticsearch 6.X.
    $ wget https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-5.6.13.tar.gz
    $ tar -xzf elasticsearch-5.6.13.tar.gz
    $ cd elasticsearch-5.6.13

Elasticsearch is ready. Start it with

    $ ./bin/elasticsearch

### Graylog

In this article, we will use Graylog 2.4.

    $ wget https://packages.graylog2.org/repo/packages/graylog-2.4-repository_latest.deb
    $ sudo dpkg -i graylog-2.4-repository_latest.deb

Update the package cache and install `graylog-server`.

    $ sudo apt update
    $ sudo apt install graylog-server

Open `/etc/graylog/server/server.conf` and configure the following parameters:

 1. `password_secret`
 2. `root_password_sha2`.
 3. `web_enable`

For `root_password_sha2`, run `echo -n ROOT_PASSWORD | sha256sum` and set the hash.
Also you need to set `web_enable` to true to access the web interface.

Now let's start Graylog!

    $ sudo systemctl start graylog-server

### Prepare Graylog for Fluentd

Go to [http://localhost:9000](http://localhost:9000) and login into the web interface.

To log in, use "admin" as the username and "YOUR_PASSWORD" as the password (the
one you've set up for `root_password_sha2`).

Once logged in, click on "System" in the top nav. Next, click on "Inputs" from
the left nav. (Or, you can just go to [http://localhost:9000/system/inputs](http://localhost:9000/system/inputs).

Then, from the dropdown, choose "GELF UDP" and click on "Launch new input",
which should pop up a modal dialogue, Select the "Node" and fill the "Title".
Then, click "Save".

![](/images/graylog2-input.png)

Now, Graylog2 is ready to accept messages from Fluentd over UDP. It's time to
configure Fluentd.

### Fluentd

See [the download page](https://www.fluentd.org/download) for all the options.
Here, we are using the deb package.

    $ wget http://packages.treasuredata.com.s3.amazonaws.com/3/ubuntu/bionic/pool/contrib/t/td-agent/td-agent_3.2.1-0_amd64.deb
    $ sudo dpkg -i td-agent_3.2.1-0_amd64.deb

Then, install the `out_gelf` plugin to send data to Graylog. Currently, the
GELF plugin is not available on Rubygems, so we need to download the plugin
file and place it in `/etc/td-agent/plugin`.

    $ wget https://raw.githubusercontent.com/emsearcy/fluent-plugin-gelf/master/lib/fluent/plugin/out_gelf.rb
    $ sudo mv out_gelf.rb /etc/td-agent/plugin

We also need to gem-install GELF's Ruby client.

    $ sudo /usr/sbin/td-agent-gem install gelf

Configure `/etc/td-agent/td-agent.conf` as follows.

    <source>
      type syslog
      tag graylog2
    </source>

    <match graylog2.**>
      type gelf
      host 0.0.0.0
      port 12201
      <buffer>
        flush_interval 5s
      </buffer>
    </match>

Open `/etc/rsyslog.conf` and add the following line to the file:

    *.* @127.0.0.1:5140

Finally, restart rsyslog and Fluentd with the following command.

    $ sudo systemctl restart rsyslog
    $ sudo systemctl restart td-agent

## Visualize the data stream

When you log back into Graylog, you should be seeing a graph like this
(wait for events to flow in)

![](/images/graylog2-graph.png)

------------------------------------------------------------------------

If this article is incorrect or outdated, or omits critical information, please [let us know](https://github.com/fluent/fluentd-docs/issues?state=open).
[Fluentd](http://www.fluentd.org/) is a open source project under [Cloud Native Computing Foundation (CNCF)](https://cncf.io/). All components are available under the Apache 2 License.
