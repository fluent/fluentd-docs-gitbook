# Monitoring by Prometheus

This article describes how to monitor Fluentd via [Prometheus](https://prometheus.io/).

Since both Prometheus and Fluentd are under [CNCF \(Cloud Native Computing Foundation\)](https://www.cncf.io/), Fluentd project is recommending to use Prometheus by default to monitor Fluentd.

## Installation

Install `fluent-plugin-prometheus` gem:

```text
$ fluent-gem install fluent-plugin-prometheus
```

For `td-agent`, use `td-agent-gem` for installation:

```text
$ sudo td-agent-gem install fluent-plugin-prometheus
```

This [GitHub repository](https://github.com/kzk/fluentd-prometheus-config-example) contains a fully working configuration for this article.

## Example Fluentd Configuration

To expose Fluentd metrics to Prometheus, we need to configure three \(3\) parts:

* Step 1: Counting Incoming Records by Prometheus Filter Plugin
* Step 2: Counting Outgoing Records by Prometheus Output Plugin
* Step 3: Expose Metrics by Prometheus Input Plugin via HTTP

### Step 1: Counting Incoming Records by Prometheus Filter Plugin

Configure the `<filter>` section to count the incoming records per tag:

```text
# source
<source>
  @type forward
  bind 0.0.0.0
  port 24224
</source>

# count the number of incoming records per tag
<filter company.*>
  @type prometheus
  <metric>
    name fluentd_input_status_num_records_total
    type counter
    desc The total number of incoming records
    <labels>
      tag ${tag}
      hostname ${hostname}
    </labels>
  </metric>
</filter>
```

With this configuration, the `prometheus` filter plugin starts adding the internal counter as the record comes in.

### Step 2: Counting Outgoing Records by Prometheus Output Plugin

Configure the `copy` plugin with `prometheus` output plugin to count the outgoing records per tag:

```text
# count the number of outgoing records per tag
<match company.*>
  @type copy

  <store>
    @type forward
    <server>
      name myserver1
      host 192.168.1.3
      port 24224
      weight 60
    </server>
  </store>

  <store>
    @type prometheus
    <metric>
      name fluentd_output_status_num_records_total
      type counter
      desc The total number of outgoing records
      <labels>
        tag ${tag}
        hostname ${hostname}
      </labels>
    </metric>
  </store>

</match>
```

With this configuration, the `prometheus` output plugin starts adding the internal counter as the record goes out.

### Step 3: Expose Metrics by Prometheus Input Plugin via HTTP

Configure `prometheus` input plugin to expose internal counter information via HTTP:

```text
# expose metrics in prometheus format

<source>
  @type prometheus
  bind 0.0.0.0
  port 24231
  metrics_path /metrics
</source>

<source>
  @type prometheus_output_monitor
  interval 10
  <labels>
    hostname ${hostname}
  </labels>
</source>
```

### Check the Configuration

After you have done these three \(3\) changes, restart fluentd:

```text
# For stand-alone Fluentd installations
$ fluentd -c fluentd.conf

# For td-agent users
$ sudo systemctl restart td-agent
```

Let's send some records:

```text
$ echo '{"message":"hello"}' | bundle exec fluent-cat company.test1
$ echo '{"message":"hello"}' | bundle exec fluent-cat company.test1
$ echo '{"message":"hello"}' | bundle exec fluent-cat company.test1
$ echo '{"message":"hello"}' | bundle exec fluent-cat company.test2
```

Access `http://localhost:24231/metrics` to receive the metrics in [Prometheus format](https://prometheus.io/docs/instrumenting/exposition_formats/):

```text
curl http://localhost:24231/metrics
# TYPE fluentd_input_status_num_records_total counter
# HELP fluentd_input_status_num_records_total The total number of incoming records
fluentd_input_status_num_records_total{tag="company.test",host="KZK.local"} 3.0
fluentd_input_status_num_records_total{tag="company.test2",host="KZK.local"} 1.0
# TYPE fluentd_output_status_num_records_total counter
# HELP fluentd_output_status_num_records_total The total number of outgoing records
fluentd_output_status_num_records_total{tag="company.test",host="KZK.local"} 3.0
fluentd_output_status_num_records_total{tag="company.test2",host="KZK.local"} 1.0
# TYPE fluentd_output_status_buffer_queue_length gauge
# HELP fluentd_output_status_buffer_queue_length Current buffer queue length.
fluentd_output_status_buffer_queue_length{hostname="KZK.local",plugin_id="object:3fcbccc6d388",type="forward"} 1.0
....
```

## Example Prometheus Configuration

Prepare the configuration file \(`prometheus.yml`\):

```text
global:
  scrape_interval: 10s # Set the scrape interval to every 10 seconds. Default is every 1 minute.

# A scrape configuration containing exactly one endpoint to scrape:
# Here it's Prometheus itself.
scrape_configs:
  - job_name: 'fluentd'
    static_configs:
      - targets: ['localhost:24231']
```

Launch `prometheus`:

```text
$ ./prometheus --config.file="prometheus.yml"
```

Now, open this URL `http://localhost:9090/` in your browser.

## How to use Prometheus to monitor Fluentd?

### List of Fluentd Nodes

Go to `http://localhost:9090/targets` to see the list of Fluentd nodes and their status.

![Prometheus Targets](../.gitbook/assets/prometheus-targets%20%281%29%20%281%29%20%281%29%20%281%29%20%281%29%20%281%29.png)

### List of Fluentd Metrics

Visit `http://localhost:9090/graph` to explore Fluentd's internal metrics. You'll see eight \(8\) metrics in the metric list:

![Prometheus Metrics](../.gitbook/assets/prometheus-metrics%20%281%29%20%282%29.png)

* `fluentd_input_status_num_records_total`
* `fluentd_output_status_buffer_queue_length`
* `fluentd_output_status_buffer_total_bytes`
* `fluentd_output_status_emit_count`
* `fluentd_output_status_num_errors`
* `fluentd_output_status_num_records_total`
* `fluentd_output_status_retry_count`
* `fluentd_output_status_retry_wait`

Pick `fluentd_input_status_num_records_total` and you'll see the total incoming records per tag.

![Prometheus Graph](../.gitbook/assets/prometheus-graph%20%283%29.png)

### Example Prometheus Queries

Since `fluentd_input_status_num_records_total` and `fluentd_output_status_num_records_total` are monotonically increasing numbers, it requires a little bit of calculation by [PromQL \(Prometheus Query Language\)](https://prometheus.io/docs/prometheus/latest/querying/basics/) to make them meaningful.

Here are the example PromQLs for common metrics:

```text
# number of available nodes
up

# incoming records / sec / host
sum(rate(fluentd_input_status_num_records_total[1m])) by (hostname)

# incoming records / sec / tag
sum(rate(fluentd_input_status_num_records_total[1m])) by (tag)

# outgoing records / sec / host
sum(rate(fluentd_output_status_num_records_total[1m])) by (hostname)

# outgoing records / sec / tag
sum(rate(fluentd_output_status_num_records_total[1m])) by (tag)

# emit count / sec
rate(fluentd_output_status_emit_count[1m])
```

### Metrics to Monitor

In addition to the traffic metrics introduced above, it is important to monitor the queue length and error count.

If these values are increasing, it means Fluentd cannot flush the buffer to the destination. Thus you will lose the data once the buffer becomes full.

```text
# maximum buffer length in last 1min
max_over_time(fluentd_output_status_buffer_queue_length[1m])

# maximum buffer bytes in last 1min
max_over_time(fluentd_output_status_buffer_total_bytes[1m])

# maximum retry wait in last 1min
max_over_time(fluentd_output_status_retry_wait[1m])

# retry count / sec
rate(fluentd_output_status_retry_count[1m])
```

## Grafana for Advanced Visualization / Alerting

For more advanced visualization and alerting, we recommend [Grafana](https://grafana.com/) as a visualization frontend for Prometheus.

* [Grafana Support for Prometheus](https://prometheus.io/docs/visualization/grafana/)

![Prometheus + Grafana](../.gitbook/assets/prometheus-grafana%20%281%29.png)

## Further Readings

* [Prometheus Documentation](https://prometheus.io/docs/introduction/overview/)
* [Grafana Documentation](http://docs.grafana.org/)

If this article is incorrect or outdated, or omits critical information, please [let us know](https://github.com/fluent/fluentd-docs-gitbook/issues?state=open). [Fluentd](http://www.fluentd.org/) is an open-source project under [Cloud Native Computing Foundation \(CNCF\)](https://cncf.io/). All components are available under the Apache 2 License.

