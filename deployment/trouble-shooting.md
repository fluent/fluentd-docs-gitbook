# Troubleshooting Fluentd


## Look at Logs

If things are not happening as expected, please first look at your logs. For
`td-agent` (rpm/deb), the logs are located at `/var/log/td-agent/td-agent.log`.


## Turn on Verbose Logging

You can get more information about the logs if verbose logging is turned
on. Please follow the steps below:

### Use Directive in Configuration File

Set `log_level trace`.

See the [logging](/deployment/logging.md/#by-config-file) article also.


### `td-agent` systemd with User's Unit File

Put your unit file into `/etc/systemd/system/td-agent`. This overwrites the
existing behavior of `/usr/lib/systemd/system/td-agent`.

```
[Service]
ExecStart=...existing options... -vv
```


### `td-agent` init.d with Environment Variable

1.  edit `/etc/init.d/td-agent`
2.  add `-vv` to TD\_AGENT\_OPTIONS
3.  restart td-agent

    ```
    # at /etc/init.d/td-agent
    ...
    TD_AGENT_OPTIONS="... -vv"
    ...
    ```

This approach does not work on `systemd` environment because `systemd` hooks
`init.d`'s start routine and ignore other options.


### gem

Please add `-vv` to your command line:

```
$ fluentd .. -vv
```


## Dump fluentd's Internal Information

Fluentd uses [SIGDUMP](https://github.com/frsyuki/sigdump) for dumping
fluentd internal information to local file, e.g. thread dump, object
allocation, etc. If you have a problem with fluentd like process
hang, please send `SIGCONT` to fluentd parent and child processes.


## High CPU Usage Issue

If `fluentd` suddenly hits unexpected high CPU usage problem, there are several
reasons:

-   a plugin has a race condition or similar bug
-   dependent gems have a bug
-   regular expression with broken data
-   system calls has a bug, e.g. `inotify` with lots of files

In such cases, you can use `perf` tool on recent Linux to investigate the
problem. See [Linux perf Examples](http://www.brendangregg.com/perf.html) page.
If you want to know which call causes the problem,
[`pid2line.rb`](https://gist.github.com/nurse/0619b6af90df140508c2) is useful.


## Check Uncaught Logs

You sometimes hit unexpected shutdown with non-zero exit status like this:

```
2016-01-01 00:00:00 +0800 [info]: starting fluentd-0.12.28
2016-01-01 00:00:00 +0800 [info]: reading config file path="/etc/td-agent/td-agent.conf"
[...snip...]
2016-01-01 00:00:02 +0800 [info]: process finished code=6
```

If the problem happens inside Ruby e.g. segmentation fault, C extension
bug, etc., you cannot get the complete log when fluentd process is daemonized.
For example, `td-agent` launches fluentd with `--daemon` option. In
`td-agent` case, you can get the complete log with following command to
simulate `/etc/init.d/td-agent start` without daemonize:

```
$ sudo LD_PRELOAD=/opt/td-agent/embedded/lib/libjemalloc.so /usr/sbin/td-agent -c /etc/td-agent/td-agent.conf --user td-agent --group td-agent
```


------------------------------------------------------------------------

If this article is incorrect or outdated, or omits critical information, please [let us know](https://github.com/fluent/fluentd-docs-gitbook/issues?state=open).
[Fluentd](http://www.fluentd.org/) is an open-source project under [Cloud Native Computing Foundation (CNCF)](https://cncf.io/). All components are available under the Apache 2 License.
