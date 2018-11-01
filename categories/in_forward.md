<hgroup>
<h1>forward Input Plugin</h1>
</hgroup>
<p>The <code>in_forward</code> Input plugin listens to a TCP socket to receive the event stream. It also listens to an UDP socket to receive heartbeat messages.</p>
<p>This plugin is mainly used to receive event logs from other Fluentd instances, the fluent-cat command, or client libraries. This is by far the most efficient way to retrieve the records.</p>
<table class="note">
<td class="icon"></td>
<td class="content">Do <b>NOT</b> use this plugin for inter-DC or public internet data transfer without secure connections. To provide the reliable / low-latency transfer, we assume this plugin is only used within private networks. <br/><br/>If you open up the port of this plugin to the internet, the attacker can easily crash Fluentd by using the specific packet. If you require a secure connection between nodes, please consider using <a href="in_secure_forward">in_secure_forward</a>.</td>
</table>
<a name="example-configuration"></a>
<section id="table-of-contents"><h3>Table of Contents</h3>
<ul id="toc">
<li class="toc-item"><a href="#example-configuration">Example Configuration</a></li>
<li class="toc-item"><a href="#parameters">Parameters</a></li>
<ul class="sub-toc">
<li class="sub-toc-item"><a href="#@type-(required)">@type (required)</a></li>
<li class="sub-toc-item"><a href="#port">port</a></li>
<li class="sub-toc-item"><a href="#bind">bind</a></li>
<li class="sub-toc-item"><a href="#linger_timeout">linger_timeout</a></li>
<li class="sub-toc-item"><a href="#chunk_size_limit">chunk_size_limit</a></li>
<li class="sub-toc-item"><a href="#chunk_size_warn_limit">chunk_size_warn_limit</a></li>
<li class="sub-toc-item"><a href="#skip_invalid_event-(v0.12.20-or-later)">skip_invalid_event (v0.12.20 or later)</a></li>
<li class="sub-toc-item"><a href="#source_hostname_key-(v0.12.28-or-later)">source_hostname_key (v0.12.28 or later)</a></li>
</ul>
<li class="toc-item"><a href="#protocol">Protocol</a></li>
<ul class="sub-toc">
<li class="sub-toc-item"><a href="#communication-with-v1.0">Communication with v1.0</a></li>
</ul>
<li class="toc-item"><a href="#faq">FAQ</a></li>
<ul class="sub-toc">
<li class="sub-toc-item"><a href="#why-in_forward-doesn%E2%80%99t-have-tag-parameter?">Why in_forward doesn’t have tag parameter?</a></li>
<li class="sub-toc-item"><a href="#how-to-parse-incoming-events?">How to parse incoming events?</a></li>
<li class="sub-toc-item"><a href="#i-got-messagepack::unknownexttypeerror-error.-why?">I got MessagePack::UnknownExtTypeError error. Why?</a></li>
</ul>
</ul>
</section>
<h2>Example Configuration</h2>
<p><code>in_forward</code> is included in Fluentd’s core. No additional installation process is required.</p>
<pre class="CodeRay">&lt;source&gt;
  @type forward
  port 24224
  bind 0.0.0.0
