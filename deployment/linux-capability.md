# Using Linux Capabilities

This article shows configuration and dependent gem installation instructions for enabling [Linux capabilities](https://man7.org/linux/man-pages/man7/capabilities.7.html) on Fluentd core.

Linux capabilities grant privileges to processes and executables that are otherwise reserved for the root user (UID 0). You can use these in conjunction with Fluentd plugins to enable the underlying Ruby executable read access to input sources.

## Prerequisites

* `gcc` and `make` etc. for building C extension sources
* `libcap-ng package` and its development package
  * `libcap-ng-dev` on Debian GNU/Linux and Ubuntu
  * `libcap-ng-devel` on CentOS 7/8, Fedora 33, AmazonLinux 2
* `pkg-config package` for linking `libcap-ng` library
* Ruby and its development packages
  * `ruby-dev` on Debian GNU/Linux and Ubuntu
  * `ruby-devel` on CentOS 7/8, Fedora 33, AmazonLinux 2
* Fluentd v1.12 or later

## Install capability handling gem

Fluentd uses the [`capng_c` gem](https://github.com/fluent-plugins-nursery/capng_c) to handle Linux capabilities.

Add this line to your Fluentd' or td-agent's Gemfile:

```ruby
gem 'capng_c'
```

And then execute:

```text
$ bundle
```

Or install it yourself as for Fluentd:

```text
$ fluent-gem install capng_c
```

Or install it yourself as for `td-agent`:

```text
$ td-agent-gem install capng_c
```

**Note:** `capng_c` uses `pkg-config` to link the `libcap-ng` library. If you couldn't handle Linux capability with `capng_c` installation, please confirm `pgk-config` package is installed on your box.

## Capability handling on `in_tail`

The Fluentd core plugin `in_tail` handles the following Linux capabilities:

* `CAP_DAC_READ_SEARCH` \(`:dac_read_search` on `in_tail` code\)
* `CAP_DAC_OVERRIDE` \(`:dac_override` on `in_tail` code\)

Set up `cap_dac_read_search` or `cap_dac_override` to use the Ruby executable:

### Using CAP\_DAC\_READ\_SEARCH

```text
$ sudo fluent-cap-ctl --add dac_read_search [-f /path/to/bin/ruby]
Updating dac_read_search done.
Adding dac_read_search done.
```

### Using CAP\_DAC\_OVERRIDE

```text
$ sudo fluent-cap-ctl --add dac_override [-f /path/to/bin/ruby]
Updating dac_override done.
Adding dac_override done.
```

#### Example setting up capability for rbenv-ed Ruby

```text
$ sudo fluent-cap-ctl --add "dac_override,cap_dac_read_search" -f $(rbenv prefix)/bin/ruby
Updating dac_read_search,dac_override done.
Adding dac_read_search,dac_override done.
$ fluent-cap-ctl --get -f $(rbenv prefix)/bin/ruby
Capabilities in '/home/fluentd/.rbenv/versions/2.6.3/bin/ruby',
Effective:   dac_override, dac_read_search
Inheritable: dac_override, dac_read_search
Permitted:   dac_override, dac_read_search
```

### Actual Example for Linux capability handling in in\_tail

When adding `cap_dac_override` \(partial privileges for `rw` file\) and `cap_dac_read_search` \(partial privileges for read only\), Fluentd/td-agent can handle to read 640 permission files such as `/var/log/syslog`:

```text
$ ls -lh /var/log/syslog
-rw-r----- 1 syslog adm 29K Nov  5 14:35 /var/log/syslog
```

This file cannot be read by ordinary users:

```text
$ cat /var/log/syslog
cat: /var/log/syslog: Permission denied
```

Attach `dac_read_search` for using Ruby executable binary:

```text
$ sudo fluent-cap-ctl --add dac_read_search [-f /path/to/bin/ruby]
Updating dac_read_search done.
Adding dac_read_search done.
$ fluent-cap-ctl --get [-f /path/to/bin/ruby]
Capabilities in '/path/to/bin/ruby',
Effective:   dac_read_search
Inheritable: dac_read_search
Permitted:   dac_read_search
```

And prepare the following configuration:

```text
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

```text
$ sudo mkdir /var/run/fluentd
$ sudo chown `whoami` /var/run/fluentd
```

Then, run as an ordinary user with `cap_dac_read_search` capability attached Ruby:

```text
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

Fluentd, which is running by a non-root user, does not complain with `Permission denied`. Users can retrieve root files' contents on a non-root process, yay!

If this article is incorrect or outdated, or omits critical information, please [let us know](https://github.com/fluent/fluentd-docs-gitbook/issues?state=open). [Fluentd](http://www.fluentd.org/) is an open-source project under [Cloud Native Computing Foundation \(CNCF\)](https://cncf.io/). All components are available under the Apache 2 License.

## Capability handling on docker container
If you would like to collect logs from a file as a non-root user, you can use `CAP_DAC_READ_SEARCH` Linux capabilities.
However, `CAP_DAC_READ_SEARCH` now cannot be used on docker container by default.

When using `CAP_DAC_READ_SEARCH` in a Docker container, you need to add the `--cap-add DAC_READ_SEARCH` option to the `docker run` command.
Or, if you are using `docker compose`, you need to add `cap_add` to the service definition.

```yml
    cap_add:
    - DAC_READ_SEARCH
```

Please refer to the Docker documentation for more information:

- [Runtime privilege and Linux capabilities](https://docs.docker.com/engine/containers/run/#runtime-privilege-and-linux-capabilities)
- [cap_add](https://docs.docker.com/reference/compose-file/services/#cap_add)
