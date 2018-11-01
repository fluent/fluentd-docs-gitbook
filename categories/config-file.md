<hgroup>
<h1>Configuration File Syntax</h1>
</hgroup>
<p>This article describes the basic concepts of Fluentd’s configuration file syntax.</p>
<a name="introduction:-the-life-of-a-fluentd-event"></a>
<section id="table-of-contents"><h3>Table of Contents</h3>
<ul id="toc">
<li class="toc-item"><a href="#introduction:-the-life-of-a-fluentd-event">Introduction: The Life of a Fluentd Event</a></li>
<li class="toc-item"><a href="#config-file-location">Config File Location</a></li>
<li class="toc-item"><a href="#character-encoding">Character encoding</a></li>
<li class="toc-item"><a href="#list-of-directives">List of Directives</a></li>
<li class="toc-item"><a href="#(1)-%E2%80%9Csource%E2%80%9D:-where-all-the-data-come-from">(1) “source”: where all the data come from</a></li>
<li class="toc-item"><a href="#(2)-%E2%80%9Cmatch%E2%80%9D:-tell-fluentd-what-to-do!">(2) “match”: Tell fluentd what to do!</a></li>
<li class="toc-item"><a href="#(3)-%E2%80%9Cfilter%E2%80%9D:-event-processing-pipeline">(3) “filter”: Event processing pipeline</a></li>
<li class="toc-item"><a href="#(4)-set-system-wide-configuration:-the-%E2%80%9Csystem%E2%80%9D-directive">(4) Set system wide configuration: the “system” directive</a></li>
<ul class="sub-toc">
<li class="sub-toc-item"><a href="#process_name">process_name</a></li>
</ul>
<li class="toc-item"><a href="#(5)-group-filter-and-output:-the-%E2%80%9Clabel%E2%80%9D-directive">(5) Group filter and output: the “label” directive</a></li>
<ul class="sub-toc">
<li class="sub-toc-item"><a href="#@error-label">@ERROR label</a></li>
</ul>
<li class="toc-item"><a href="#(6)-re-use-your-config:-the-%E2%80%9C@include%E2%80%9D-directive">(6) Re-use your config: the “@include” directive</a></li>
<li class="toc-item"><a href="#how-match-patterns-work">How match patterns work</a></li>
<ul class="sub-toc">
<li class="sub-toc-item"><a href="#wildcards-and-expansions">Wildcards and Expansions</a></li>
<li class="sub-toc-item"><a href="#note-on-match-order">Note on Match Order</a></li>
</ul>
<li class="toc-item"><a href="#supported-data-types-for-values">Supported Data Types for Values</a></li>
<li class="toc-item"><a href="#common-plugin-parameter">Common plugin parameter</a></li>
<li class="toc-item"><a href="#check-configuration-file">Check configuration file</a></li>
<li class="toc-item"><a href="#format-tips">Format tips</a></li>
<ul class="sub-toc">
<li class="sub-toc-item"><a href="#multi-line-support-for-%E2%80%9C-quoted-string,-array-and-hash-values">Multi line support for “ quoted string, array and hash values</a></li>
<li class="sub-toc-item"><a href="#embedded-ruby-code">Embedded Ruby code</a></li>
</ul>
</ul>
</section>
<h2>Introduction: The Life of a Fluentd Event</h2>
<p>Here is a brief overview of the life of a Fluentd event to help you understand the rest of this page:</p>
<iframe allowfullscreen="" frameborder="0" height="356" marginheight="0" marginwidth="0" scrolling="no" src="https://www.slideshare.net/slideshow/embed_code/34610229" style="border:1px solid #CCC; border-width:1px 1px 0; margin-bottom:5px; max-width: 100%;" width="427"> </iframe>
<p>The configuration file allows the user to control the input and output behavior of Fluentd by (1) selecting input and output plugins and (2) specifying the plugin parameters. The file is required for Fluentd to operate properly.</p>
<p>See also <a href="life-of-a-fluentd-event">Life of a Fluentd Event</a> article.</p>
<a name="config-file-location"></a><h2>Config File Location</h2>
<h4>RPM, Deb or DMG</h4>
<p>If you installed Fluentd using the td-agent packages, the config file is located at /etc/td-agent/td-agent.conf.</p>
<pre class="CodeRay"><span class="comment">$</span><span class="function"> sudo vi /etc/td-agent/td-agent.conf
</span></pre>
<h4>Gem</h4>
<p>If you installed Fluentd using the Ruby Gem, you can create the configuration file using the following commands. Sending a SIGHUP signal will reload the config file.</p>
<pre class="CodeRay"><span class="comment">$</span><span class="function"> sudo fluentd --setup /etc/fluent
</span><span class="comment">$</span><span class="function"> sudo vi /etc/fluent/fluent.conf
</span></pre>
<h4>FLUENT_CONF environment variable</h4>
<p>You can change default configuration file location via <code>FLUENT_CONF</code>.
For example, <code>/etc/td-agent/td-agent.conf</code> is specified via <code>FLUENT_CONF</code> inside td-agent scripts.</p>
<h4>-c option</h4>
<p>See <a href="command-line-option">Command Line Option article</a>.</p>
<a name="character-encoding"></a><h2>Character encoding</h2>
<p>Fluentd assumes configuration file is UTF-8 or ASCII.</p>
<a name="list-of-directives"></a><h2>List of Directives</h2>
<p>The configuration file consists of the following directives:</p>
<ol>
<li>
<strong>source</strong> directives determine the input sources.</li>
<li>
<strong>match</strong> directives determine the output destinations.</li>
<li>
<strong>filter</strong> directives determine the event processing pipelines.</li>
<li>
<strong>system</strong> directives set system wide configuration.</li>
<li>
<strong>label</strong> directives group the output and filter for internal routing</li>
<li>
<strong>@include</strong> directives include other files.</li>
</ol>
<p>Let’s actually create a configuration file step by step.</p>
<a name="(1)-%E2%80%9Csource%E2%80%9D:-where-all-the-data-come-from"></a><h2>(1) “source”: where all the data come from</h2>
<p>Fluentd’s input sources are enabled by selecting and configuring the desired input plugins using <strong>source</strong> directives. Fluentd’s standard input plugins include <code>http</code> and <code>forward</code>. <code>http</code> turns fluentd into an HTTP endpoint to accept incoming HTTP messages whereas <code>forward</code> turns fluentd into a TCP endpoint to accept TCP packets. Of course, it can be both at the same time (You can add as many sources as you wish)</p>
<pre class="CodeRay"># Receive events from 24224/tcp
# This is used by log forwarding and the fluent-cat command
&lt;source&gt;
  @type forward
  port 24224
