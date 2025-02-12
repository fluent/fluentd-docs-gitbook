# Email Alerting like Splunk

[Splunk](https://www.splunk.com/) is a great tool for searching logs. One of its key features is the ability to `grep` logs and send alert emails when certain conditions are met.

In this little HowTo article, we will show you how to build a similar system using Fluentd. More specifically, we will create a system that sends an alert email when it detects a 5xx HTTP status code in an Apache access log.

If you want a more general introduction to use Fluentd as a free alternative to Splunk, see the article ["Free Alternative to Splunk Using Fluentd"](free-alternative-to-splunk-by-fluentd.md).

## Prerequisites

The following software/services are required to be set up correctly:

* [Fluentd](https://www.fluentd.org/)
* [Grep Counter Output Plugin](https://github.com/fluent-plugins-nursery/fluent-plugin-grepcounter) (fluent-plugin-grepcounter)
* [Mail Output Plugin](https://github.com/u-ichi/fluent-plugin-mail) (fluent-plugin-mail)

You can install Fluentd via major packaging systems.

* [Installation](../installation/)

### Install Grep Counter/Mail Plugin

If `out_grepcounter` (fluent-plugin-grepcounter) and `out_mail` (fluent-plugin-mail) are not installed yet, please install it manually.

See [Plugin Management](..//installation/post-installation-guide#plugin-management) section how to install fluent-plugin-mongo on your environment.

## Configuration

### Full Configuration Example

Here is the full configuration example \(copy and edit as needed\):

```text
<source>
  @type tail
  path /var/log/apache2/access.log  # Set the location of your log file
  <parse>
    @type apache2
  </parse>
  tag apache.access
</source>

<match apache.access>
  @type grepcounter
  count_interval 3  # The time window for counting errors (in secs)
  input_key code    # The field to apply the regular expression
  regexp ^5\d\d$    # The regular expression to be applied
  threshold 1       # The minimum number of errors to trigger an alert
  add_tag_prefix error_5xx  # Generate tags like "error_5xx.apache.access"
</match>

<match error_5xx.apache.access>
  @type copy
  <store>
    @type stdout  # Print to stdout for debugging
  </store>
  <store>
    @type mail
    host smtp.gmail.com        # Change this to your SMTP server host
    port 587                   # Normally 25/587/465 are used for submission
    user USERNAME              # Use your username to log in
    password PASSWORD          # Use your login password
    enable_starttls_auto true  # Use this option to enable STARTTLS
    from example@gmail.com     # Set the sender address
    to alert@example.com       # Set the recipient address
    subject 'HTTP SERVER ERROR'
    message Total 5xx error count: %s\n\nPlease check your Apache webserver ASAP
    message_out_keys count     # Use the "count" field to replace "%s" above
  </store>
</match>
```

Save your settings to `/etc/fluent/fluentd.conf` \(If you installed Fluentd without `fluent-package`, save the content as `alert-email.conf` instead\).

Before proceeding, please confirm:

* The SMTP configuration is correct. You need a working mail server

  and a proper recipient address to run this example.

* The access log file has proper file permission. You need to make

  the file readable to the `fluentd` daemon.

### How this Configuration Works

The configuration above consists of three main parts:

1. The first `<source>` block sets the `httpd` log file as an event source for the daemon.
2. The second `<match>` block tells Fluentd to count the number of 5xx responses per time window \(3 seconds\). If the number exceeds \(or is equal to\) the given threshold, Fluentd will emit an event with the tag `error_5xx.apache.access`.
3. The third `<match>` block accepts events with the tag `error_5xx.apache.access`, and send an email to `alert@example.com` per event.

In this way, fluentd now works as an email alerting system that monitors the web service for you.

## Test the Configuration

After saving the configuration, restart the `fluentd` process:

```text
# for systemd users
$ sudo systemctl restart fluentd
```

If you installed the standalone version of Fluentd, launch the `fluentd` process manually:

```text
$ fluentd -c alert-email.conf
```

Then, generate some 5xx errors in the web server. If you do not have a convenient way to accomplish this, appending 5xx lines to the log file manually will produce the same result.

Now you will receive an alert email titled "HTTP SERVER ERROR".

## What's next?

Admittedly, this is a contrived example. In reality, you would set the threshold higher. Also, you might be interested in tracking 4xx pages as well. In addition to Apache logs, Fluentd can handle Nginx logs, syslogs, or any single- or multi-lined logs.

You can learn more about Fluentd and its plugins by:

* exploring other [plugins](https://fluentd.org/plugin/)
* asking questions on the [GitHub Discussions](https://github.com/fluent/fluentd/discussions)
* [signing up for our newsletters](https://www.fluentd.org/newsletter)

If this article is incorrect or outdated, or omits critical information, please [let us know](https://github.com/fluent/fluentd-docs-gitbook/issues?state=open). [Fluentd](http://www.fluentd.org/) is an open-source project under [Cloud Native Computing Foundation \(CNCF\)](https://cncf.io/). All components are available under the Apache 2 License.

