# Fluentd UI

[fluentd-ui](https://github.com/fluent/fluentd-ui) is a browser-based
[fluentd](http://fluentd.org/) and
[td-agent](http://docs.treasuredata.com/articles/td-agent) manager that
supports the following operations:

-   Install, uninstall, and upgrade Fluentd plugins
-   Start/stop/restart fluentd process
-   Configure Fluentd settings such as config file, pid file path, etc.
-   View Fluentd log with simple error viewer

`fluentd-ui` does not work with `fluentd` v1 and `td-agent` 3 does not include
it. This content is for v0.12 for now.


## Getting Started

For `td-agent`, you can start it by `td-agent-ui start` like this:

```
$ sudo /usr/sbin/td-agent-ui start
Puma 2.9.2 starting...
* Min threads: 0, max threads: 16
* Environment: production
* Listening on tcp://0.0.0.0:9292
```

For `fluentd` gem installation, install `fluentd-ui` via `gem` command:

```
$ gem install -V fluentd-ui
$ fluentd-ui start
Puma 2.9.2 starting...
* Min threads: 0, max threads: 16
* Environment: production
* Listening on tcp://0.0.0.0:9292
```

Then, open http://localhost:9292/ in your browser.

The default account credentials are:

-   `username="admin"`
-   `password="changeme"`

![fluentd-ui.gif](/images/fluentd-ui/fluentd-ui.gif)


## Screenshots

(v0.3.9)


### Dashboard

![dashboard.gif](/images/fluentd-ui/dashboard.gif)


### Setting

![setting.git](/images/fluentd-ui/setting.gif)


### `in_tail` setting

![`in_tail`.gif](/images/fluentd-ui/in_tail.gif)


### Plugin

![plugin.gif](/images/fluentd-ui/plugin.gif)

![ss01](/images/fluentd-ui/01.png) ![ss02](/images/fluentd-ui/02.png)
![ss03](/images/fluentd-ui/03.png) ![ss04](/images/fluentd-ui/04.png)
![ss05](/images/fluentd-ui/05.png)


------------------------------------------------------------------------

If this article is incorrect or outdated, or omits critical information, please [let us know](https://github.com/fluent/fluentd-docs-gitbook/issues?state=open).
[Fluentd](http://www.fluentd.org/) is an open-source project under [Cloud Native Computing Foundation (CNCF)](https://cncf.io/). All components are available under the Apache 2 License.