&lt;/source&gt;
</pre>
<table class="note">
<td class="icon"></td>
<td class="content">Please see the <a href="config-file">Config File</a> article for the basic structure and syntax of the configuration file.</td>
</table>
<a name="parameters"></a><h2>Parameters</h2>
<a name="@type-(required)"></a><h3>@type (required)</h3>
<p>The value must be <code>forward</code>.</p>
<a name="port"></a><h3>port</h3>
<p>The port to listen to. Default Value = 24224</p>
<a name="bind"></a><h3>bind</h3>
<p>The bind address to listen to. Default Value = 0.0.0.0 (all addresses)</p>
<a name="linger_timeout"></a><h3>linger_timeout</h3>
<p>The timeout time used to set linger option. The default is 0</p>
<a name="chunk_size_limit"></a><h3>chunk_size_limit</h3>
<p>The size limit of the the received chunk. If the chunk size is larger than this value, then the received chunk is dropped. The default is nil (no limit).</p>
<a name="chunk_size_warn_limit"></a><h3>chunk_size_warn_limit</h3>
<p>The warning size limit of the received chunk. If the chunk size is larger than this value, a warning message will be sent. The default is nil (no warning).</p>
<a name="skip_invalid_event-(v0.12.20-or-later)"></a><h3>skip_invalid_event (v0.12.20 or later)</h3>
<p>Skip an event if incoming event is invalid. The default is false.</p>
<p>This option is useful at forwarder, not aggragator. v0.12.20 or later.</p>
<a name="source_hostname_key-(v0.12.28-or-later)"></a><h3>source_hostname_key (v0.12.28 or later)</h3>
<p>The field name of the client’s hostname. If set the value, the client’s hostname will be set to its key. The default is nil (no adding hostname).</p>
<p>This iterates incoming events. So if you sends larger chunks to <code>in_forward</code>, it needs additional processing time.</p>
<h4>log_level option</h4>
<p>The <code>log_level</code> option allows the user to set different levels of logging for each plugin. The supported log levels are: <code>fatal</code>, <code>error</code>, <code>warn</code>, <code>info</code>, <code>debug</code>, and <code>trace</code>.</p>
<p>Please see the <a href="logging">logging article</a> for further details.</p>
<a name="protocol"></a><h2>Protocol</h2>
<p>This plugin accepts both JSON or <a href="http://msgpack.org/">MessagePack</a> messages and automatically detects which is used.  Internally, Fluent uses MessagePack as it is more efficient than JSON.</p>
<p>The time value is a platform specific integer and is based on the output of Ruby’s <code>Time.now.to_i</code> function.  On Linux, BSD and MAC systems, this is the number of seconds since 1970.</p>
<p>Multiple messages may be sent in the same connection.</p>
<pre class="CodeRay">stream:
  message...

message:
  [tag, time, record]
  or
  [tag, [[time,record], [time,record], ...]]

example:
  ["myapp.access", 1308466941, {"a":1}]["myapp.messages", 1308466942, {"b":2}]
  ["myapp.access", [[1308466941, {"a":1}], [1308466942, {"b":2}]]]
</pre>
<a name="communication-with-v1.0"></a><h3>Communication with v1.0</h3>
<p>v0.12 <code>in_forward</code> can’t accept data from v1.0 <code>out_forward</code> because time format is different.
If you want to forward data from v1.0 to v0.12, set <code>time_as_integer</code> in v1.0 <code>out_forward</code>.</p>
<a name="faq"></a><h2>FAQ</h2>
<a name="why-in_forward-doesn%E2%80%99t-have-tag-parameter?"></a><h3>Why in_forward doesn’t have tag parameter?</h3>
<p><code>in_forward</code> uses <code>tag</code> of incoming events so no fixed <code>tag</code> parameter. See above “Protocol” section.</p>
<a name="how-to-parse-incoming-events?"></a><h3>How to parse incoming events?</h3>
<p><code>in_forward</code> doesn’t provide parsing mechanism unlike <code>in_tail</code> or <code>in_tcp</code> because <code>in_forward</code> is mainly for efficient log transfer. If you want to parse incoming event, use <a href="https://github.com/tagomoris/fluent-plugin-parser">parser filter</a> in your pipeline.<br/>
See Docker logging driver usecase: <a href="http://www.fluentd.org/guides/recipes/docker-logging">Docker Logging</a></p>
<a name="i-got-messagepack::unknownexttypeerror-error.-why?"></a><h3>I got MessagePack::UnknownExtTypeError error. Why?</h3>
<p>This error happens when forwarder’s fluentd is v0.14/v1.0 and receiver’s fluentd is 0.12.
To avoid this problem, set <code>time_as_integer</code> to <code>out_forward</code> setting in v0.14/v1.0 fluentd.
See “Communication with v1.0”.</p>
<div style="text-align:right">
  Last updated: 2016-11-10 02:29:44 UTC
  </div>
<hr size="1" style="margin-top: 10px; margin-bottom: 10px; color: rgba(0, 0, 0, .15);"/>
<div style="text-align:right">
Versions 
  
    
    | <a href="/v1.0/articles/in_forward">v1.0 (td-agent3)</a>
    
  

  

  
    
    | <b><i>v0.12</i> (td-agent2)<b>
</b></b>
</div>
<hr size="1" style="margin-top: 10px; margin-bottom: 10px; color: rgba(0, 0, 0, .15);"/>
<p>
    If this article is incorrect or outdated, or omits critical information, please <a href="https://github.com/fluent/fluentd-docs/issues?state=open">let us know</a>. <a href="http://www.fluentd.org/">Fluentd</a> is a  open source project under <a href="https://cncf.io/">Cloud Native Computing Foundation (CNCF)</a>. All components are available under the Apache 2 License.
  </p>
