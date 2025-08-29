# Install by RPM Package v3 \(Red Hat Linux\)

This article explains how to install the `td-agent` rpm package, the stable Fluentd distribution package maintained by [Treasure Data, Inc](http://www.treasuredata.com/).

## What is `td-agent`?

Fluentd is written in Ruby for flexibility, with performance-sensitive parts in C. However, some users may have difficulty installing and operating a Ruby daemon.

That is why [Treasure Data, Inc](http://www.treasuredata.com/) provides **the stable distribution of Fluentd**, called `td-agent`. The differences between Fluentd and `td-agent` can be found [here](https://www.fluentd.org/faqs).

## Using to install `td-agent`

{% hint style='danger' %}
This article contains deprecated td-agent (EOL) information: SHOULD NOT use td-agent anymore.

* As [Treasure Agent (td-agent) 3 will not be maintained anymore](https://www.fluentd.org/blog/schedule-for-td-agent-3-eol), recommend to [Upgrade td-agent from v3 to v4](https://www.fluentd.org/blog/upgrade-td-agent-v3-to-v4).
* Do not directly upgrade from v3 to fluent-package v5. Such a workflow is not supported. It causes a trouble. Upgrade in stages. (v3 to v4, then v4 to v5)
* Package archive was migrated from [packages.treasuredata.com](https://packages.treasuredata.com) to [fluentd.cdn.cncf.io](https://fluentd.cdn.cncf.io/index.html). Need to migrate `baseurl` in td.repo by yourself or just disable it.
{% endhint %}

### Step 0: Before Installation

Please follow the [Pre-installation Guide](before-install.md) to configure your OS properly.

### Step 1: Install from `rpm` Repository

It is highly recommended to set up `ntpd` on the node to prevent invalid timestamps in the logs. See [Pre-installation Guide](before-install.md).

NOTE: If your OS is not supported, consider [gem installation](install-by-gem.md) instead.

#### Red Hat / CentOS

Download and execute the install script with `curl`:

```text
# td-agent 3 (EOL)
$ curl -L https://toolbelt.treasuredata.com/sh/install-redhat-td-agent3.sh | sh
```

Executing this script will automatically install `td-agent` on your machine. This shell script registers a new `rpm` repository at `/etc/yum.repos.d/td.repo` and installs `td-agent`.

We use `$releasever` for repository path in the script and `$releasever` should be the major version only like `"7"`. If your environment uses some other format like `"7.2"`, change it to the major version only or set up TD repository manually.

#### Amazon Linux

For Amazon Linux 2:

```text
# td-agent 3 (EOL)
$ curl -L https://toolbelt.treasuredata.com/sh/install-amazon2-td-agent3.sh | sh
```

### Step 2: Launch Daemon

`td-agent` provides two \(2\) scripts:

#### `systemd`

Use `/usr/lib/systemd/system/td-agent` script to `start`, `stop`, or `restart` the agent:

```text
$ sudo systemctl start td-agent.service
$ sudo systemctl status td-agent.service
● td-agent.service - td-agent: Fluentd based data collector for Treasure Data
   Loaded: loaded (/usr/lib/systemd/system/td-agent.service; enabled; vendor preset: disabled)
   Active: active (running) since Tue 2022-09-27 06:14:36 UTC; 1s ago
     Docs: https://docs.treasuredata.com/display/public/PD/About+Treasure+Data%27s+Server-Side+Agent
  Process: 33953 ExecStart=/opt/td-agent/bin/fluentd --log $TD_AGENT_LOG_FILE --daemon /var/run/td-agent/td-agent.pid $TD_AGENT_OPTIONS (code=exited, status=0>
 Main PID: 33959 (fluentd)
    Tasks: 10 (limit: 4958)
   Memory: 78.1M
   CGroup: /system.slice/td-agent.service
           ├─33959 /opt/td-agent/bin/ruby /opt/td-agent/bin/fluentd --log /var/log/td-agent/td-agent.log --daemon /var/run/td-agent/td-agent.pid
           └─33962 /opt/td-agent/bin/ruby -Eascii-8bit:ascii-8bit /opt/td-agent/bin/fluentd --log /var/log/td-agent/td-agent.log --daemon /var/run/td-agent/td>
```

To customize `systemd` behavior, put your `td-agent.service` in `/etc/systemd/system`.

NOTE: In `td-agent` 4, the path is different i.e. `/opt/td-agent/bin` instead of `/opt/td-agent/embedded/bin`.

#### `init.d`

This is for CentOS 6, non-`systemd` based system.

Use `/etc/init.d/td-agent` script to `start`, `stop`, or `restart` the agent:

```text
$ sudo /etc/init.d/td-agent start
Starting td-agent: [  OK  ]
$ sudo /etc/init.d/td-agent status
td-agent (pid  21678) is running...
```

The following commands are supported:

```text
$ sudo /etc/init.d/td-agent start
$ sudo /etc/init.d/td-agent stop
$ sudo /etc/init.d/td-agent restart
$ sudo /etc/init.d/td-agent status
```

Please make sure your configuration file path is:

```text
/etc/td-agent/td-agent.conf
```

### Step 3: Post Sample Logs via HTTP

The default configuration \(`/etc/td-agent/td-agent.conf`\) is to receive logs at an HTTP endpoint and route them to `stdout`. For `td-agent` logs, see `/var/log/td-agent/td-agent.log`.

You can post sample log records with `curl` command:

```text
$ curl -X POST -d 'json={"json":"message"}' http://localhost:8888/debug.test
$ tail -n 1 /var/log/td-agent/td-agent.log
2018-01-01 17:51:47 -0700 debug.test: {"json":"message"}
```

## Next Steps

You are now ready to collect real logs with Fluentd. Refer to the following tutorials on how to collect data from various sources:

* Basic Configuration
  * [Config File](../configuration/config-file.md)
* Application Logs
  * [Ruby](../language-bindings/ruby.md), [Java](../language-bindings/java.md), [Python](../language-bindings/python.md), [PHP](../language-bindings/php.md),

    [Perl](../language-bindings/perl.md), [Node.js](../language-bindings/nodejs.md), [Scala](../language-bindings/scala.md)
* Examples
  * [Store Apache Log into Amazon S3](../how-to-guides/apache-to-s3.md)
  * [Store Apache Log into MongoDB](../how-to-guides/apache-to-mongodb.md)
  * [Data Collection into HDFS](../how-to-guides/http-to-hdfs.md)

For further steps, follow these:

* [ChangeLog of td-agent](https://docs.treasuredata.com/display/public/PD/The+td-agent+Change+Log)
* [Chef Cookbook](https://github.com/treasure-data/chef-td-agent/)

If this article is incorrect or outdated, or omits critical information, please [let us know](https://github.com/fluent/fluentd-docs-gitbook/issues?state=open). [Fluentd](http://www.fluentd.org/) is an open-source project under [Cloud Native Computing Foundation \(CNCF\)](https://cncf.io/). All components are available under the Apache 2 License.

