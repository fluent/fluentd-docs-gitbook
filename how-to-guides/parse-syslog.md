# How to Parse Syslog Messages

Syslog is a popular protocol that virtually runs on every server. It is used to collect all kinds of logs. The problem with `syslog` is that services have a wide range of log formats, and no single parser can parse all `syslog` messages effectively.

In this tutorial, we will show how to use Fluentd to filter and parse different `syslog` messages robustly.

## Prerequisites

* A basic understanding of Fluentd
* A running instance of `rsyslogd`

In this guide, we assume you are running [`td-agent`](https://www.fluentd.org/download) on Ubuntu.

## Setting Up `rsyslogd`

Open `/etc/rsyslogd.conf` and append the following line:

```text
*.* @127.0.0.1:5140
```

Then restart the `rsyslogd` service:

```text
$ sudo systemctl restart syslog
```

This tells `rsyslogd` to forward logs to port 5140 to which Fluentd will listen.

## Setting up Fluentd

In this section, we will evolve our Fluentd configuration step-by-step.

### Step 1: Listening to `syslog` Messages

First, let's configure Fluentd to listen to syslog messages.

Open `/etc/td-agent/td-agent.conf` and put the following configuration:

```text
<source>
  @type syslog
  port 5140
  tag system
</source>

<match system.**>
  @type stdout
</match>
```

This is the most basic setup: it listens to all syslog messages and outputs them to the standard output.

Now please restart `td-agent`:

```text
$ sudo systemctl restart td-agent
```

Let's confirm data is coming in:

```text
$ less /var/log/td-agent/td-agent.log
```

### Step 2: Extract `syslog` Messages from `sudo`

Now, let's look at a `sudo` message like this one:

```text
2018-09-27 16:00:01.000000000 +0900 system.authpriv.info: {"host":"localhost",
"ident":"sudo","message":"pam_unix(sudo:session): session opened for user root
by admin(uid=0)"}
```

For security reasons, it is worth knowing which user performed what using `sudo`. In order to do so, we need to parse the message field. In other words, we need to extract `syslog` messages from `sudo` and handle them differently.

For this purpose, we can use the [`grep`](../filter/grep.md) filter plugin. It examines the fields of events, and filter them based on regular expression patterns. In the following example, Fluentd filters out events that come from `sudo` and contain command data:

```text
<source>
  @type syslog
  port 42185
  tag system
</source>

<filter system.**>
  @type grep
  <regexp>
    key ident
    pattern /^sudo$/
  </regexp>
  <regexp>
    key message
    pattern /COMMAND/
  </regexp>
</filter>

<match system.**>
  @type stdout
</match>
```

### Step 3: Extract Information from Messages

Now let's extract some information from `syslog` messages. For this purpose, we use another plugin called [`filter-parser`](../filter/parser.md). With this plugin, you can parse the content of a field using a regular expression.

Here is the final configuration:

```text
<source>
  @type syslog
  port 5140
  tag system
</source>

<filter system.**>
  @type grep
  <regexp>
    key ident
    pattern /^sudo$/
  </regexp>
  <regexp>
    key message
    pattern /COMMAND/
  </regexp>
</filter>

<filter system.**>
  @type parser
  key_name message
  <parse>
    @type regexp
    expression /USER=(?<sudoer>[^ ]+) ; COMMAND=(?<command>.*)$/
  </parse>
</filter>

<match system.**>
  @type stdout
</match>
```

Then restart `td-agent`:

```text
$ sudo systemctl restart td-agent
```

Let's execute some comment with `sudo`:

```text
$ sudo cat /var/log/auth.log
```

Now, you should have a line like this in `/var/log/td-agent/td-agent.log`:

```text
2018-09-27 16:00:01.000000000 +0900 system.authpriv.notice: {"sudoer":"root","command":"/bin/cat"}
```

There it is, as you can see in the line!

## Conclusion

Fluentd makes it easy to ingest `syslog` events. You can immediately send data to the output systems like MongoDB and Elasticsearch, but also you can do filtering and further parsing _inside Fluentd_ before passing the processed data onto the output destinations.

If this article is incorrect or outdated, or omits critical information, please [let us know](https://github.com/fluent/fluentd-docs-gitbook/issues?state=open). [Fluentd](http://www.fluentd.org/) is an open-source project under [Cloud Native Computing Foundation \(CNCF\)](https://cncf.io/). All components are available under the Apache 2 License.

