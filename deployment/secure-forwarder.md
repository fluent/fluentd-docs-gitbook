# Secure Forwarding

## Overview

This is a quick tutorial on how to use the [secure forward plugin](https://github.com/fluent/fluentd-docs-gitbook/tree/507e377b7e8e78a312dc49e76bd9a302c33fd058/github.com/tagomoris/fluent-plugin-secure-forward/README.md) to **enable SSL for Fluentd-to-Fluentd data transport**.

It is intended as a quick introduction. For comprehensive documentation, including parameter definitions, please checkout out the [out\_secure\_forward]() and [in\_secure\_forward]().

## Setup: Receiver

First, install the secure forward plugin.

* Fluentd: `gem install fluent-plugin-secure-forward`
* td-agent v2:

  `/usr/sbin/td-agent-gem install fluent-plugin-secure-forward`

* td-agent v1:

  `/usr/lib/fluent/ruby/bin/fluent-gem install fluent-plugin-secure-forward`

Then, set up the configuration file as follows:

```text
<source>
  @type secure_forward
  shared_key YOUR_SHARED_KEY
  self_hostname server.fqdn.local
  cert_auto_generate yes
</source>

<match secure.**>
  @type stdout
</match>
```

The `<match>` clause is there to print out the forwarded message into STDOUT \(which is fed into `var/log/td-agent/td-agent.log` for td-agent\) using [out\_stdout]().

Then, \(re\)start Fluentd/td-agent.

## Setup: Sender

First, install the secure forward plugin.

* Fluentd: `fluent-gem install fluent-plugin-secure-forward`
* td-agent v2:

  `/usr/sbin/td-agent-gem install fluent-plugin-secure-forward`

* td-agent v1:

  `/usr/lib/fluent/ruby/bin/fluent-gem install fluent-plugin-secure-forward`

Then, set up the configuration file as follows:

```text
<source>
  @type forward
</source>

<match secure.**>
  @type secure_forward
  shared_key YOUR_SHARED_KEY
  self_hostname "#{Socket.gethostname}"
  <server>
    host RECEIVER_IP
    port 24284
  </server>
</match>
```

The `<source>` clause is there to feed test data into Fluentd using [in\_forward](). Make sure that `YOUR_SHARED_KEY` is same with the receiver's.

Then, \(re\)start td-agent.

## Confirm: Send an Event Over SSL

On the sender machine, run the following command using `fluent-cat`

* Fluentd:

  `echo '{"message":"testing the SSL forwarding"}' | fluent-cat --json secure.test`

* td-agent v2:

  `echo '{"message":"testing the SSL forwarding"}' | /opt/td-agent/embedded/bin/fluent-cat --json secure.test`

* td-agent v1:

  `echo '{"message":"testing the SSL forwarding"}' | /usr/lib/fluent/ruby/bin/fluent-cat --json secure.test`

Now, checking the receiver's Fluentd's log \(for td-agent, this would be `/var/log/td-agent/td-agent.log`\), there should be a line like this:

```text
2014-10-21 18:18:26 -0400 secure.test: {"message":"testing the SSL forwarding"}
```

## Resources

* [in\_secure\_forward]()
* [out\_secure\_forward]()
* [the secure forward plugin's GitHub repo](https://github.com/fluent/fluentd-docs-gitbook/tree/507e377b7e8e78a312dc49e76bd9a302c33fd058/github.com/fluent/fluent-plugin-secure-forward/README.md)

If this article is incorrect or outdated, or omits critical information, please [let us know](https://github.com/fluent/fluentd-docs-gitbook/issues?state=open). [Fluentd](http://www.fluentd.org/) is a open source project under [Cloud Native Computing Foundation \(CNCF\)](https://cncf.io/). All components are available under the Apache 2 License.

