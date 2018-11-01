<hgroup>
<h1>roundrobin Output Plugin</h1>
</hgroup>
<p>The <code>roundrobin</code> Output plugin distributes events to multiple outputs using a round-robin algorithm.</p>
<a name="example-configuration"></a>
<section id="table-of-contents"><h3>Table of Contents</h3>
<ul id="toc">
<li class="toc-item"><a href="#example-configuration">Example Configuration</a></li>
<li class="toc-item"><a href="#parameters">Parameters</a></li>
<ul class="sub-toc">
<li class="sub-toc-item"><a href="#@type-(required)">@type (required)</a></li>
<li class="sub-toc-item"><a href="#&lt;store&gt;-(required-at-least-one)">&lt;store&gt; (required at least one)</a></li>
</ul>
</ul>
</section>
<h2>Example Configuration</h2>
<p><code>out_roundrobin</code> is included in Fluentd’s core. No additional installation process is required.</p>
<pre class="CodeRay">&lt;match pattern&gt;
  @type roundrobin

  &lt;store&gt;
    @type tcp
    host 192.168.1.21
    ...
  &lt;/store&gt;
  &lt;store&gt;
    ...
  &lt;/store&gt;
  &lt;store&gt;
    ...
  &lt;/store&gt;
&lt;/match&gt;
</pre>
<table class="note">
<td class="icon"></td>
<td class="content">Please see the <a href="config-file">Config File</a> article for the basic structure and syntax of the configuration file.</td>
</table>
<a name="parameters"></a><h2>Parameters</h2>
<a name="@type-(required)"></a><h3>@type (required)</h3>
<p>The value must be <code>roundrobin</code>.</p>
<a name="&lt;store&gt;-(required-at-least-one)"></a><h3>&lt;store&gt; (required at least one)</h3>
<p>Specifies the storage destinations. The format is the same as the &lt;match&gt; directive.</p>
<h4>log_level option</h4>
<p>The <code>log_level</code> option allows the user to set different levels of logging for each plugin. The supported log levels are: <code>fatal</code>, <code>error</code>, <code>warn</code>, <code>info</code>, <code>debug</code>, and <code>trace</code>.</p>
<p>Please see the <a href="logging">logging article</a> for further details.</p>
<div style="text-align:right">
  Last updated: 2015-12-01 21:20:32 UTC
  </div>
<hr size="1" style="margin-top: 10px; margin-bottom: 10px; color: rgba(0, 0, 0, .15);"/>
<div style="text-align:right">
Versions 
  
    
    | <a href="/v1.0/articles/out_roundrobin">v1.0 (td-agent3)</a>
    
  

  

  
    
    | <b><i>v0.12</i> (td-agent2)<b>
</b></b>
</div>
<hr size="1" style="margin-top: 10px; margin-bottom: 10px; color: rgba(0, 0, 0, .15);"/>
<p>
    If this article is incorrect or outdated, or omits critical information, please <a href="https://github.com/fluent/fluentd-docs/issues?state=open">let us know</a>. <a href="http://www.fluentd.org/">Fluentd</a> is a  open source project under <a href="https://cncf.io/">Cloud Native Computing Foundation (CNCF)</a>. All components are available under the Apache 2 License.
  </p>