&lt;/source&gt;

# http://this.host:9880/myapp.access?json={"event":"data"}
&lt;source&gt;
  @type http
  port 9880
&lt;/source&gt;
</pre>
<p>Each <strong>source</strong> directive must include a <code>@type</code> parameter. The <code>@type</code> parameter specifies which input plugin to use.</p>
<h4>Interlude: Routing</h4>
<p>The <code>source</code> submits events into the Fluentd’s routing engine. An event consists of three entities: <strong>tag</strong>, <strong>time</strong> and <strong>record</strong>. The tag is a string separated by ‘.’s (e.g. myapp.access), and is used as the directions for Fluentd’s internal routing engine. The time field is specified by input plugins, and it must be in the Unix time format. The record is a JSON object.</p>
<table class="note">
<td class="icon"></td>
<td class="content">Fluentd accepts all non-period characters as a part of a tag. However, since the tag is sometimes used in a different context by output destinations (e.g., table name, database name, key name, etc.), <b>it is strongly recommended that you stick to the lower-case alphabets, digits and underscore</b>, e.g., <code>^[a-z0-9_]+$</code>.</td>
</table>
<p>In the example above, the HTTP input plugin submits the following event:</p>
<pre class="CodeRay"># generated by http://this.host:9880/myapp.access?json={"event":"data"}
tag: myapp.access
time: (current time)
record: {"event":"data"}
</pre>
<h4>Didn’t find your input source? You can write your own plugin!</h4>
<p>You can add new input sources by writing your own plugins. For further information regarding Fluentd’s input sources, please refer to the <a href="input-plugin-overview">Input Plugin Overview</a> article.</p>
<a name="(2)-%E2%80%9Cmatch%E2%80%9D:-tell-fluentd-what-to-do!"></a><h2>(2) “match”: Tell fluentd what to do!</h2>
<p>The “match” directive looks for events with <strong>match</strong>ing tags and processes them. The most common use of the match directive is to output events to other systems (for this reason, the plugins that correspond to the match directive are called “output plugins”). Fluentd’s standard output plugins include <code>file</code> and <code>forward</code>.  Let’s add those to our configuration file.</p>
<pre class="CodeRay"># Receive events from 24224/tcp
# This is used by log forwarding and the fluent-cat command
&lt;source&gt;
  @type forward
  port 24224
