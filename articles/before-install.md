# Before Installing Fluentd

You MUST set up your environment according to the steps below before
installing Fluentd. Failing to do so will be the cause of many
unnecessary problems.


## Set Up NTP

It's HIGHLY recommended that you set up NTP daemon (e.g.
*[chrony](https://chrony.tuxfamily.org/)*, *ntpd*, etc) on the node to
have accurate current timestamp. This is crucial for any
production-grade logging services.

For Amazon Web Services users we recommend using [AWS hosted NTP server](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/set-time.html).


## Increase Max \# of File Descriptors

Please increase the maximum number of file descriptors. You can check
the current number using the `ulimit -n` command.

``` {.CodeRay}
$ ulimit -n
65535
```

If your console shows `1024`, it is insufficient. Please add following
lines to your `/etc/security/limits.conf` file and reboot your machine.

``` {.CodeRay}
root soft nofile 65536
root hard nofile 65536
* soft nofile 65536
* hard nofile 65536
```

If you are running fluentd under systemd, the option `LimitNOFILE=65536`
can also be used (and if you are using the td-agent package this value
is setup by default).


## Optimize Network Kernel Parameters

For high load environments consisting of many Fluentd instances, please
add these parameters to your `/etc/sysctl.conf` file. Please either type
`sysctl -p` or reboot your node to have the changes take effect.

``` {.CodeRay}
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
```

These kernel options were originally taken from the presentation "[How
Netflix Tunes EC2 Instances for
Performance](https://www.slideshare.net/brendangregg/how-netflix-tunes-ec2-instances-for-performance)"
by [Brendan Gregg](http://www.brendangregg.com/), Senior Performance
Architect at AWS re:Invent 2017.


------------------------------------------------------------------------

If this article is incorrect or outdated, or omits critical information,
please [let us know](https://github.com/fluent/fluentd-docs/issues?state=open).
[Fluentd](http://www.fluentd.org/) is a open source project under [Cloud Native Computing Foundation (CNCF)](https://cncf.io/). All components
are available under the Apache 2 License.
