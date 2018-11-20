# Troubleshooting Fluentd


## Look at Logs

If things aren't happening as expected, please first look at your logs.
For td-agent (rpm/deb), the logs are located at
`/var/log/td-agent/td-agent.log`.

## Turn on Verbose Logging

You can get more information about the logs if verbose logging is turned
on. Please follow the steps below.

### rpm/deb

1.  Open the service setting file for td-agent (see below for its file
    path).
2.  Add `-vv` to TD\_AGENT\_OPTIONS.
3.  Restart td-agent.

    ``` {.CodeRay}
    # Add the following settings to:
    # - /etc/sysconfig/td-agent (CentOS/RedHat)
    # - /etc/default/td-agent (Debian/Ubuntu)
    TD_AGENT_OPTIONS="-vv"
    ```

Note: The environment variable TD\_AGENT\_OPTIONS has been introduced in
td-agent v2.2.1. If you are using an older version of td-agent, you need
to edit `/etc/init.d/td-agent` and insert `-vv` options to
TD\_AGENT\_ARGS or DAEMON\_ARGS manually.

### gem

Please add `-vv` to your command line.

``` {.CodeRay}
$ fluentd .. -vv
```

## Dump fluentd internal information

Fluentd uses [sigdump](https://github.com/frsyuki/sigdump) for dumping
fluentd internal information to local file, e.g. thread dump, object
allocation and etc. If you have a problem with fluentd like process
hang, please send `SIGCONT` to fluentd parent and child processes.

## High CPU usage issue

If fluentd suddenly hits unexpected high CPU usage problem, there are
several reasons:

-   a plugin has a race condition or similar bug
-   dependent gems have a bug
-   regular expression with broken data
-   system calls has a bug, e.g. `inotify` with lots of files

In such cases, you can use `perf` tool on recent Linux to investigate
the problem. See [Linux perf Examples](http://www.brendangregg.com/perf.html) page.\
If you want to know which call causes the problem,
[pid2line.rb](https://gist.github.com/nurse/0619b6af90df140508c2) is
useful.

## Check uncaught logs

You sometimes hit unexpected shutdown with non-zero exit status like
below.

``` {.CodeRay}
2016-01-01 00:00:00 +0800 [info]: starting fluentd-0.12.28
2016-01-01 00:00:00 +0800 [info]: reading config file path="/etc/td-agent/td-agent.conf"
[...snip...]
2016-01-01 00:00:02 +0800 [info]: process finished code=6
```

If the problem happens inside ruby, e.g. segmentation fault, C extension
bug, etc, you can't get entire log when fluentd process is daemonized.
For example, td-agent launches fluentd with `--daemon` option. In
td-agent case, you can get entire log using following command to
simulate `/etc/init.d/td-agent start` without daemonize.

``` {.CodeRay}
$ sudo LD_PRELOAD=/opt/td-agent/embedded/lib/libjemalloc.so /usr/sbin/td-agent -c /etc/td-agent/td-agent.conf --user td-agent --group td-agent
```


------------------------------------------------------------------------

If this article is incorrect or outdated, or omits critical information,
please [let us know](https://github.com/fluent/fluentd-docs/issues?state=open).
[Fluentd](http://www.fluentd.org/) is a open source project under [Cloud Native Computing Foundation (CNCF)](https://cncf.io/). All components
are available under the Apache 2 License.
