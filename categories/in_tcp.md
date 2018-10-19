<section id="main">
<div id="page">
<div class="topic_content">
<article>
<div style="text-align:right">
<div style="text-align:right">
Versions 
  
    
    | <a href="/v1.0/articles/in_tcp">v1.0 (td-agent3)</a>
    
  

  

  
    
    | <b><i>v0.12</i> (td-agent2)<b>
</b></b>
</div>
</div>
<hr size="1" style="margin-top: 10px; margin-bottom: 10px; color: rgba(0, 0, 0, .15);"/>
<hgroup>
<h1>TCP Input Plugin</h1>
</hgroup>
<p>The <code>in_tcp</code> Input plugin enables Fluentd to accept TCP payload.</p>
<p>Don’t use this plugin for receiving logs from client libraries. Use <code>in_forward</code> for such cases.</p>
<a name="example-configuration"></a>
<section id="table-of-contents"><h3>Table of Contents</h3>
<ul id="toc">
<li class="toc-item"><a href="#example-configuration">Example Configuration</a></li>
<li class="toc-item"><a href="#parameters">Parameters</a></li>
<ul class="sub-toc">
<li class="sub-toc-item"><a href="#@type-(required)">@type (required)</a></li>
<li class="sub-toc-item"><a href="#tag-(required)">tag (required)</a></li>
<li class="sub-toc-item"><a href="#port">port</a></li>
<li class="sub-toc-item"><a href="#bind">bind</a></li>
<li class="sub-toc-item"><a href="#delimiter">delimiter</a></li>
<li class="sub-toc-item"><a href="#source_hostname_key">source_hostname_key</a></li>
<li class="sub-toc-item"><a href="#format-(required)">format (required)</a></li>
</ul>
</ul>
</section>
<h2>Example Configuration</h2>
<p><code>in_tcp</code> is included in Fluentd’s core. No additional installation process is required.</p>
<pre class="CodeRay">&lt;source&gt;
  @type tcp
  tag tcp.events # required
  format /^(?&lt;field1&gt;\d+):(?&lt;field2&gt;\w+)$/ # required
  port 20001 # optional. 5170 by default
  bind 0.0.0.0 # optional. 0.0.0.0 by default
  delimiter \n # optional. \n (newline) by default
&lt;/source&gt;
</pre>
<table class="note">
<td class="icon"></td>
<td class="content">Please see the <a href="config-file">Config File</a> article for the basic structure and syntax of the configuration file.</td>
</table>
<table class="note">
<td class="icon"></td>
<td class="content">We've observed the drastic performance improvements on Linux, with proper kernel parameter settings. If you have high-volume TCP traffic, please make sure to follow the instruction described at <a href="before-install">Before Installing Fluentd</a>.</td>
</table>
<a name="parameters"></a><h2>Parameters</h2>
<a name="@type-(required)"></a><h3>@type (required)</h3>
<p>The value must be <code>tcp</code>.</p>
<a name="tag-(required)"></a><h3>tag (required)</h3>
<p>tag of output events.</p>
<a name="port"></a><h3>port</h3>
<p>The port to listen to. Default Value = 5170</p>
<a name="bind"></a><h3>bind</h3>
<p>The bind address to listen to. Default Value = 0.0.0.0</p>
<a name="delimiter"></a><h3>delimiter</h3>
<p>The payload is read up to this character. By default, it is “\n”.</p>
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
<p>The format of the TCP payload. Here is the example by regular expression.</p>
<pre class="CodeRay">format /^(?&lt;field1&gt;\d+):(?&lt;field2&gt;\w+)$/
</pre>
<p>If you execute following command:</p>
<pre class="CodeRay"><span class="comment">$</span><span class="function"> echo '123456:awesome' | netcat 0.0.0.0 5170
</span></pre>
<p>then got parsed result like below:</p>
<pre class="CodeRay">{"field1":"123456","field2":"awesome}
</pre>
<p><code>in_tcp</code> uses parser plugin to parse the payload. See <a href="parser-plugin-overview">parser article</a> for more detail.</p>
<h4>log_level option</h4>
<p>The <code>log_level</code> option allows the user to set different levels of logging for each plugin. The supported log levels are: <code>fatal</code>, <code>error</code>, <code>warn</code>, <code>info</code>, <code>debug</code>, and <code>trace</code>.</p>
<p>Please see the <a href="logging">logging article</a> for further details.</p>
<div style="text-align:right">
  Last updated: 2016-10-21 06:29:58 UTC
  </div>
<hr size="1" style="margin-top: 10px; margin-bottom: 10px; color: rgba(0, 0, 0, .15);"/>
<div style="text-align:right">
Versions 
  
    
    | <a href="/v1.0/articles/in_tcp">v1.0 (td-agent3)</a>
    
  

  

  
    
    | <b><i>v0.12</i> (td-agent2)<b>
</b></b>
</div>
<hr size="1" style="margin-top: 10px; margin-bottom: 10px; color: rgba(0, 0, 0, .15);"/>
<p>
    If this article is incorrect or outdated, or omits critical information, please <a href="https://github.com/fluent/fluentd-docs/issues?state=open">let us know</a>. <a href="http://www.fluentd.org/">Fluentd</a> is a  open source project under <a href="https://cncf.io/">Cloud Native Computing Foundation (CNCF)</a>. All components are available under the Apache 2 License.
  </p>
</article>
</div>
<!-- /#topic_content -->
</div>
<!-- /#page -->
</section>