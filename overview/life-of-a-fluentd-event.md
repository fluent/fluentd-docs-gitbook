# Life of a Fluentd event

The following article describes a global overview of how events are
processed by [Fluentd](http://fluentd.org) using examples. It covers the
complete cycle including *Setup*, *Inputs*, *Filters*, *Matches* and
*Labels*.


## Basic Setup

The configuration file is the fundamental piece to connect all things
together, as it allows to define which *Inputs* or listeners
[Fluentd](http://fluentd.org) will have and setup common matching rules
to route the *Event* data to a specific *Output*.

We will use the [in\_http](/plugins/input/in_http.md) and the [out\_stdout](/articles/out_stdout.md)
plugins as examples to describe the events cycle. The following is a
basic definition on the configuration file to specify an *http* input,
for short: we will be listening for **HTTP Requests**:

``` {.CodeRay}
<source>
  @type http
  port 8888
  bind 0.0.0.0
</source>
```

The definition specifies that a HTTP server will be listening on TCP
port 8888. Now lets define a *Matching* rule and a desired output that
will just print to the standard output the data that arrived on each
incoming request:

``` {.CodeRay}
<match test.cycle>
  @type stdout
</match>
```

The *Match* sets a rule where each *Incoming* event that arrives with a
**Tag** equals to *test.cycle*, will match and use the *Output* plugin
type called *stdout*. At this point we have an *Input* type, a *Match*
and an *Output*. Let's test the setup using *Curl*:

``` {.CodeRay}
$ curl -i -X POST -d 'json={"action":"login","user":2}' http://localhost:8888/test.cycle
HTTP/1.1 200 OK
Content-type: text/plain
Connection: Keep-Alive
Content-length: 0
```

On the [Fluentd](http://fluentd.org) server side the output should look
like this:

``` {.CodeRay}
$ bin/fluentd -c in_http.conf
2015-01-19 12:37:41 -0600 [info]: reading config file path="in_http.conf"
2015-01-19 12:37:41 -0600 [info]: starting fluentd-0.12.3
2015-01-19 12:37:41 -0600 [info]: using configuration file: <ROOT>
  <source>
    @type http
    bind 0.0.0.0
    port 8888
  </source>
  <match test.cycle>
    @type stdout
  </match>
</ROOT>
2015-01-19 12:37:41 -0600 [info]: adding match pattern="test.cycle" type="stdout"
2015-01-19 12:37:41 -0600 [info]: adding source type="http"
2015-01-19 12:39:57 -0600 test.cycle: {"action":"login","user":2}
```


## Event structure

Fluentd event consists of tag, time and record.

-   tag: Where an event comes from. For message routing
-   time: When an event happens. Epoch time
-   record: Actual log content. JSON object

The input plugin has responsibility for generating Fluentd event from
data sources.\
For example, in\_tail generates events from text lines. If you have
following line in apache logs:

``` {.CodeRay}
192.168.0.1 - - [28/Feb/2013:12:00:00 +0900] "GET / HTTP/1.1" 200 777
```

you got following event:

``` {.CodeRay}
tag: apache.access # set by configuration
time: 1362020400   # 28/Feb/2013:12:00:00 +0900
record: {"user":"-","method":"GET","code":200,"size":777,"host":"192.168.0.1","path":"/"}
```


## Processing Events

When a *Setup* is defined, the *Router Engine* already contains several
rules to apply for different input data. Internally an *Event* will to
pass through a chain of procedures that may alter it cycle.

Now we will expand our previous basic example and we will add more steps
in our *Setup* to demonstrate how the *Events* cycle can be altered. We
will do this through the new *Filters* implementation.


### Filters

A *Filter* aims to behave like a rule to pass or reject an event. The
following configuration adds a *Filter* definition:

``` {.CodeRay}
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

As you can see, the new *Filter* definition added will be a mandatory
step before to pass the control to the *Match* section. The *Filter*
basically will accept or reject the *Event* based on its *type* and rule
defined. For our example we want to discard any user *logout* action, we
will care just about the *logins*. The way to accomplish this, is doing
a *grep* inside the *Filter* that states that will exclude any message
on which *action* key have the *logout* string.

From a *Terminal*, run the following two *Curl* commands, please note
that each one contains a different *action* value:

``` {.CodeRay}
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

Now looking at the [Fluentd](http://fluentd.org) service output we can
realize that just the one with the *action* equals to *login* just
matched. The *logout* *Event* was discarded:

``` {.CodeRay}
$ bin/fluentd -c in_http.conf
2015-01-19 12:37:41 -0600 [info]: reading config file path="in_http.conf"
2015-01-19 12:37:41 -0600 [info]: starting fluentd-0.12.4
2015-01-19 12:37:41 -0600 [info]: using configuration file: <ROOT>
<source>
  @type http
  bind 0.0.0.0
  port 8888
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
</ROOT>
2015-01-19 12:37:41 -0600 [info]: adding filter pattern="test.cycle" type="grep"
2015-01-19 12:37:41 -0600 [info]: adding match pattern="test.cycle" type="stdout"
2015-01-19 12:37:41 -0600 [info]: adding source type="http"
2015-01-27 01:27:11 -0600 test.cycle: {"action":"login","user":2}
```

As you can see, the *Events* follow a *step by step cycle* where they
are processed in order from top to bottom. The new engine on
[Fluentd](http://fluentd.org) allows to integrate many *Filters* as
necessary, also considering that the configuration file will grow and
start getting a bit complex for the readers, a new feature called
*Labels* have been added that aims to solve this possible problem.


### Labels

This new implementation called *Labels*, aims to solve the configuration
file complexity and allows to define new *Routing* sections that do not
follow the *top to bottom* order, instead it acts like linked
references. Talking the previous example, we will modify the setup as
follows:

``` {.CodeRay}
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

The new configuration contains a *\@label* key on the *source*
indicating that any further steps takes place on the *STAGING* *Label*
section. The expectation is that every *Event* reported on the *Source*,
the *Routing* engine will continue processing on *STAGING*, for hence it
will skip the old filter definition.


### Buffers

In this example, we use `stdout` non-buffered output. But in production,
you use outputs in buffered mode, e.g. `forward`, `mongodb`, `s3` and
etc. Output plugin in buffered mode stores received events into buffers
first and write out buffers to a destination by meeting flush
conditions. So using buffered output, you don't see received events
immediately unlike `stdout` non-buffered output.

Buffer is important for reliability and throughput. See
[Output](/articles/output-plugin-overview.md) and [Buffer](/articles/buffer-plugin-overview.md)
articles.


## Conclusion

Once the events are reported by the [Fluentd](http://fluend.org) engine
on the *Source*, can be processed *step by step* or inside a referenced
*Label*, as well any *Event* may be filtered out at any moment. The new
*Routing* engine behavior aims to provide more flexibility and makes
easier the processing before reaching the *Output* plugin.


## Learn More

-   [Fluentd v0.12 Blog Announcement](http://www.fluentd.org/blog/fluentd-v0.12-is-released)
-   [Fluentd v0.14 Blog Announcement](http://www.fluentd.org/blog/fluentd-v0.14.0-has-been-released)
-   [Fluentd v1.0 Blog Announcement](http://www.fluentd.org/blog/fluentd-v1.0)


------------------------------------------------------------------------

If this article is incorrect or outdated, or omits critical information, please [let us know](https://github.com/fluent/fluentd-docs/issues?state=open).
[Fluentd](http://www.fluentd.org/) is a open source project under [Cloud Native Computing Foundation (CNCF)](https://cncf.io/). All components are available under the Apache 2 License.