&lt;/source&gt;

# http://this.host:9880/myapp.access?json={"event":"data"}
&lt;source&gt;
  @type http
  port 9880
&lt;/source&gt;

# Match events tagged with "myapp.access" and
# store them to /var/log/fluent/access.%Y-%m-%d
# Of course, you can control how you partition your data
# with the time_slice_format option.
&lt;match myapp.access&gt;
  @type file
  path /var/log/fluent/access
&lt;/match&gt;
</pre>
<p>Each <strong>match</strong> directive must include a match pattern and a <code>@type</code> parameter. Only events with a <strong>tag</strong> matching the pattern will be sent to the output destination (in the above example, only the events with the tag “myapp.access” is matched. See <a href="#how-match-patterns-work">the section below for more advanced usage</a>). The <code>@type</code> parameter specifies the output plugin to use.</p>
<p>Just like input sources, you can add new output destinations by writing your own plugins. For further information regarding Fluentd’s output destinations, please refer to the <a href="output-plugin-overview">Output Plugin Overview</a> article.</p>
<a name="(3)-%E2%80%9Cfilter%E2%80%9D:-event-processing-pipeline"></a><h2>(3) “filter”: Event processing pipeline</h2>
<p>The “filter” directive has same syntax as “match” but “filter” could be chained for processing pipeline.
Using filters, event flow is like below:</p>
<pre class="CodeRay">Input -&gt; filter 1 -&gt; ... -&gt; filter N -&gt; Output
</pre>
<p>Let’s add standard <code>record_transformer</code> filter to “match” example.</p>
<pre class="CodeRay"># http://this.host:9880/myapp.access?json={"event":"data"}
&lt;source&gt;
  @type http
  port 9880
&lt;/source&gt;

&lt;filter myapp.access&gt;
  @type record_transformer
  &lt;record&gt;
    host_param "#{Socket.gethostname}"
  &lt;/record&gt;
&lt;/filter&gt;

&lt;match myapp.access&gt;
  @type file
  path /var/log/fluent/access
&lt;/match&gt;
</pre>
<p>Received event, <code>{"event":"data"}</code>, goes to <code>record_transformer</code> filter first.
<code>record_transformer</code> adds “host_param” field to event and
filtered event, <code>{"event":"data","host_param":"webserver1"}</code>, goes to <code>file</code> output.</p>
<p>You can also add new filters by writing your own plugins. For further information regarding Fluentd’s filter destinations, please refer to the <a href="filter-plugin-overview">Filter Plugin Overview</a> article.</p>
<a name="(4)-set-system-wide-configuration:-the-%E2%80%9Csystem%E2%80%9D-directive"></a><h2>(4) Set system wide configuration: the “system” directive</h2>
<p>Following configurations are set by <em>system</em> directive. You can set same configurations by fluentd options:</p>
<ul>
<li>log_level</li>
<li>suppress_repeated_stacktrace</li>
<li>emit_error_log_interval</li>
<li>suppress_config_dump</li>
<li>without_source</li>
<li>process_name (only available in <em>system</em> directive. No fluentd option)</li>
</ul>
<p>Here is an example:</p>
<pre class="CodeRay">&lt;system&gt;
  # equal to -qq option
  log_level error
  # equal to --without-source option
  without_source
  # ...
