# Stream Analytics with Materialize

Fluentd and Fluent bit are vendor-neutral open-source log and metric collectors that are used throughout enterprises today. The plugins already include analytic backends like Elasticsearch, Splunk, and Datadog today. One of the newest integrations with Fluentd and Fluent Bit is the new streaming database, Materialize. Built on the open-source project, Timely Dataflow, Users can use standard SQL on top of vast amounts of streaming data to build low-latency, continually refreshed views across multiple sources of incoming data. Together these projects allow you to easily collect your data wherever it may be and analyze it in real-time, or push it to downstream business visualization systems like Metabase and others.

### **Advantages of using Fluentd / Fluent Bit**

1. Connect to data sources such as infrastructure, network, application, and system logs
2. Route important data for analysis, and remove unnecessary data
3. Use built-in reliability features to ensure data is collected and routed with error handling and persistent disk storage

### **Advantages of using Materialize**

1. Supports Postgres-formatted ANSI-standard SQL, allowing reuse of existing tools
2. Low-latency, incrementally updated views
3. Join data across multiple streams and datasets

### **How to get started?**

![](https://lh5.googleusercontent.com/4n8paH_K5rkJHtcn9l8PhBpI9c6vyPKJxO19KIwxDs1vsFtonfGfQbypcoDlhEBG3y7JrTooVtmJol9DdQgQfb2vR_mS589c0wQDlgEhfsrGjv4UCWDEDneRmrAj79pXpJqzv-o)

If you’d like to start playing with this, here are step-by-step instructions to get setup in 15 minutes or less:

1. [Install FluentBit](https://docs.fluentbit.io/manual/installation/getting-started-with-fluent-bit) or [Fluentd](https://docs.fluentd.org/installation) and use any of the many input plugins to read from Syslog, Network data, Kubernetes, Docker containers, Application log files, and more 
2. Leverage Fluent Bit or Fluentd’s ability to write to JSON with the following output configurations

<table>
  <thead>
    <tr>
      <th style="text-align:left">Fluent Bit</th>
      <th style="text-align:left">Fluentd</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td style="text-align:left">
        <p>[OUTPUT]</p>
        <p>name file</p>
        <p>path /var/log/fluent</p>
        <p>format plain</p>
        <p>match *</p>
      </td>
      <td style="text-align:left">
        <p>&lt;match pattern&gt;</p>
        <p>@type file</p>
        <p>path /var/log/fluent/myapp</p>
        <p>&lt;/match&gt;
          <br />
        </p>
      </td>
    </tr>
  </tbody>
</table>

* [Install Materialize](https://materialize.com/docs/install/) and create a new JSON file source

```text
CREATE SOURCE file_source FROM FILE ‘/var/log/fluent/file’ FORMAT TEXT;

```

* Start using Materialize on top of all this real-time data

```text
CREATE MATERIALIZED VIEW jsonified_text AS
SELECT text::jsonb AS jsonified FROM file_source;


SELECT jsonified->>metric_name FROM jsonified_text;

?column? 
----------
 2.0
 2.0
 3.0
(3 rows)
```

