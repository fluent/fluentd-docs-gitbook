::: {#main .section}
::: {#page}
::: {.topic_content}
::: {style="text-align:right"}
::: {style="text-align:right"}
Versions \| [v1.0 (td-agent3)](/v1.0/articles/fluentd-ui) \| ***v0.12*
(td-agent2) **
:::
:::

------------------------------------------------------------------------

Fluentd UI
==========

[fluentd-ui](https://github.com/fluent/fluentd-ui) is a browser-based
[fluentd](http://fluentd.org/) and
[td-agent](http://docs.treasuredata.com/articles/td-agent) manager that
supports following operations.

-   Install, uninstall, and upgrade Fluentd plugins
-   start/stop/restart fluentd process
-   Configure Fluentd settings such as config file content, pid file
    path, etc
-   View Fluentd log with simple error viewer

[]{#getting-started}

::: {#table-of-contents .section}
### Table of Contents

[Getting Started](#getting-started)

[Screenshots](#screenshots)

-   [Dashboard](#dashboard)
-   [Setting](#setting)
-   [in\_tail setting](#in_tail-setting)
-   [Plugin](#plugin)
:::

Getting Started
---------------

If you've installed td-agent, you can start it by `td-agent-ui start` as
below:

``` {.CodeRay}
$ sudo /usr/sbin/td-agent-ui start
Puma 2.9.2 starting...
* Min threads: 0, max threads: 16
* Environment: production
* Listening on tcp://0.0.0.0:9292
```

Or if you use fluentd gem, install fluentd-ui via `gem` command at
first.

``` {.CodeRay}
$ gem install -V fluentd-ui
$ fluentd-ui start
Puma 2.9.2 starting...
* Min threads: 0, max threads: 16
* Environment: production
* Listening on tcp://0.0.0.0:9292
```

Then, open <http://localhost:9292/> by your browser.

The default account is username="admin" and password="changeme"

![fluentd-ui](/images/fluentd-ui/fluentd-ui.gif)

[]{#screenshots}

Screenshots
-----------

(v0.3.9)

[]{#dashboard}

### Dashboard

![dashboard](/images/fluentd-ui/dashboard.gif)

[]{#setting}

### Setting

![setting](/images/fluentd-ui/setting.gif)

[]{#in_tail-setting}

### in\_tail setting

![in\_tail](/images/fluentd-ui/in_tail.gif)

[]{#plugin}

### Plugin

![plugin](/images/fluentd-ui/plugin.gif)

![ss01](/images/fluentd-ui/01.png) ![ss02](/images/fluentd-ui/02.png)
![ss03](/images/fluentd-ui/03.png) ![ss04](/images/fluentd-ui/04.png)
![ss05](/images/fluentd-ui/05.png)

::: {style="text-align:right"}
Last updated: 2015-05-28 06:46:49 UTC
:::

------------------------------------------------------------------------

::: {style="text-align:right"}
Versions \| [v1.0 (td-agent3)](/v1.0/articles/fluentd-ui) \| ***v0.12*
(td-agent2) **
:::

------------------------------------------------------------------------

If this article is incorrect or outdated, or omits critical information,
please [let us
know](https://github.com/fluent/fluentd-docs/issues?state=open).
[Fluentd](http://www.fluentd.org/) is a open source project under [Cloud
Native Computing Foundation (CNCF)](https://cncf.io/). All components
are available under the Apache 2 License.
:::
:::
:::
