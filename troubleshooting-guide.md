# Troubleshooting Guide

## Introduction and Getting Started

Fluentd has thousands of plugins and tons of configuration options to read from various different data sources. However, this flexibility can also make it difficult to troubleshoot. The following Troubleshooting guide goes over a few steps to follow in case of issues and how to solve them.

If you need additional help we also recommend the following options

**Community Support**

* [Fluent Slack Channel](https://slack.fluentd.org)
* [Fluentd Google Group](https://groups.google.com/g/fluentd)
* [Fluentd GitHub](https://github.com/fluent/fluentd)

**Enterprise Support**

* [Enterprise Providers](https://www.fluentd.org/enterprise_services)

## My logs have stopped sending data to my backend

This is probably one of the most common issues users face with Fluentd and either not seeing data in their configured backend or data has stopped flowing. There are a few possibilities for why Fluentd has stopped sending logs to your backend destination

**Fluentd is waiting for the retry interval**  
In the case that the backend is unreachable \(network failure or application log rejection\) Fluentd automatically engages in a retry process that follows an [exponential backoff sequence](https://docs.fluentd.org/buffer#how-exponential-backoff-works) to avoid causing a denial of service event. As the backoff sequence implies it can grow relatively quickly from a few seconds to a couple of hours. In the log file, you will see `next retry interval at XYZ` which can help you diagnose this issue.

**Suggestions:**

* Add `retry_max_interval` to the output plugin configuration section to cap the max amount of time to wait until attempting a retry
* If you are using the RPC endpoint you can call flush buffers manually \([https://docs.fluentd.org/deployment/rpc](https://docs.fluentd.org/deployment/rpc)\)
* Restarting the Daemon can immediately restart the interval NOTE: if you are using memory buffers vs. on-disk buffers this could result in data loss

**Fluentd cannot reach your backend**  
In some cases, the network environment can suddenly change not allowing Fluentd to connect with a previously accessible point

**Suggestions:**

* Try running Fluentd manually via command line with manual input to ensure that you can reach the end destination

**Datasource is no longer flowing in or has completed**  
Another possible reason for Fluentd to stop sending data is that there is no longer new data flowing into the input plugin that Fluentd is configured to use. An example of this can be that a log file has been rotated and Fluentd is configured to tail a specific log file

**Suggestions:**

* Check that the input configuration is correct and uses `*` where appropriate.
* If using a network input plugin check that data is flowing or using `fluent-cat` to mimic a message being sent: [further reading](https://docs.fluentd.org/deployment/command-line-option#fluent-cat)

## **My logs are filled with BufferOverflow Error**

Fluentd output plugins generally contain buffers that are stored in either memory \(default\) or on disk. These buffers are configurable with both how many chunks are allowed as well as the number of chunks to allow to be in the total buffer. When the buffer is full then the plugin will automatically return BufferOverflowError which in the case of continuously writing data \(E.g. Syslog, Network logs\) will pop up in the Fluentd log file. [Further Reading on Buffer Docs](https://docs.fluentd.org/configuration/buffer-section), and [Further Reading on Buffering / Retrying parameters](https://docs.fluentd.org/output#buffering-retrying-parameters)

**Suggestions:**

* Check that `flush_interval` is low enough that you are continuously flushing the buffer as you are reading data. For example if you are reading 10,000 events / second make sure you are not flushing data every hour otherwise your buffer can quickly fill up
* Increase `workers` and `flush_thread_count`. if you have excessive messages per second and Fluentd is failing to keep adjusting these two settings will increase Fluentd's resource utilization but hopefully allow the application to keep up with the required throughput
* Change buffer type from memory to file. If you are running into this problem you might have exceeded the default total memory buffer size of 512MB. Fluentd uses a small default to prevent excessive memory usage, however can be configured to use filesystem for lower resource usage \(memory\) and more resiliency through restarts. The default sizes for `total_limit_size` file buffers are also much larger \(64GB file vs. 512 MB memory\)
* Additionally, you can manually Increase buffer sizing by increasing the following parameter: `total_limit_size` as well as changing the maximum size of chunks `chunk_limit_size`.

## I'm missing data in my backend destination

Missing data in your backend destination can also be a wildcard error that needs to be checked in multiple places. These can include the configuration of your input / filter / output plugins, the buffering system, and if you are potentially awaiting a retry. Here are a few suggestions you can run through

**Suggestions:**

* Check that configuration is set correctly. For example, if you are reading from a file and you do not see records from the beginning of the file check if `read_from_head` is true
* Check your log file for BufferOverflowError. You may be sending data at high throughput and data might be dropped due to a number of issues. Follow troubleshooting steps in BufferOverflowError section
* Check existing buffers that have not flushed yet. If you are using a file buffer check if there is data that is present in `buffer_path` and has not been flushed

## My logs are being parsed incorrectly

One of Fluentd's big strengths is it's ability to parse logs into a standardized format based on custom formats or well-known formats. However writing regular expressions can be hard to validate and ensure that the proper fields are working. Here are a few tips I recommend

**Suggestions:**

* Use online tools such as [Rubular.com](https://rubular.com) and [fluentular](https://fluentular.com) with a sample of the log file as well as the regex. This will give you a clear example of what the end match groups will look like as well as allow you to validate Ruby timeformat.
* Check existing parsers for well-known formats you may be able to use one of the parsers that Fluentd already includes [https://docs.fluentd.org/parser](https://docs.fluentd.org/parser). Note: you can also checkout [Fluent Bit parsers](https://github.com/fluent/fluent-bit/blob/master/conf/parsers.conf) for additional examples as both projects use Ruby regular expressions
* Check multi-line logs have proper configuration settings. Multi-line logs need to have specific settings set in the parser to work properly, make sure these are all set.



