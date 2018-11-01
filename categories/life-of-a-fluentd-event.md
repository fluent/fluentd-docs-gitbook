<hgroup>
<h1>Life of a Fluentd event</h1>
</hgroup>
<p>The following article describe a global overview of how events are processed by <a href="http://fluentd.org">Fluentd</a> using examples. It covers the complete cycle including <em>Setup</em>, <em>Inputs</em>, <em>Filters</em>, <em>Matches</em> and <em>Labels</em>.</p>
<a name="basic-setup"></a>
<section id="table-of-contents"><h3>Table of Contents</h3>
<ul id="toc">
<li class="toc-item"><a href="#basic-setup">Basic Setup</a></li>
<li class="toc-item"><a href="#event-structure">Event structure</a></li>
<li class="toc-item"><a href="#processing-events">Processing Events</a></li>
<ul class="sub-toc">
<li class="sub-toc-item"><a href="#filters">Filters</a></li>
<li class="sub-toc-item"><a href="#labels">Labels</a></li>
<li class="sub-toc-item"><a href="#buffers">Buffers</a></li>
</ul>
<li class="toc-item"><a href="#execution-unit">Execution unit</a></li>
<li class="toc-item"><a href="#conclusion">Conclusion</a></li>
<li class="toc-item"><a href="#learn-more">Learn More</a></li>
</ul>
</section>
<h2>Basic Setup</h2>
<p>The configuration files is the fundamental piece to connect all things together, as it allows to define which <em>Inputs</em> or listeners <a href="http://fluentd.org">Fluentd</a> will have and set up common matching rules to route the <em>Event</em> data to a specific <em>Output</em>.</p>
<p>We will use the <a href="in_http">in_http</a> and the <a href="out_stdout">out_stdout</a> plugins as examples to describe the events cycle. The following is a basic definition on the configuration file to specify an <em>http</em> input, for short: we will be listening for <strong>HTTP Requests</strong>:</p>
<pre class="CodeRay">&lt;source&gt;
  @type http
  port 8888
  bind 0.0.0.0
&lt;/source&gt;
</pre>
<p>This definition specifies that a HTTP server will be listening on TCP port 8888. Now let’s define a <em>Matching</em> rule and a desired output that will just print the data that arrived on each incoming request to standard output:</p>
<pre class="CodeRay">&lt;match test.cycle&gt;
  @type stdout
&lt;/match&gt;
</pre>
<p>The <em>Match</em> directive sets a rule that matches each <em>Incoming</em> event that arrives with a <strong>Tag</strong> equal to <em>test.cycle</em> will use the <em>Output</em> plugin type called <em>stdout</em>. At this point we have an <em>Input</em> type, a <em>Match</em> and an <em>Output</em>. Let’s test the setup using <em>curl</em>:</p>
<pre class="CodeRay">$ curl -i -X POST -d 'json={"action":"login","user":2}' http://localhost:8888/test.cycle
HTTP/1.1 200 OK
Content-type: text/plain
Connection: Keep-Alive
Content-length: 0
</pre>
<p>On the <a href="http://fluentd.org">Fluentd</a> server side the output should look like this:</p>
<pre class="CodeRay">$ bin/fluentd -c in_http.conf
2015-01-19 12:37:41 -0600 [info]: reading config file path="in_http.conf"
2015-01-19 12:37:41 -0600 [info]: starting fluentd-0.12.3
2015-01-19 12:37:41 -0600 [info]: using configuration file: &lt;ROOT&gt;
  &lt;source&gt;
    @type http
    bind 0.0.0.0
    port 8888
  &lt;/source&gt;
  &lt;match test.cycle&gt;
    @type stdout
  &lt;/match&gt;
