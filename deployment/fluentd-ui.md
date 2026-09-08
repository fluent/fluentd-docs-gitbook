# Fluentd UI

{% hint style='danger' %}
**`fluentd-ui` is no longer maintained.** The last release, 1.2.1, was published in November 2018. It depends on Rails 5.2 and does not work with current versions of Ruby or Fluentd. It is not included in `fluent-package`. Do not install it on new systems.
{% endhint %}

`fluentd-ui` was a browser-based management interface for Fluentd and `td-agent`. It allowed users to edit the configuration file, install plugins and view logs from a web browser. This page is kept for reference only. If you are still running Fluentd v0.12, the setup instructions remain on [the v0.12 version of this page](https://docs.fluentd.org/0.12/deployment/fluentd-ui).

For monitoring and operating Fluentd today, use the following instead:

* [Monitoring Fluentd](../monitoring-fluentd/overview.md): overview of the monitoring options
* [Monitoring by REST API](../monitoring-fluentd/monitoring-rest-api.md): `in_monitor_agent` exposes internal metrics over HTTP
* [Monitoring by Prometheus](../monitoring-fluentd/monitoring-prometheus.md): metrics for Prometheus and Grafana
* [RPC](rpc.md): HTTP RPC endpoints for reloading the configuration and other operations
* [Plugin Management](plugin-management.md): installing and managing plugins with `fluent-gem`
* [Logging](logging.md): where Fluentd writes its own logs

The source code remains available at [https://github.com/fluent/fluentd-ui](https://github.com/fluent/fluentd-ui).
