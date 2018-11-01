<hgroup>
<h1>UDP Input Plugin</h1>
</hgroup>
<p>The <code>in_udp</code> Input plugin enables Fluentd to accept UDP payload.</p>
<a name="example-configuration"></a>
<section id="table-of-contents"><h3>Table of Contents</h3>
<ul id="toc">
<li class="toc-item"><a href="#example-configuration">Example Configuration</a></li>
<li class="toc-item"><a href="#parameters">Parameters</a></li>
<ul class="sub-toc">
<li class="sub-toc-item"><a href="#@type-(required)">@type (required)</a></li>
<li class="sub-toc-item"><a href="#tag-(required)">tag (required)</a></li>
<li class="sub-toc-item"><a href="#bind">bind</a></li>
<li class="sub-toc-item"><a href="#source_hostname_key">source_hostname_key</a></li>
<li class="sub-toc-item"><a href="#format-(required)">format (required)</a></li>
</ul>
<li class="toc-item"><a href="#faq">FAQ</a></li>
<ul class="sub-toc">
<li class="sub-toc-item"><a href="#how-to-prevent-request-drop?">How to prevent request drop?</a></li>
</ul>
</ul>
</section>
<h2>Example Configuration</h2>
<p><code>in_udp</code> is included in Fluentd’s core. No additional installation process is required.</p>
<pre class="CodeRay">&lt;source&gt;
  @type udp
  tag mytag # required
  format /^(?&lt;field1&gt;\d+):(?&lt;field2&gt;\w+)$/ # required
  port 20001 # optional. 5160 by default
  bind 0.0.0.0 # optional. 0.0.0.0 by default
  body_size_limit 1MB # optional. 4096 bytes by default
&lt;/source&gt;
</pre>
<table class="note">
<td class="icon"></td>
<td class="content">Please see the <a href="config-file">Config File</a> article for the basic structure and syntax of the configuration file.</td>
</table>
<table class="note">
<td class="icon"></td>
<td class="content">We've observed the drastic performance improvements on Linux, with proper kernel parameter settings (e.g. `net.core.rmem_max` parameter). If you have high-volume UDP traffic, please make sure to follow the instruction described at <a href="before-install">Before Installing Fluentd</a>.</td>
</table>
<a name="parameters"></a><h2>Parameters</h2>
<a name="@type-(required)"></a><h3>@type (required)</h3>
<p>The value must be <code>udp</code>.</p>
<a name="tag-(required)"></a><h3>tag (required)</h3>
<p>tag of output events.</p>
<h4>port</h4>
<p>The port to listen to. Default Value = 5160</p>
<a name="bind"></a><h3>bind</h3>
<p>The bind address to listen to. Default Value = 0.0.0.0</p>
<a name="source_hostname_key"></a><h3>source_hostname_key</h3>
<p>The field name of the client’s hostname. If set the value, the client’s hostname will be set to its key. The default is nil (no adding hostname).</p>
<p>If you set following configuration:</p>
<pre class="CodeRay">source_hostname_key client_host
</pre>
<p>then the client’s hostname is set to <code>client_host</code> field.</p>
<pre class="CodeRay">{
    ...
    "foo": "bar",
    "client_host": "client.hostname.org"
}
</pre>
<a name="format-(required)"></a><h3>format (required)</h3>
<p>The format of the UDP payload. <code>in_udp</code> uses parser plugin to parse the payload. See <a href="parser-plugin-overview">parser article</a> for more detail.</p>
<h4>log_level option</h4>
<p>The <code>log_level</code> option allows the user to set different levels of logging for each plugin. The supported log levels are: <code>fatal</code>, <code>error</code>, <code>warn</code>, <code>info</code>, <code>debug</code>, and <code>trace</code>.</p>
<p>Please see the <a href="logging">logging article</a> for further details.</p>
<a name="faq"></a><h2>FAQ</h2>
<a name="how-to-prevent-request-drop?"></a><h3>How to prevent request drop?</h3>
<p>If in_udp gots lots of packets within 1 sec, some packets are dropped.
For example, you can see bigger RcvbufErrors number via <code>netstat -su</code>.</p>
<p>This means in_udp with one process can’t handle such traffic.
Try <a href="https://github.com/fluent/fluent-plugin-multiprocess">fluent-plugin-multiprocess</a> to resolve the problem. See <a href="https://github.com/fluent/fluentd/issues/1334">issue 1334</a> for more detail.</p>
<div style="text-align:right">
  Last updated: 2016-12-19 03:25:48 UTC
  </div>
<hr size="1" style="margin-top: 10px; margin-bottom: 10px; color: rgba(0, 0, 0, .15);"/>
<div style="text-align:right">
Versions 
  
    
    | <a href="/v1.0/articles/in_udp">v1.0 (td-agent3)</a>
    
  

  

  
    
    | <b><i>v0.12</i> (td-agent2)<b>
</b></b>
</div>
<hr size="1" style="margin-top: 10px; margin-bottom: 10px; color: rgba(0, 0, 0, .15);"/>
<p>
    If this article is incorrect or outdated, or omits critical information, please <a href="https://github.com/fluent/fluentd-docs/issues?state=open">let us know</a>. <a href="http://www.fluentd.org/">Fluentd</a> is a  open source project under <a href="https://cncf.io/">Cloud Native Computing Foundation (CNCF)</a>. All components are available under the Apache 2 License.
  </p>
