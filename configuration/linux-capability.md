# Linux capability

This article shows configuration and dependent gem installation instruction for enabling Linux capability module on Fluentd core.

## Prerequisites

* gcc and make etc. for building C extension sources
* libcap-ng package and its depelopment package
  * libcap-ng-dev on Debian GNU/Linux and Ubuntu
  * libcap-ng-devel on CentOS 7/8, Fedora 33, AmazonLinux 2
* pkg-config package for linking libcap-ng library
* Ruby and its development packages
  * ruby-dev on Debian GNU/Linux and Ubuntu
  * ruby-devel on CentOS 7/8, Fedora 33, AmazonLinux 2
* `setcap` command
  * libcap2-bin on Debian GNU/Linux and Ubuntu
  * libcap on CentOS 7/8, Fedora 33, AmazonLinux 2
* `filecap` command
  * libcap-ng-utils on Debian GNU/Linux and Ubuntu
  * libcap-ng-utils on CentOS 7/8, Fedora 33, AmazonLinux 2
* Fluentd v1.12 or later

## Install capability handling gem

Fluentd uses [`capng_c` gem](https://github.com/fluent-plugins-nursery/capng_c) to handle Linux capability.

So, Add this line to your Fluentd' or td-agent's Gemfile:

```ruby
gem 'capng_c'
```

And then execute:

    $ bundle

Or install it yourself as for Fluentd:

    $ fluent-gem install capng_c

Or install it yourself as for td-agent:

    $ td-agent-gem install capng_c

**Note:** capng_c uses `pkg-config` to link libcap-ng library. If you couldn't handle Linux capability with capng_c installation, please confirm `pgk-config` package is installed on your box.

## Capability handling on in_tail

Currently, `in_tail` which is the one of the Fluentd core plugin handles the following Linux capabilities:

* `CAP_DAC_READ_SEARCH` (`:dac_read_search` on `in_tail` code.)
* `CAP_DAC_OVERRIDE` (`:dac_override` on `in_tail` code.)

Set up `cap_dac_read_search` or `cap_dac_override` to using Ruby executable:

### Using CAP_DAC_READ_SEARCH

```console
$ sudo setcap cap_dac_read_search=+eip /path/to/bin/ruby
```

### Using CAP_DAC_OVERRIDE

```console
$ sudo setcap cap_dac_override=+eip /path/to/bin/ruby
```

**Note:** Under rbenv environment, `which ruby` returns shell script wrapper. If users want to set capability on rbenv-ed Ruby, please use the following command:

```console
$ sudo setcap YOUR_USING_CAPABILITY=+eip $(rbenv prefix)/bin/ruby
```

#### Example setting up capability for rbenv-ed Ruby

```console
$ sudo setcap cap_dac_override,cap_dac_read_search=+eip $(rbenv prefix)/bin/ruby
$ filecap $(rbenv prefix)/bin/ruby
file                 capabilities
/home/fluentd/.rbenv/versions/2.6.3/bin/ruby     dac_override, dac_read_search
```

### Actual Example for Linux capability handling in in_tail

When adding `cap_dac_override` (partial privileges for rw file) and `cap_dac_read_search` (partial privileges for read only), Fluentd/td-agent can handle to read 640 permission files such as `/var/log/syslog`:

```console
$ ls -lh /var/log/syslog
-rw-r----- 1 syslog adm 29K Nov  5 14:35 /var/log/syslog
```

This file cannot read form ordinal users:

```console
$ cat /var/log/syslog
cat: /var/log/syslog: Permission denied
```

Attach `cap_dac_read_search` for using Ruby executable binary:

```console
$ sudo setcap cap_dac_read_search=+eip /path/to/bin/ruby
$ filecap /path/to/bin/ruby
file                 capabilities
/path/to/bin/ruby     dac_read_search
```

And prepare the following configuration:

```aconf
<source>
  @type tail
  path /var/log/syslog
  pos_file /var/run/fluentd/log/syslog_test_with_capability.pos
  tag test
  rotate_wait 5
  read_from_head true
  refresh_interval 60
  <parse>
    @type syslog
  </parse>
</source>

<match test>
  @type stdout
</match>
```

Make and change ownership directory:

```console
$ sudo mkdir /var/run/fluentd
$ sudo chown `whoami` /var/run/fluentd
```

Then, run as ordinal user with `cap_dac_read_search` capability attached Ruby:

```console
$ bundle exec fluentd -c in_tail_camouflage_permission.conf
2020-11-05 14:47:57 +0900 [info]: parsing config file is succeeded path="example/in_tail.conf"
2020-11-05 14:47:57 +0900 [info]: gem 'fluentd' version '1.12.0'
2020-11-05 14:47:57 +0900 [info]: gem 'fluent-plugin-systemd' version '1.0.2'
2020-11-05 14:47:57 +0900 [info]: using configuration file: <ROOT>
  <source>
    @type tail
    path "/var/log/syslog"
    pos_file "/var/run/fluentd/log/syslog_test_with_capability.pos"
    tag "test"
    rotate_wait 5
    read_from_head true
    refresh_interval 60
    <parse>
      @type "syslog"
      unmatched_lines
    </parse>
  </source>
  <match test>
    @type stdout
  </match>
</ROOT>
2020-11-05 14:47:57 +0900 [info]: starting fluentd-1.12.0 pid=12109 ruby="2.6.3"
2020-11-05 14:47:57 +0900 [info]: spawn command to main:  cmdline=["/home/fluentd/.rbenv/versions/2.6.3/bin/ruby", "-rbundler/setup", "-Eascii-8bit:ascii-8bit", "/home/fluentd/work/fluentd/vendor/bundle/ruby/2.6.0/bin/fluentd", "-c", "example/in_tail.conf", "--under-supervisor"]
2020-11-05 14:47:58 +0900 [info]: adding match pattern="test" type="stdout"
2020-11-05 14:47:58 +0900 [info]: adding source type="tail"
2020-11-05 14:47:58 +0900 [info]: #0 starting fluentd worker pid=12143 ppid=12109 worker=0
2020-11-05 14:47:58 +0900 [info]: #0 following tail of /var/log/syslog
2020-11-05 09:53:11.000000000 +0900 test: {"host":"fluentd-testing","ident":"anacron","pid":"22613","message":"Job `cron.daily' terminated"}
2020-11-05 09:53:11.000000000 +0900 test: {"host":"fluentd-testing","ident":"anacron","pid":"22613","message":"Normal exit (1 job run)"}
2020-11-05 09:55:01.000000000 +0900 test: {"host":"fluentd-testing","ident":"CRON","pid":"24610","message":"(root) CMD (command -v debian-sa1 > /dev/null && debian-sa1 1 1)"}
```

Fluentd which is running on ordinal user does not complain as `Permission denied`.
Users can retrieve root files' contents on non-root process, yay!


------------------------------------------------------------------------

If this article is incorrect or outdated, or omits critical information, please
[let us know](https://github.com/fluent/fluentd-docs-gitbook/issues?state=open).
[Fluentd](http://www.fluentd.org/) is an open-source project under
[Cloud Native Computing Foundation (CNCF)](https://cncf.io/). All components are
available under the Apache 2 License.