&lt;/ROOT&gt;
2015-01-19 12:37:41 -0600 [info]: adding match pattern="test.cycle" type="stdout"
2015-01-19 12:37:41 -0600 [info]: adding source type="http"
2015-01-19 12:39:57 -0600 test.cycle: {"action":"login","user":2}
</pre>
<a name="event-structure"></a><h2>Event structure</h2>
<p>A Fluentd event consists of a tag, time and record.</p>
<ul>
<li>tag: Where an event comes from. For message routing</li>
<li>time: When an event happens. Epoch time</li>
<li>record: Actual log content. JSON object</li>
</ul>
<p>The input plugin is responsible for generating Fluentd events from specified data sources.<br/>
For example, <code>in_tail</code> generates events from text lines. If you have the following line in apache logs:</p>
<pre class="CodeRay">192.168.0.1 - - [28/Feb/2013:12:00:00 +0900] "GET / HTTP/1.1" 200 777
</pre>
<p>the following event is generated:</p>
<pre class="CodeRay">tag: apache.access # set by configuration
time: 1362020400   # 28/Feb/2013:12:00:00 +0900
record: {"user":"-","method":"GET","code":200,"size":777,"host":"192.168.0.1","path":"/"}
</pre>
<a name="processing-events"></a><h2>Processing Events</h2>
<p>When a <em>Setup</em> is defined, the <em>Router Engine</em> already contains several rules to apply for different input data. Internally an <em>Event</em> will pass through a chain of procedures that may alter the <em>Events</em> cycle.</p>
<p>Now we will expand the previous basic example and add more steps in our <em>Setup</em> to demonstrate how the <em>Events</em> cycle can be altered. We will do this through the new <em>Filters</em> implementation.</p>
<a name="filters"></a><h3>Filters</h3>
<p>A <em>Filter</em> aims to behave like a rule to either accept or reject an event. The following configuration adds a <em>Filter</em> definition:</p>
<pre class="CodeRay">&lt;source&gt;
  @type http
  port 8888
  bind 0.0.0.0
&lt;/source&gt;

&lt;filter test.cycle&gt;
  @type grep
  exclude1 action logout
&lt;/filter&gt;

&lt;match test.cycle&gt;
  @type stdout
&lt;/match&gt;
</pre>
<p>As you can see, the new <em>Filter</em> definition added will be a mandatory step before passing control to the <em>Match</em> section. The <em>Filter</em> basically accepts or rejects the <em>Event</em> based on it <em>type</em> and the defined rule. For our example we want to discard any user <code>logout</code> action, we only care about the <code>login</code> action. The way this is accomplished is by the <em>Filter</em> doing a <code>grep</code> that will exclude any message where the <code>action</code> key has the string value “logout”.</p>
<p>From a <em>Terminal</em>, run the following two <code>curl</code> commands (please note that each one contains a different <code>action</code> value):</p>
<pre class="CodeRay">$ curl -i -X POST -d 'json={"action":"login","user":2}' http://localhost:8888/test.cycle
HTTP/1.1 200 OK
Content-type: text/plain
Connection: Keep-Alive
Content-length: 0

$ curl -i -X POST -d 'json={"action":"logout","user":2}' http://localhost:8888/test.cycle
HTTP/1.1 200 OK
Content-type: text/plain
Connection: Keep-Alive
Content-length: 0
</pre>
<p>Now looking at the <a href="http://fluentd.org">Fluentd</a> service output we can see that only the event with <code>action</code> equal to “login” is matched. The <code>logout</code> <em>Event</em> was discarded:</p>
<pre class="CodeRay">$ bin/fluentd -c in_http.conf
2015-01-19 12:37:41 -0600 [info]: reading config file path="in_http.conf"
2015-01-19 12:37:41 -0600 [info]: starting fluentd-0.12.4
2015-01-19 12:37:41 -0600 [info]: using configuration file: &lt;ROOT&gt;
&lt;source&gt;
  @type http
  bind 0.0.0.0
  port 8888
&lt;/source&gt;
&lt;filter test.cycle&gt;
  @type grep
  exclude1 action logout
&lt;/filter&gt;
&lt;match test.cycle&gt;
  @type stdout
&lt;/match&gt;
&lt;/ROOT&gt;
2015-01-19 12:37:41 -0600 [info]: adding filter pattern="test.cycle" type="grep"
2015-01-19 12:37:41 -0600 [info]: adding match pattern="test.cycle" type="stdout"
2015-01-19 12:37:41 -0600 [info]: adding source type="http"
2015-01-27 01:27:11 -0600 test.cycle: {"action":"login","user":2}
</pre>
<p>As you can see, the <em>Events</em> follow a <em>step-by-step cycle</em> where they are processed in order from top to bottom. The new engine on <a href="http://fluentd.org">Fluentd</a> allows integrating as many <em>Filters</em> as needed. Considering that the configuration file might grow and start getting a bit complex, a new feature called <em>Labels</em> has been added that aims to help manage this complexity.</p>
<a name="labels"></a><h3>Labels</h3>
<p>The <em>Labels</em> implementation aims to reduce configuration file complexity and allows to define new <em>Routing</em> sections that do not follow the <em>top to bottom</em> order, instead acting like linked references. Using the previous example we will modify the setup as follows:</p>
<pre class="CodeRay">&lt;source&gt;
  @type http
  bind 0.0.0.0
  port 8888
  @label @STAGING
