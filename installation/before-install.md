# Before Installation

Before installing Fluentd, make sure that your environment is properly set up to avoid any inconsistencies at a later stage.

Follow these recommendations:

* Set Up NTP
* Increase the Maximum Number of File Descriptors
* Optimize the Network Kernel Parameters

## Set Up NTP

It is highly recommended that you set up an NTP daemon \(e.g. [`chrony`](https://chrony.tuxfamily.org/), `ntpd`, etc.\) on the node to have an accurate current timestamp. This is crucial for all the production-grade logging services.

For Amazon Web Services users, we recommend using the [AWS-hosted NTP server](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/set-time.html).

## Increase the Maximum Number of File Descriptors

Increase the maximum number of file descriptors. You can check the existing configuration using the `ulimit -n` command:

```text
$ ulimit -n
65535
```

If your console shows `1024`, it is insufficient. Please add the following lines to your `/etc/security/limits.conf` file and reboot your machine:

```text
root soft nofile 65536
root hard nofile 65536
* soft nofile 65536
* hard nofile 65536
```

If you are running fluentd under `systemd`, the option `LimitNOFILE=65536` can also be used. And, if you are using the `td-agent` package, this value is set up by default.

## Optimize the Network Kernel Parameters

For high load environments with many Fluentd instances, add the following configuration to your `/etc/sysctl.conf` file:

```text
net.core.somaxconn = 1024
net.core.netdev_max_backlog = 5000
net.core.rmem_max = 16777216
net.core.wmem_max = 16777216
net.ipv4.tcp_wmem = 4096 12582912 16777216
net.ipv4.tcp_rmem = 4096 12582912 16777216
net.ipv4.tcp_max_syn_backlog = 8096
net.ipv4.tcp_slow_start_after_idle = 0
net.ipv4.tcp_tw_reuse = 1
net.ipv4.ip_local_port_range = 10240 65535
# If forward uses port 24224, reserve that port number for use as an ephemeral port.
# If another port, e.g., monitor_agent uses port 24220, add a comma-separated list of port numbers.
# net.ipv4.ip_local_reserved_ports = 24220,24224
net.ipv4.ip_local_reserved_ports = 24224
```

Use `sysctl -p` command or reboot your node for the changes to take effect.

These kernel options were originally taken from the presentation [How Netflix Tunes EC2 Instances for Performance](https://www.slideshare.net/brendangregg/how-netflix-tunes-ec2-instances-for-performance) by [Brendan Gregg](http://www.brendangregg.com/), Senior Performance Architect at AWS re:Invent 2017.

## Use sticky bit symlink/hardlink protection

**NOTE:** CentOS 7 or later, Ubuntu 18.04 \(bionic\) or later, and Debian GNU/Linux 10 \(buster\) or later are supported these parameters.

Fluentd sometimes uses predictable paths for dumping, writing files, and so on. This default settings for the protections are in `/etc/sysctl.d/10-link-restrictions.conf`, or `/usr/lib/sysctl.d/50-default.conf` or elsewhere.

For symlink attack protection, check the following parameters are set to `1`:

```text
fs.protected_hardlinks = 1
fs.protected_symlinks = 1
```

This settings are almost enough for time-of-check to time-of-use (TOCTOU, TOCTTOU or TOC/TOU) which are a class of software bugs.

If you turned off these protections, please turn them on.

Use `sysctl -p` command or reboot your node for the changes to take effect.

If this article is incorrect or outdated, or omits critical information, please [let us know](https://github.com/fluent/fluentd-docs-gitbook/issues?state=open). [Fluentd](http://www.fluentd.org/) is an open-source project under [Cloud Native Computing Foundation \(CNCF\)](https://cncf.io/). All components are available under the Apache 2 License.

