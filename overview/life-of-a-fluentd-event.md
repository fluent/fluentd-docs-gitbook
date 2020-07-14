# Lifecycle of a Fluentd Event

This article describes a general overview of how the events are processed by
[Fluentd](http://fluentd.org), with examples. It covers the complete lifecycle
including *Setup*, *Inputs*, *Filters*, *Matches* and *Labels*.


## Basic Setup

The configuration file is the fundamental piece to connect all things together,
as it allows to define which *Inputs* or listeners [Fluentd](http://fluentd.org)
will have and set up common matching rules to route the *Event* data to a
specific *Output*.

We will use [`in_http`](/plugins/input/http.md) and
[`out_stdout`](/plugins/output/stdout.md) plugins as examples to describe the
event lifecycle.

Following is a basic configuration file to specify an `http` input plugin to
listen for **HTTP requests**:

```
<source>
  @type http
  port 8888
  bind 0.0.0.0
</source>
```

The above configuration specifies that an HTTP server will be listening on TCP port
`8888`.

Now, let's define a **matching** rule for the output plugin to print the
incoming requests to the standard output:

```
<match test.cycle>
  @type stdout
</match>
```

The **match** sets a rule that each incoming event with a **tag** value
`test.cycle` will be forwarded to the **output** plugin **stdout**. Now, we have
an **Input**, a **Match** and an **Output** type plugins.

Let's test this setup with `curl` command:

```
$ curl -i -X POST -d 'json={"action":"login","user":2}' http://localhost:8888/test.cycle
HTTP/1.1 200 OK
Content-type: text/plain
Connection: Keep-Alive
Content-length: 0
```

The Fluentd logs should look like this:

```
$ fluentd -c in_http.conf
2019-12-16 18:58:15 +0900 [info]: parsing config file is succeeded path="in_http.conf"
2019-12-16 18:58:15 +0900 [info]: gem 'fluentd' version '1.8.0'
2019-12-16 18:58:15 +0900 [info]: using configuration file: <ROOT>
  <source>
    @type http
    port 8888
    bind "0.0.0.0"
  </source>
  <match test.cycle>
    @type stdout
  </match>
</ROOT>
2019-12-16 18:58:15 +0900 [info]: starting fluentd-1.8.0 pid=44323 ruby="2.4.6"
2019-12-16 18:58:15 +0900 [info]: spawn command to main:  cmdline=["/path/to/ruby", "-Eascii-8bit:ascii-8bit", "/path/to/fluentd", "-c", "in_http.conf", "--under-supervisor"]
2019-12-16 18:58:16 +0900 [info]: adding match pattern="test.cycle" type="stdout"
2019-12-16 18:58:16 +0900 [info]: adding source type="http"
2019-12-16 18:58:16 +0900 [info]: #0 starting fluentd worker pid=44336 ppid=44323 worker=0
2019-12-16 18:58:16 +0900 [info]: #0 fluentd worker is now running worker=0
2019-12-16 18:58:27.888557000 +0900 test.cycle: {"action":"login","user":2}
```


## Event Structure

A Fluentd event consists of three parts:

-   `tag`: Specifies where an event comes from. It is used for message routing.
-   `time`: Specifies when an event happens with nanosecond resolution.
-   `record`: Specifies the actual log content as JSON object.

The input plugin is responsible for generating the Fluentd events from data
sources. For example, `in_tail` generates events from text lines. If you have
the following Apache Web Server (`httpd`) log line:

```
192.168.0.1 - - [28/Feb/2013:12:00:00 +0900] "GET / HTTP/1.1" 200 777
```

Its corresponding fluentd event will look like this:

```
tag: apache.access         # set by configuration
time: 1362020400.000000000 # 28/Feb/2013:12:00:00 +0900
record: {"user":"-","method":"GET","code":200,"size":777,"host":"192.168.0.1","path":"/"}
```


## Processing Events

When a **Setup** is defined, the **Routing Engine** contains several predefined
rules to apply to different input data. Internally, an **Event** will pass
through a chain of procedures that may alter its lifecycle.

Now, we will extend our previous basic example and add more steps in our
**Setup** to demonstrate how the **Events** lifecycle can be altered. We will do
this through the new **Filters** implementation.


### Filters

A **Filter** behaves like a rule to pass or reject an event. The following
configuration adds a **Filter** definition:

```
<source>
  @type http
  port 8888
  bind 0.0.0.0
</source>

<filter test.cycle>
  @type grep
  <exclude>
    key action
    pattern ^logout$
  </exclude>
</filter>

<match test.cycle>
  @type stdout
</match>
```

As you can see, the new `filter` definition will be a mandatory step before
passing the control to the `match` section. Basically, a **Filter** accepts or
rejects an event based on its `type` and the rule. For our example, we want to
discard all the logout actions. We only care about the logins. The way
to accomplish this is doing a `grep` inside the filter to `exclude` the message
where `action` key contains the string `"logout"`.

From terminal, run the following two `curl` commands containing a different
`action` value for each message:

```
$ curl -i -X POST -d 'json={"action":"login","user":2}' http://localhost:8888/test.cycle
HTTP/1.1 200 OK
Content-type: text/plain
Connection: Keep-Alive
Content-length: 0

$ curl -i -X POST -d 'json={"action":"logout","user":2}' http://localhost:8888/test.cycle
HTTP/1.1 200 OK
Content-type: text/plain
Connection: Keep-Alive
Content-length: 0
```

Fluentd logs show only one login message where `action` is `login`. The `logout`
event has been discarded:

```
$ fluentd -c in_http.conf
2019-12-16 19:07:39 +0900 [info]: parsing config file is succeeded path="in_http.conf"
2019-12-16 19:07:39 +0900 [info]: gem 'fluentd' version '1.8.0'
2019-12-16 19:07:39 +0900 [info]: using configuration file: <ROOT>
  <source>
    @type http
    port 8888
    bind "0.0.0.0"
  </source>
  <filter test.cycle>
    @type grep
    <exclude>
      key "action"
      pattern ^logout$
    </exclude>
  </filter>
  <match test.cycle>
    @type stdout
  </match>
</ROOT>
2019-12-16 19:07:39 +0900 [info]: starting fluentd-1.8.0 pid=44435 ruby="2.4.6"
2019-12-16 19:07:39 +0900 [info]: spawn command to main:  cmdline=["/path/to/ruby", "-Eascii-8bit:ascii-8bit", "/path/to/fluentd", "-c", "in_http.conf", "--under-supervisor"]
2019-12-16 19:07:40 +0900 [info]: adding filter pattern="test.cycle" type="grep"
2019-12-16 19:07:40 +0900 [info]: adding match pattern="test.cycle" type="stdout"
2019-12-16 19:07:40 +0900 [info]: adding source type="http"
2019-12-16 19:07:40 +0900 [info]: #0 starting fluentd worker pid=44448 ppid=44435 worker=0
2019-12-16 19:07:40 +0900 [info]: #0 fluentd worker is now running worker = 0
2019-12-16 19:08:06.934660000 +0900 test.cycle: {"action":"login","user":2}
```

As you can see that the events pass through a **step-by-step cycle** where they
are processed in order, from top to bottom. The new engine on Fluentd allows to
integrate as many filters as needed. Also, considering that the configuration
file may grow and start getting a bit complex for the readers, a new feature
called *Labels* has been introduced to solve this potential problem.


### Labels

This new feature called *Labels* tries to reduce the configuration file's
complexity and allows us to define new routing sections that do not necessarily
follow the **top-to-bottom** order, instead it acts like linked references.
Taking the previous example, we will modify the setup like this:

```
<source>
  @type http
  bind 0.0.0.0
  port 8888
  @label @STAGING
</source>

<filter test.cycle>
  @type grep
  <exclude>
    key action
    pattern ^login$
  </exclude>
</filter>

<label @STAGING>
  <filter test.cycle>
    @type grep
    <exclude>
      key action
      pattern ^logout$
    </exclude>
  </filter>

  <match test.cycle>
    @type stdout
  </match>
</label>
```

The new configuration contains a `@label` parameters under `source` indicating
that the further steps will take place on the `@STAGING` label section. The
expectation is that for each event reported on the `source`, the Routing Engine
will continue processing on `@STAGING`. Hence, it will skip the old filter
definition.


### Buffers

In this example, we use `stdout` - the non-buffered output. But in production,
you use outputs in buffered mode, e.g. `forward`, `mongodb`, `s3`, etc. Output
plugin in buffered mode first stores the received events into buffers and then
writes out buffers to a destination after meeting flush conditions. So, using
buffered output, you don't see received events immediately unlike `stdout`
non-buffered output.

Buffer is important for reliability and throughput. See
[Output](/plugins/output/README.md) and [Buffer](/plugins/buffer/README.md)
articles.


## Conclusion

Once the events are reported by the Fluentd engine on the `source`, they are
processed **step-by-step** or inside a referenced **Label**. Any event may be
filtered out at any moment. The new Routing Engine provides more flexibility and
makes the processing easier before reaching the **Output** plugin.


## Learn More

-   [Fluentd v0.12 Blog Announcement](http://www.fluentd.org/blog/fluentd-v0.12-is-released)
-   [Fluentd v0.14 Blog Announcement](http://www.fluentd.org/blog/fluentd-v0.14.0-has-been-released)
-   [Fluentd v1.0 Blog Announcement](http://www.fluentd.org/blog/fluentd-v1.0)


------------------------------------------------------------------------

If this article is incorrect or outdated, or omits critical information, please [let us know](https://github.com/fluent/fluentd-docs-gitbook/issues?state=open).
[Fluentd](http://www.fluentd.org/) is an open-source project under [Cloud Native Computing Foundation (CNCF)](https://cncf.io/). All components are available under the Apache 2 License.