&lt;/system&gt;
</pre>
<a name="process_name"></a><h3>process_name</h3>
<p>If set this parameter, fluentd’s supervisor and worker process names are changed.</p>
<pre class="CodeRay">&lt;system&gt;
  process_name fluentd1
&lt;/system&gt;
</pre>
<p>If we have this configuration, <code>ps</code> command shows the following result:</p>
<pre class="CodeRay">% ps aux | grep fluentd1
foo      45673   0.4  0.2  2523252  38620 s001  S+    7:04AM   0:00.44 worker:fluentd1
foo      45647   0.0  0.1  2481260  23700 s001  S+    7:04AM   0:00.40 supervisor:fluentd1
</pre>
<p>This feature requires ruby 2.1 or later.</p>
<a name="(5)-group-filter-and-output:-the-%E2%80%9Clabel%E2%80%9D-directive"></a><h2>(5) Group filter and output: the “label” directive</h2>
<p>The “label” directive groups filter and output for internal routing. “label” reduces the complexity of tag handling.</p>
<p>Here is a configuration example. “label” is built-in plugin parameter so <code>@</code> prefix is needed.</p>
<pre class="CodeRay">&lt;source&gt;
  @type forward
&lt;/source&gt;

&lt;source&gt;
  @type tail
  @label @SYSTEM
&lt;/source&gt;

&lt;filter access.**&gt;
  @type record_transformer
  &lt;record&gt;
    # ...
  &lt;/record&gt;
&lt;/filter&gt;
&lt;match **&gt;
  @type elasticsearch
  # ...
&lt;/match&gt;

&lt;label @SYSTEM&gt;
  &lt;filter var.log.middleware.**&gt;
    @type grep
    # ...
  &lt;/filter&gt;
  &lt;match **&gt;
    @type s3
    # ...
  &lt;/match&gt;