&lt;/source&gt;

&lt;filter test.cycle&gt;
  @type grep
  exclude1 action login
&lt;/filter&gt;

&lt;label @STAGING&gt;
  &lt;filter test.cycle&gt;
    @type grep
    exclude1 action logout
  &lt;/filter&gt;

  &lt;match test.cycle&gt;
    @type stdout
  &lt;/match&gt;
&lt;/label&gt;
</pre>
<p>This new configuration contains a <code>@label</code> key on the <code>source</code> indicating that any further steps take place on the <em>STAGING</em> <em>Label</em> section. Every <em>Event</em> reported on the <em>Source</em> is routed by the <em>Routing</em> engine and continue processing on <em>STAGING</em>, skipping the old filter definition.</p>
<a name="buffers"></a><h3>Buffers</h3>
<p>In this example, we use <code>stdout</code> non-buffered output, but in production buffered outputs are often necessary, e.g. <code>forward</code>, <code>mongodb</code>, <code>s3</code> and etc.
Buffered output plugins store received events into buffers and are then written out to a destination after meeting flush conditions.
Using buffered output you don’t see received events immediately, unlike <code>stdout</code> non-buffered output.</p>
<p>Buffers are important for reliability and throughput. See <a href="output-plugin-overview">Output</a> and <a href="buffer-plugin-overview">Buffer</a> articles.</p>
<a name="execution-unit"></a><h2>Execution unit</h2>
<p>This section describes the internal implementation.</p>
<p>Fluentd’s events are processed on input plugin thread by default.
For example, if you have <code>in_tail -&gt; filter_grep -&gt; out_stdout</code> pipeline, this pipeline is executed on in_tail’s thread.
The important point is <code>filter_grep</code> and <code>out_stdout</code> plugins don’t have own thread for processing.</p>
<p>For Buffered Output, output plugin has own threads for flushing buffer.
For example, if you have <code>in_tail -&gt; filter_grep -&gt; out_forward</code> pipeline, this pipeline is executed on in_tail’s thread and out_forward’s flush thread. in_tail’s thread processes events until events are written into buffer. Buffer flush and its error handling is the output responsibility.
This de-couples the input/output and this model has merits, separate responsibilities, easy error handling, good performance.</p>
<a name="conclusion"></a><h2>Conclusion</h2>
<p>Once the events are reported by the <a href="http://fluend.org">Fluentd</a> engine on the <em>Source</em> they can be processed <em>step by step</em> or inside a referenced <em>Label</em>, with any <em>Event</em> being filtered out at any moment. The new <em>Routing</em> engine behavior aims to provide more flexibility and simplifies the processing before events reach the <em>Output</em> plugin.</p>
<a name="learn-more"></a><h2>Learn More</h2>
<ul>
<li><a href="http://www.fluentd.org/blog/fluentd-v0.12-is-released">Fluentd v0.12 Blog Announcement</a></li>
</ul>
<div style="text-align:right">
  Last updated: 2016-02-01 15:01:24 UTC
  </div>
<hr size="1" style="margin-top: 10px; margin-bottom: 10px; color: rgba(0, 0, 0, .15);"/>
<div style="text-align:right">
Versions 
  
    
    | <a href="/v1.0/articles/life-of-a-fluentd-event">v1.0 (td-agent3)</a>
    
  

  

  
    
    | <b><i>v0.12</i> (td-agent2)<b>
</b></b>
</div>
<hr size="1" style="margin-top: 10px; margin-bottom: 10px; color: rgba(0, 0, 0, .15);"/>
<p>
    If this article is incorrect or outdated, or omits critical information, please <a href="https://github.com/fluent/fluentd-docs/issues?state=open">let us know</a>. <a href="http://www.fluentd.org/">Fluentd</a> is a  open source project under <a href="https://cncf.io/">Cloud Native Computing Foundation (CNCF)</a>. All components are available under the Apache 2 License.
  </p>
