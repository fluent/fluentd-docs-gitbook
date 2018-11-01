<hgroup>
<h1>scribe Input Plugin</h1>
</hgroup>
<p>The <code>in_scribe</code> Input plugin enables Fluentd to retrieve records through the Scribe protocol. <a href="https://github.com/facebook/scribe">Scribe</a> is another log collector daemon that is open-sourced by Facebook.</p>
<p>Since Scribe hasn’t been well maintained recently, this plugin is useful for existing Scribe users who want to use Fluentd with an existing Scribe infrastructure.</p>
<a name="install"></a>
<section id="table-of-contents"><h3>Table of Contents</h3>
<ul id="toc">
<li class="toc-item"><a href="#install">Install</a></li>
<li class="toc-item"><a href="#example-configuration">Example Configuration</a></li>
<ul class="sub-toc">
<li class="sub-toc-item"><a href="#example-usage">Example Usage</a></li>
</ul>
<li class="toc-item"><a href="#parameters">Parameters</a></li>
</ul>
</section>
<h2>Install</h2>
<p><code>in_scribe</code> is included in td-agent by default. Fluentd gem users will need to install the fluent-plugin-scribe gem using the following command.</p>
<pre class="CodeRay"><span class="comment">$</span><span class="function"> fluent-gem install fluent-plugin-scribe
</span></pre>
<a name="example-configuration"></a><h2>Example Configuration</h2>
<pre class="CodeRay">&lt;source&gt;
  @type scribe
  port 1463

  bind 0.0.0.0
  msg_format json
&lt;/source&gt;
</pre>
<table class="note">
<td class="icon"></td>
<td class="content">Please see the <a href="config-file">Config File</a> article for the basic structure and syntax of the configuration file.</td>
</table>
<a name="example-usage"></a><h3>Example Usage</h3>
<p>We assume that you’re already familiar with the Scribe protocol. This <a href="https://github.com/fluent/fluent-plugin-scribe/blob/master/bin/fluent-scribe-remote">Ruby example code</a> posts logs to <code>in_scribe</code>.</p>
<p>Scribe’s <code>category</code> field becomes the <code>tag</code> of the Fluentd event log and Scribe’s <code>message</code> field becomes the record itself. The <code>msg_format</code> parameter specifies the format of the <code>message</code> field.</p>
<a name="parameters"></a><h2>Parameters</h2>
<h4>type (required)</h4>
<p>The value must be <code>scribe</code>.</p>
<h4>port</h4>
<p>The port to listen to. Default Value = 1463</p>
<h4>bind</h4>
<p>The bind address to listen to. Default Value = 0.0.0.0 (all addresses)</p>
<h4>msg_format</h4>
<p>The message format can be ‘text’, ‘json’, or ‘url_param’ (default: text)</p>
<p>For <code>json</code>, Fluentd’s record is organized as follows. Scribe’s message field must be a valid JSON string representing Hash; otherwise, the record is ignored.</p>
<pre class="CodeRay">tag: $category
record: $message
</pre>
<p>For <code>text</code>, Fluentd’s record is organized as follows. Scribe’s message can be any arbitrary string, but JSON is recommended for ease of use with the subsequent analytics pipeline.</p>
<pre class="CodeRay">tag: $category
record: {'message': $message}
</pre>
<p>For <code>url_param</code>, Fluentd’s record is organized as follows. Scribe’s message field must contain URL parameter style key-value pairs with URL encoding (e.g. key1=val1&amp;key2=val2).</p>
<pre class="CodeRay">tag: $url_param
record: {$key1: $val1, $key2: $val2, ...}
</pre>
<h4>is_framed</h4>
<p>Specifies whether to use Thrift’s framed protocol or not (default: true).</p>
<h4>server_type</h4>
<p>Chooses the server architecture. Options are ‘simple’, ‘threaded’, ‘thread_pool’, or ‘nonblocking’ (default: nonblocking).</p>
<h4>add_prefix</h4>
<p>The prefix string which will always be added to the tag (default: nil).</p>
<h4>log_level option</h4>
<p>The <code>log_level</code> option allows the user to set different levels of logging for each plugin. The supported log levels are: <code>fatal</code>, <code>error</code>, <code>warn</code>, <code>info</code>, <code>debug</code>, and <code>trace</code>.</p>
<p>Please see the <a href="logging">logging article</a> for further details.</p>
<div style="text-align:right">
  Last updated: 2016-10-21 06:29:58 UTC
  </div>
<hr size="1" style="margin-top: 10px; margin-bottom: 10px; color: rgba(0, 0, 0, .15);"/>
<div style="text-align:right">
Versions 
  

  

  
    
    | <b><i>v0.12</i> (td-agent2)<b>
</b></b>
</div>
<hr size="1" style="margin-top: 10px; margin-bottom: 10px; color: rgba(0, 0, 0, .15);"/>
<p>
    If this article is incorrect or outdated, or omits critical information, please <a href="https://github.com/fluent/fluentd-docs/issues?state=open">let us know</a>. <a href="http://www.fluentd.org/">Fluentd</a> is a  open source project under <a href="https://cncf.io/">Cloud Native Computing Foundation (CNCF)</a>. All components are available under the Apache 2 License.
  </p>