&lt;/label&gt;
</pre>
<p>In this configuration, <code>forward</code> events are routed to <code>record_transformer</code> filter / <code>elasticsearch</code> output and <code>in_tail</code> events are routed to <code>grep</code> filter / <code>s3</code> output inside <code>@SYSTEM</code> label.</p>
<p>“label” is useful for event flow separation without tag prefix.</p>
<a name="@error-label"></a><h3>@ERROR label</h3>
<p><code>@ERROR</code> label is a built-in label used for error record emitted by plugin’s <code>emit_error_event</code> API.</p>
<p>If you set <code>&lt;label @ERROR&gt;</code> in the configuration, events are routed to this label when emit related error, e.g. buffer is full or invalid record.</p>
<a name="(6)-re-use-your-config:-the-%E2%80%9C@include%E2%80%9D-directive"></a><h2>(6) Re-use your config: the “@include” directive</h2>
<p>Directives in separate configuration files can be imported using the <strong>@include</strong> directive:</p>
<pre class="CodeRay"># Include config files in the ./config.d directory
@include config.d/*.conf
</pre>
<p>The <strong>@include</strong> directive supports regular file path, glob pattern, and http URL conventions:</p>
<pre class="CodeRay"># absolute path
@include /path/to/config.conf

# if using a relative path, the directive will use
# the dirname of this config file to expand the path
@include extra.conf

# glob match pattern
@include config.d/*.conf

# http
@include http://example.com/fluent.conf
</pre>
<p>Note for glob pattern, files are expanded in the alphabetical order. If you have <code>a.conf</code> and <code>b.conf</code>, fluentd parses <code>a.conf</code> first.
But you should not write the configuration depends on this order. It is so error prone. Please separate <code>@include</code> for safety.</p>
<pre class="CodeRay"># If you have a.conf,b.conf,...,z.conf and a.conf / z.conf are important...

# This is bad
@include *.conf

# This is good
@include a.conf
@include config.d/*.conf
@include z.conf
</pre>
<a name="how-match-patterns-work"></a><h2>How match patterns work</h2>
<p>As described above, Fluentd allows you to route events based on their tags. Although you can just specify the exact tag to be matched (like <code>&lt;filter app.log&gt;</code>), there are a number of techniques you can use to manage the data flow more efficiently.</p>
<a name="wildcards-and-expansions"></a><h3>Wildcards and Expansions</h3>
<p>The following match patterns can be used in <code>&lt;match&gt;</code> and <code>&lt;filter&gt;</code> tags.</p>
<ul>
<li>
<p><code>*</code> matches a single tag part.</p>
<ul>
<li>For example, the pattern <code>a.*</code> matches <code>a.b</code>, but does not match <code>a</code> or <code>a.b.c</code>
</li>
</ul>
</li>
<li>
<p><code>**</code> matches zero or more tag parts.</p>
<ul>
<li>For example, the pattern <code>a.**</code> matches <code>a</code>, <code>a.b</code> and <code>a.b.c</code>
</li>
</ul>
</li>
<li>
<p><code>{X,Y,Z}</code> matches X, Y, or Z, where X, Y, and Z are match patterns.</p>
<ul>
<li><p>For example, the pattern <code>{a,b}</code> matches <code>a</code> and <code>b</code>, but does not match <code>c</code></p></li>
<li><p>This can be used in combination with the <code>*</code> or <code>**</code> patterns. Examples include <code>a.{b,c}.*</code> and <code>a.{b,c.**}</code></p></li>
</ul>
</li>
<li>
<p>When multiple patterns are listed inside a single tag (delimited by one or more whitespaces), it matches any of the listed patterns. For example:</p>
<ul>
<li><p>The patterns <code>&lt;match a b&gt;</code> match <code>a</code> and <code>b</code>.</p></li>
<li><p>The patterns <code>&lt;match a.** b.*&gt;</code> match <code>a</code>, <code>a.b</code>, <code>a.b.c</code> (from the first pattern) and <code>b.d</code> (from the second pattern).</p></li>
</ul>
</li>
</ul>
<a name="note-on-match-order"></a><h3>Note on Match Order</h3>
<p>Fluentd tries to match tags in the order that they appear in the config file.
So if you have the following configuration:</p>
<pre class="CodeRay"># ** matches all tags. Bad :(
&lt;match **&gt;
  @type blackhole_plugin
&lt;/match&gt;

&lt;match myapp.access&gt;
  @type file
  path /var/log/fluent/access
&lt;/match&gt;
</pre>
<p>then <code>myapp.access</code> is never matched. Wider match patterns should be defined after tight match patterns.</p>
<pre class="CodeRay">&lt;match myapp.access&gt;
  @type file
  path /var/log/fluent/access
&lt;/match&gt;

# Capture all unmatched tags. Good :)
&lt;match **&gt;
  @type blackhole_plugin
&lt;/match&gt;
</pre>
<p>Of course, if you use two same patterns, second <code>match</code> is never matched. If you want to send events to multiple outputs, consider <a href="out_copy">out_copy</a> plugin.</p>
<p>The common pitfall is when you put a <code>&lt;filter&gt;</code> block after <code>&lt;match&gt;</code>. It will never work as supposed, since events never go through the filter for the reason explained above.</p>
<pre class="CodeRay"># You should NOT put this &lt;filter&gt; block after the &lt;match&gt; block below.
# If you do, Fluentd will just emit events without applying the filter.
&lt;filter myapp.access&gt;
  @type record_transformer
  ...
&lt;/filter&gt;

&lt;match myapp.access&gt;
  @type file
  path /var/log/fluent/access
&lt;/match&gt;
</pre>
<a name="supported-data-types-for-values"></a><h2>Supported Data Types for Values</h2>
<p>Each Fluentd plugin has a set of parameters. For example, <a href="in_tail">in_tail</a> has parameters such as <code>rotate_wait</code> and <code>pos_file</code>. Each parameter has a specific type associated with it. They are defined as follows:</p>
<table class="note">
<td class="icon"></td>
<td class="content">Each parameter's type should be documented. If not, please let the plugin author know.</td>
</table>
<ul>
<li>
<code>string</code> type: the field is parsed as a string. This is the most “generic” type, where each plugin decides how to process the string.

<ul>
<li>
<code>string</code> has 3 literals, non-quoted one line string, <code>'</code> quoted string and <code>"</code> quoted string.</li>
<li>See “Format tips” section and <a href="https://github.com/fluent/fluentd/blob/master/example/v1_literal_example.conf">literal examples</a>.</li>
</ul>
</li>
<li>
<code>integer</code> type: the field is parsed as an integer.</li>
<li>
<code>float</code> type: the field is parsed as a float.</li>
<li>
<code>size</code> type: the field is parsed as the number of bytes. There are several notational variations:

<ul>
<li>If the value matches <code>&lt;INTEGER&gt;k</code> or <code>&lt;INTEGER&gt;K</code>, then the value is the INTEGER number of kilobytes.</li>
<li>If the value matches <code>&lt;INTEGER&gt;m</code> or <code>&lt;INTEGER&gt;M</code>, then the value is the INTEGER number of megabytes.</li>
<li>If the value matches <code>&lt;INTEGER&gt;g</code> or <code>&lt;INTEGER&gt;G</code>, then the value is the INTEGER number of gigabytes.</li>
<li>If the value matches <code>&lt;INTEGER&gt;t</code> or <code>&lt;INTEGER&gt;T</code>, then the value is the INTEGER number of terabytes.</li>
<li>Otherwise, the field is parsed as integer, and that integer is the number of bytes.</li>
</ul>
</li>
<li>
<code>time</code> type: the field is parsed as a time duration.

<ul>
<li>If the value matches <code>&lt;INTEGER&gt;s</code>, then the value is the INTEGER seconds.</li>
<li>If the value matches <code>&lt;INTEGER&gt;m</code>, then the value is the INTEGER minutes.</li>
<li>If the value matches <code>&lt;INTEGER&gt;h</code>, then the value is the INTEGER hours.</li>
<li>If the value matches <code>&lt;INTEGER&gt;d</code>, then the value is the INTEGER days.</li>
<li>Otherwise, the field is parsed as float, and that float is the number of seconds. This option is useful for specifying sub-second time durations such as “0.1” (=0.1 second = 100ms).</li>
</ul>
</li>
<li>
<code>array</code> type: the field is parsed as a JSON array. It also supports shorthand syntax. These are same values.

<ul>
<li>normal: <code>["key1", "key2"]</code>
</li>
<li>shorthand: <code>key1,key2</code>
</li>
</ul>
</li>
<li>
<code>hash</code> type: the field is parsed as a JSON object. It also supports shorthand syntax. These are same values.

<ul>
<li>normal: <code>{"key1":"value1", "key2":"value2"}</code>
</li>
<li>shorthand: <code>key1:value1,key2:value2</code>
</li>
</ul>
</li>
</ul>
<p><code>array</code> and <code>hash</code> are JSON because almost all programming languages and infrastructure tools
can generate JSON value easily than unusual format.</p>
<a name="common-plugin-parameter"></a><h2>Common plugin parameter</h2>
<p>These parameters are system reserved and it has <code>@</code> prefix.</p>
<ul>
<li>
<code>@type</code>: Specify plugin type</li>
<li>
<code>@id</code>: Specify plugin id. in_monitor_agent uses this value for plugin_id field</li>
<li>
<code>@label</code>: Specify label symbol. See <a href="config-file#5-group-filter-and-output-the-ldquolabelrdquo-directive">label</a> section</li>
<li>
<code>@log_level</code>: Specify per plugin log level. See <a href="logging#per-plugin-log">Per Plugin Log</a> section</li>
</ul>
<p><code>type</code>, <code>id</code> and <code>log_level</code> are supported for backward compatibility.</p>
<a name="check-configuration-file"></a><h2>Check configuration file</h2>
<p>You can check your configuration without plugins start by specifying <code>--dry-run</code> option.</p>
<pre class="CodeRay">$ fluentd --dry-run -c fluent.conf
</pre>
<a name="format-tips"></a><h2>Format tips</h2>
<p>This section describes useful features in configuration format.</p>
<a name="multi-line-support-for-%E2%80%9C-quoted-string,-array-and-hash-values"></a><h3>Multi line support for “ quoted string, array and hash values</h3>
<p>You can write multi line value for <code>"</code> quoted string, array and hash values.</p>
<pre class="CodeRay">str_param "foo  # This line is converted to "foo\nbar". NL is kept in the parameter
bar"
array_param [
  "a", "b"
]
hash_param {
  "k":"v",
  "k1":10
}
</pre>
<p>Fluentd assumes <code>[</code> or <code>{</code> is a start of array / hash.
So if you want to set <code>[</code> or <code>{</code> started but non-json parameter, please use <code>'</code> or <code>"</code>.</p>
<p>Example1: mail plugin:</p>
<pre class="CodeRay">&lt;match **&gt;
  @type mail
  subject "[CRITICAL] foo's alert system"
&lt;/match&gt;
</pre>
<p>Example2: map plugin:</p>
<pre class="CodeRay">&lt;match tag&gt;
  @type map
  map '[["code." + tag, time, { "code" =&gt; record["code"].to_i}], ["time." + tag, time, { "time" =&gt; record["time"].to_i}]]'
  multi true
&lt;/match&gt;
</pre>
<table class="note">
<td class="icon"></td>
<td class="content">We will remove this restriction with configuration parser improvement.</td>
</table>
<a name="embedded-ruby-code"></a><h3>Embedded Ruby code</h3>
<p>You can evaluate the Ruby code with <code>#{}</code> in <code>"</code> quoted string.
This is useful for setting machine information like hostname.</p>
<pre class="CodeRay">host_param "#{Socket.gethostname}" # host_param is actual hostname like `webserver1`.
env_param "foo-#{ENV["FOO_BAR"]}" # NOTE that foo-"#{ENV["FOO_BAR"]}" doesn't work.
</pre>
<table class="note">
<td class="icon"></td>
<td class="content">config-xxx mixins use "${}", not "#{}". These embedded configurations are two different things.</td>
</table>
<h3>In double quoted string literal, <code>\</code> is escape character</h3>
<p><code>\</code> is interpreted as escape character.
You need <code>\</code> for setting <code>"</code>, <code>\r</code>, <code>\n</code>, <code>\t</code>, <code>\</code> or several characters in double-quoted string literal.</p>
<pre class="CodeRay">str_param "foo\nbar" # \n is interpreted as actual LF character
</pre>
<div style="text-align:right">
  Last updated: 2017-03-03 06:10:26 UTC
  </div>
<hr size="1" style="margin-top: 10px; margin-bottom: 10px; color: rgba(0, 0, 0, .15);"/>
<div style="text-align:right">
Versions 
  
    
    | <a href="/v1.0/articles/config-file">v1.0 (td-agent3)</a>
    
  

  

  
    
    | <b><i>v0.12</i> (td-agent2)<b>
</b></b>
</div>
<hr size="1" style="margin-top: 10px; margin-bottom: 10px; color: rgba(0, 0, 0, .15);"/>
<p>
    If this article is incorrect or outdated, or omits critical information, please <a href="https://github.com/fluent/fluentd-docs/issues?state=open">let us know</a>. <a href="http://www.fluentd.org/">Fluentd</a> is a  open source project under <a href="https://cncf.io/">Cloud Native Computing Foundation (CNCF)</a>. All components are available under the Apache 2 License.
  </p>
