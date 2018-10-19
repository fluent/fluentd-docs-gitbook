<section id="main">
<div id="page">
<div class="topic_content">
<article>
<div style="text-align:right">
<div style="text-align:right">
Versions 
  
    
    | <a href="/v1.0/articles/in_http">v1.0 (td-agent3)</a>
    
  

  

  
    
    | <b><i>v0.12</i> (td-agent2)<b>
</b></b>
</div>
</div>
<hr size="1" style="margin-top: 10px; margin-bottom: 10px; color: rgba(0, 0, 0, .15);"/>
<hgroup>
<h1>http Input Plugin</h1>
</hgroup>
<p>The <code>in_http</code> Input plugin enables Fluentd to retrieve records from HTTP POST. The URL path becomes the <code>tag</code> of the Fluentd event log and the POSTed body element becomes the record itself.</p>
<a name="example-configuration"></a>
<section id="table-of-contents"><h3>Table of Contents</h3>
<ul id="toc">
<li class="toc-item"><a href="#example-configuration">Example Configuration</a></li>
<ul class="sub-toc">
<li class="sub-toc-item"><a href="#example-usage">Example Usage</a></li>
</ul>
<li class="toc-item"><a href="#parameters">Parameters</a></li>
<ul class="sub-toc">
<li class="sub-toc-item"><a href="#@type-(required)">@type (required)</a></li>
<li class="sub-toc-item"><a href="#port">port</a></li>
<li class="sub-toc-item"><a href="#bind">bind</a></li>
<li class="sub-toc-item"><a href="#body_size_limit">body_size_limit</a></li>
<li class="sub-toc-item"><a href="#keepalive_timeout">keepalive_timeout</a></li>
<li class="sub-toc-item"><a href="#add_http_headers">add_http_headers</a></li>
<li class="sub-toc-item"><a href="#add_remote_addr">add_remote_addr</a></li>
<li class="sub-toc-item"><a href="#cors_allow_origins">cors_allow_origins</a></li>
<li class="sub-toc-item"><a href="#format">format</a></li>
</ul>
<li class="toc-item"><a href="#additional-features">Additional Features</a></li>
<ul class="sub-toc">
<li class="sub-toc-item"><a href="#time-query-parameter">time query parameter</a></li>
<li class="sub-toc-item"><a href="#batch-mode">Batch mode</a></li>
</ul>
<li class="toc-item"><a href="#faq">FAQ</a></li>
<ul class="sub-toc">
<li class="sub-toc-item"><a href="#why-in_http-removes-%E2%80%98+%E2%80%99-from-my-log?">Why in_http removes ‘+’ from my log?</a></li>
</ul>
</ul>
</section>
<h2>Example Configuration</h2>
<p><code>in_http</code> is included in Fluentd’s core. No additional installation process is required.</p>
<pre class="CodeRay">&lt;source&gt;
  @type http
  port 8888
  bind 0.0.0.0
  body_size_limit 32m
  keepalive_timeout 10s
&lt;/source&gt;
</pre>
<table class="note">
<td class="icon"></td>
<td class="content">Please see the <a href="config-file">Config File</a> article for the basic structure and syntax of the configuration file.</td>
</table>
<a name="example-usage"></a><h3>Example Usage</h3>
<p>The example below posts a record using the <code>curl</code> command.</p>
<pre class="CodeRay"><span class="comment">$</span><span class="function"> curl -X POST -d 'json={"action":"login","user":2}'
</span><span class="string">  http://localhost:8888/test.tag.here;
</span></pre>
<a name="parameters"></a><h2>Parameters</h2>
<a name="@type-(required)"></a><h3>@type (required)</h3>
<p>The value must be <code>http</code>.</p>
<a name="port"></a><h3>port</h3>
<p>The port to listen to. Default Value = 9880</p>
<a name="bind"></a><h3>bind</h3>
<p>The bind address to listen to. Default Value = 0.0.0.0 (all addresses)</p>
<a name="body_size_limit"></a><h3>body_size_limit</h3>
<p>The size limit of the POSTed element. Default Value = 32MB</p>
<a name="keepalive_timeout"></a><h3>keepalive_timeout</h3>
<p>The timeout limit for keeping the connection alive. Default Value = 10 seconds</p>
<a name="add_http_headers"></a><h3>add_http_headers</h3>
<p>Add <code>HTTP_</code> prefix headers to the record. The default is <code>false</code></p>
<a name="add_remote_addr"></a><h3>add_remote_addr</h3>
<p>Add <code>REMOTE_ADDR</code> field to the record. The value of <code>REMOTE_ADDR</code> is the client’s address. The default is <code>false</code></p>
<p>If your system set multiple <code>X-Forwarded-For</code> headers in the request, <code>in_http</code> uses first one. For example:</p>
<pre class="CodeRay">X-Forwarded-For: host1, host2
X-Forwarded-For: host3
</pre>
<p>If send above multiple headers, <code>REMOTE_ADDR</code> value is <code>host1</code>.</p>
<a name="cors_allow_origins"></a><h3>cors_allow_origins</h3>
<p>White list domains for CORS. Default is no check.</p>
<p>If you set <code>["domain1", "domain2"]</code> to <code>cors_allow_origins</code>, <code>in_http</code> returns <code>403</code> to access from othe domains.</p>
<a name="format"></a><h3>format</h3>
<p>The format of the HTTP body. The default is <code>default</code>.</p>
<ul>
<li>default</li>
</ul>
<p>Accept records using <code>json=</code> / <code>msgpack=</code> style.</p>
<ul>
<li>regexp</li>
</ul>
<p>Specify body format by regular expression.</p>
<pre class="CodeRay">format /^(?&lt;field1&gt;\d+):(?&lt;field2&gt;\w+)$/
</pre>
<p>If you execute following command:</p>
<pre class="CodeRay"><span class="comment">$</span><span class="function"> curl -X POST -d '123456:awesome' "http://localhost:8888/test.tag.here"
</span></pre>
<p>then got parsed result like below:</p>
<pre class="CodeRay">{"field1":"123456","field2":"awesome}
</pre>
<p><code>json</code>, <code>ltsv</code>, <code>tsv</code>, <code>csv</code> and <code>none</code> are also supported. Check <a href="parser-plugin-overview">parser plugin overview</a> for more details.</p>
<h4>log_level option</h4>
<p>The <code>log_level</code> option allows the user to set different levels of logging for each plugin. The supported log levels are: <code>fatal</code>, <code>error</code>, <code>warn</code>, <code>info</code>, <code>debug</code>, and <code>trace</code>.</p>
<p>Please see the <a href="logging">logging article</a> for further details.</p>
<a name="additional-features"></a><h2>Additional Features</h2>
<a name="time-query-parameter"></a><h3>time query parameter</h3>
<p>If you want to pass the event time from your application, please use the <code>time</code> query parameter.</p>
<pre class="CodeRay"><span class="comment">$</span><span class="function"> curl -X POST -d 'json={"action":"login","user":2}'
</span><span class="string">  "http://localhost:8888/test.tag.here?time=1392021185"
</span></pre>
<a name="batch-mode"></a><h3>Batch mode</h3>
<p>If you use <code>default</code> format, then you can send array type of json / msgpack to in_http.</p>
<pre class="CodeRay"><span class="comment">$</span><span class="function"> curl -X POST -d 'json=[{"action":"login","user":2,"time":1392021185},{"action":"logout","user":2,"time":1392027356}]'
</span><span class="string">  http://localhost:8888/test.tag.here;
</span></pre>
<p>This improves the input performance by reducing HTTP access. Non <code>default</code> format doesn’t support batch mode yet.
Here is a simple bechmark result on MacBook Pro with ruby 2.3:</p>
<table>
<tr>
<td>json</td>
<td>msgpack</td>
<td>msgpack array(10 items)</td>
</tr>
<tr>
<td>2100 events/sec</td>
<td>2400 events/sec</td>
<td>10000 events/sec</td>
</tr>
</table>
<p>Tested configuration and ruby script is <a href="https://gist.github.com/repeatedly/672ac73abf7cbcb629aaec791838cf6d">here</a>.</p>
<a name="faq"></a><h2>FAQ</h2>
<a name="why-in_http-removes-%E2%80%98+%E2%80%99-from-my-log?"></a><h3>Why in_http removes ‘+’ from my log?</h3>
<p>This is HTTP spec, not fluentd problem. You need to encode your payload properly or use multipart request.
Here is ruby example:</p>
<pre class="CodeRay"># OK
URI.encode_www_form({json: {"message" =&gt; "foo+bar"}.to_json})

# NG
"json=#{ {"message" =&gt; "foo+bar"}.to_json}"
</pre>
<p>curl command example:</p>
<pre class="CodeRay"># OK
curl -X POST -H 'Content-Type: multipart/form-data' -F 'json={"message":"foo+bar"}' http://localhost:8888/test.tag.here

# NG
curl -X POST -F 'json={"message":"foo+bar"}' http://localhost:8888/test.tag.here
</pre>
<div style="text-align:right">
  Last updated: 2017-03-21 23:41:43 UTC
  </div>
<hr size="1" style="margin-top: 10px; margin-bottom: 10px; color: rgba(0, 0, 0, .15);"/>
<div style="text-align:right">
Versions 
  
    
    | <a href="/v1.0/articles/in_http">v1.0 (td-agent3)</a>
    
  

  

  
    
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