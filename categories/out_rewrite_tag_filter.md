<section id="main">
<div id="page">
<div class="topic_content">
<article>
<div style="text-align:right">
<div style="text-align:right">
Versions 
  
    
    | <a href="/v1.0/articles/out_rewrite_tag_filter">v1.0 (td-agent3)</a>
    
  

  

  
    
    | <b><i>v0.12</i> (td-agent2)<b>
</b></b>
</div>
</div>
<hr size="1" style="margin-top: 10px; margin-bottom: 10px; color: rgba(0, 0, 0, .15);"/>
<hgroup>
<h1>rewrite_tag_filter Output Plugin</h1>
</hgroup>
<p>The <code>out_rewrite_tag_filter</code> Output plugin has designed to rewrite tag like mod_rewrite. Re-emit a record with rewrited tag when a value matches/unmatches with the regular expression.  Also you can change a tag from apache log by domain, status-code(ex. 500 error), user-agent, request-uri, regex-backreference and so on with regular expression.</p>
<a name="how-it-works"></a>
<section id="table-of-contents"><h3>Table of Contents</h3>
<ul id="toc">
<li class="toc-item"><a href="#how-it-works">How it works</a></li>
<li class="toc-item"><a href="#install">Install</a></li>
<li class="toc-item"><a href="#example-configuration">Example Configuration</a></li>
<li class="toc-item"><a href="#parameters">Parameters</a></li>
<ul class="sub-toc">
<li class="sub-toc-item"><a href="#rewriterulen-(required-at-least-one)">rewriteruleN (required at least one)</a></li>
<li class="sub-toc-item"><a href="#capitalize_regex_backreference">capitalize_regex_backreference</a></li>
<li class="sub-toc-item"><a href="#hostname_command">hostname_command</a></li>
<li class="sub-toc-item"><a href="#&lt;rule&gt;-section-(optional)-(multiple)">&lt;rule&gt; section (optional) (multiple)</a></li>
</ul>
<li class="toc-item"><a href="#placeholders">Placeholders</a></li>
<li class="toc-item"><a href="#use-cases">Use cases</a></li>
<li class="toc-item"><a href="#faq">FAQ</a></li>
<ul class="sub-toc">
<li class="sub-toc-item"><a href="#with-rewrite-tag-filter,-logs-are-not-forwarded.-why?">With rewrite-tag-filter, logs are not forwarded. Why?</a></li>
</ul>
</ul>
</section>
<h2>How it works</h2>
<p>It is a sample to arrange the tags by the regexp matched value of ‘message’.</p>
<pre class="CodeRay"># Configuration
&lt;match app.message&gt;
  @type rewrite_tag_filter
  &lt;rule&gt;
    key message
    pattern ^\[(\w+)\] $1.${tag}
    tag $1.${tag}
  &lt;/rule&gt;
&lt;/match&gt;

:::text
+----------------------------------------+        +----------------------------------------------+
| original record                        |        | rewrited tag record                          |
|----------------------------------------|        |----------------------------------------------|
| app.message {"message":"[info]: ..."}  | +----&gt; | info.app.message {"message":"[info]: ..."}   |
| app.message {"message":"[warn]: ..."}  | +----&gt; | warn.app.message {"message":"[warn]: ..."}   |
| app.message {"message":"[crit]: ..."}  | +----&gt; | crit.app.message {"message":"[crit]: ..."}   |
| app.message {"message":"[alert]: ..."} | +----&gt; | alert.app.message {"message":"[alert]: ..."} |
+----------------------------------------+        +----------------------------------------------+
</pre>
<a name="install"></a><h2>Install</h2>
<p><code>out_rewrite_tag_filter</code> is included in td-agent by default (v1.1.18 or later). Fluentd gem users will have to install the fluent-plugin-rewrite-tag-filter gem using the following command.</p>
<pre class="CodeRay"><span class="comment">$</span><span class="function"> fluent-gem install fluent-plugin-rewrite-tag-filter
</span></pre>
<a name="example-configuration"></a><h2>Example Configuration</h2>
<p>Configuration design is dropping some pattern record first, then re-emit other matched record as new tag name.</p>
<pre class="CodeRay">&lt;match apache.access&gt;
  @type rewrite_tag_filter
  capitalize_regex_backreference yes
  &lt;rule&gt;
    key     path
    pattern \.(gif|jpe?g|png|pdf|zip)$
    tag     clear
  &lt;/rule&gt;
  &lt;rule&gt;
    key     status
    pattern ^200$
    tag     clear
    invert  true
  &lt;/rule&gt;
  &lt;rule&gt;
    key     domain
    pattern ^.+\.com$
    tag     clear
    invert  true
  &lt;/rule&gt;
  &lt;rule&gt;
    key     domain
    pattern ^maps\.example\.com$
    tag     site.ExampleMaps
  &lt;/rule&gt;
  &lt;rule&gt;
    key     domain
    pattern ^news\.example\.com$
    tag     site.ExampleNews
  &lt;/rule&gt;
  # it is also supported regexp back reference.
  &lt;rule&gt;
    key     domain
    pattern ^(mail)\.(example)\.com$
    tag     site.$2$1
  &lt;/rule&gt;
  &lt;rule&gt;
    key     domain
    pattern .+
    tag     site.unmatched
  &lt;/rule&gt;
&lt;/match&gt;

&lt;match clear&gt;
  @type null
&lt;/match&gt;
</pre>
<table class="note">
<td class="icon"></td>
<td class="content">Please see the <a href="https://github.com/fluent/fluent-plugin-rewrite-tag-filter">README.md</a> for further details.</td>
</table>
<a name="parameters"></a><h2>Parameters</h2>
<a name="rewriterulen-(required-at-least-one)"></a><h3>rewriteruleN (required at least one)</h3>
<p>This is deprecated since 1.6.0. Use &lt;rule&gt; section.</p>
<p><code>rewriterule&lt;num&gt; &lt;key&gt; &lt;regex_pattern&gt; &lt;new_tag&gt;</code></p>
<table class="note">
<td class="icon"></td>
<td class="content">It works with the order &lt;num&gt; ascending, regexp matching &lt;regex_pattern&gt; for the values of &lt;key&gt; from each record, re-emit with &lt;new_tag&gt;.</td>
</table>
<a name="capitalize_regex_backreference"></a><h3>capitalize_regex_backreference</h3>
<p>Capitalize letter for every matched regex backreference. (ex: maps -&gt; Maps)</p>
<a name="hostname_command"></a><h3>hostname_command</h3>
<p>Override hostname command for placeholder. (default setting is long hostname)</p>
<h4>log_level option</h4>
<p>The <code>log_level</code> option allows the user to set different levels of logging for each plugin. The supported log levels are: <code>fatal</code>, <code>error</code>, <code>warn</code>, <code>info</code>, <code>debug</code>, and <code>trace</code>.</p>
<p>Please see the <a href="logging">logging article</a> for further details.</p>
<a name="&lt;rule&gt;-section-(optional)-(multiple)"></a><h3>&lt;rule&gt; section (optional) (multiple)</h3>
<ul>
<li>
<strong>key</strong> (string) (required): The field name to which the regular expression is applied</li>
<li>
<strong>pattern</strong> (regexp) (required): The regular expression</li>
<li>
<strong>tag</strong> (string) (required): New tag</li>
<li>
<strong>invert</strong> (bool) (optional): If true, rewrite tag when unmatch pattern

<ul>
<li>Default value: <code>false</code>
</li>
</ul>
</li>
</ul>
<p>It works with the order of appearance, regexp matching <code>rule/pattern</code> for the values of <code>rule/key</code> from each record, re-emit with <code>rule/tag</code>.</p>
<a name="placeholders"></a><h2>Placeholders</h2>
<p>It is supported these placeholder for new_tag (rewrited tag). See more details at <a href="https://github.com/fluent/fluent-plugin-rewrite-tag-filter#tag-placeholder">README.md</a></p>
<ul>
<li>${tag}</li>
<li>__TAG__</li>
<li>{$tag_parts[n]}</li>
<li>__TAG_PARTS[n]__</li>
<li>${hostname}</li>
<li>__HOSTNAME__</li>
</ul>
<a name="use-cases"></a><h2>Use cases</h2>
<ul>
<li>Aggregate + display 404 status pages by URL and referrer to find and fix dead links.</li>
<li>Send an IRC alert for 5xx status codes on exceeding thresholds.</li>
</ul>
<h4>Aggregate + display 404 status pages by URL and referrer to find and fix dead links.</h4>
<ul>
<li>Collect access log from multiple application servers (config1)</li>
<li>Sum up the 404 error and output to mongoDB (config2)</li>
</ul>
<p>Note: These plugins are required to be installed.
* fluent-plugin-rewrite-tag-filter
* fluent-plugin-mongo</p>
<h5>[Config1] Application Servers</h5>
<pre class="CodeRay"># Input access log to fluentd with embedded in_tail plugin
&lt;source&gt;
  @type tail
  path /var/log/httpd/access_log
  format apache2
  time_format %d/%b/%Y:%H:%M:%S %z
  tag apache.access
  pos_file /var/log/td-agent/apache_access.pos
&lt;/source&gt;

# Forward to monitoring server
&lt;match apache.access&gt;
  @type forward
  flush_interval 5s
  &lt;server&gt;
    name server_name
    host 10.100.1.20
  &lt;/server&gt;
&lt;/match&gt;
</pre>
<h5>[Config2] Monitoring Server</h5>
<pre class="CodeRay"># built-in TCP input
&lt;source&gt;
  @type forward
&lt;/source&gt;

# Filter record like mod_rewrite with fluent-plugin-rewrite-tag-filter
&lt;match apache.access&gt;
  @type rewrite_tag_filter
  &lt;rule&gt;
    key     status
    pattern ^(?!404)$
    tag     clear
  &lt;/rule&gt;
  &lt;rule&gt;
    key      path
    pattern .+
    tag      mongo.apache.access.error404
  &lt;/rule&gt;
&lt;/match&gt;

# Store deadlinks log into mongoDB
&lt;match mongo.apache.access.error404&gt;
  @type        mongo
  host        10.100.1.30
  database    apache
  collection  deadlinks
  capped
  capped_size 50m
&lt;/match&gt;

# Clear tag
&lt;match clear&gt;
  @type null
&lt;/match&gt;
</pre>
<h4>Send an IRC alert for 5xx status codes on exceeding thresholds.</h4>
<ul>
<li>Collect access log from multiple application servers (config1)</li>
<li>Sum up the 500 error and notify IRC and logging details to mongoDB (config2)</li>
</ul>
<p>Note: These plugins are required to be installed.
* fluent-plugin-rewrite-tag-filter
* fluent-plugin-datacounter
* fluent-plugin-notifier
* fluent-plugin-parser
* fluent-plugin-mongo
* fluent-plugin-irc</p>
<h5>[Config1] Application Servers</h5>
<pre class="CodeRay"># Input access log to fluentd with embedded in_tail plugin
# sample results: {"host":"127.0.0.1","user":null,"method":"GET","path":"/","code":500,"size":5039,"referer":null,"agent":"Mozilla"}
&lt;source&gt;
  @type tail
  path /var/log/httpd/access_log
  format apache2
  time_format %d/%b/%Y:%H:%M:%S %z
  tag apache.access
  pos_file /var/log/td-agent/apache_access.pos
&lt;/source&gt;

# Forward to monitoring server
&lt;match apache.access&gt;
  @type forward
  flush_interval 5s
  &lt;server&gt;
    name server_name
    host 10.100.1.20
  &lt;/server&gt;
&lt;/match&gt;
</pre>
<h5>[Config2] Monitoring Server</h5>
<pre class="CodeRay"># built-in TCP input
&lt;source&gt;
  @type forward
&lt;/source&gt;

# Filter record like mod_rewrite with fluent-plugin-rewrite-tag-filter
&lt;match apache.access&gt;
  @type copy
  &lt;store&gt;
    @type rewrite_tag_filter
    # drop static image record and redirect as 'count.apache.access'
    &lt;rule&gt;
      key     path
      pattern ^/(img|css|js|static|assets)/
      tag     clear
    &lt;/rule&gt;
    &lt;rule&gt;
      key     path
      pattern .+
      tag     count.apache.access
    &lt;/rule&gt;
  &lt;/store&gt;
  &lt;store&gt;
    @type rewrite_tag_filter
    &lt;rule&gt;
      key     code
      pattern ^5\d\d$
      tag     mongo.apache.access.error5xx
    &lt;/rule&gt;
  &lt;/store&gt;
&lt;/match&gt;

# Store 5xx error log into mongoDB
&lt;match mongo.apache.access.error5xx&gt;
  @type        mongo
  host        10.100.1.30
  database    apache
  collection  error_5xx
  capped
  capped_size 50m
&lt;/match&gt;

# Count by status code
# sample results: {"unmatched_count":0,"unmatched_rate":0.0,"unmatched_percentage":0.0,"200_count":0,"200_rate":0.0,"200_percentage":0.0,"2xx_count":0,"2xx_rate":0.0,"2xx_percentage":0.0,"301_count":0,"301_rate":0.0,"301_percentage":0.0,"302_count":0,"302_rate":0.0,"302_percentage":0.0,"3xx_count":0,"3xx_rate":0.0,"3xx_percentage":0.0,"403_count":0,"403_rate":0.0,"403_percentage":0.0,"404_count":0,"404_rate":0.0,"404_percentage":0.0,"410_count":0,"410_rate":0.0,"410_percentage":0.0,"4xx_count":0,"4xx_rate":0.0,"4xx_percentage":0.0,"5xx_count":1,"5xx_rate":0.01,"5xx_percentage":100.0}
&lt;match count.apache.access&gt;
  @type datacounter
  unit minute
  outcast_unmatched false
  aggregate all
  tag threshold.apache.access
  count_key code
  pattern1 200 ^200$
  pattern2 2xx ^2\d\d$
  pattern3 301 ^301$
  pattern4 302 ^302$
  pattern5 3xx ^3\d\d$
  pattern6 403 ^403$
  pattern7 404 ^404$
  pattern8 410 ^410$
  pattern9 4xx ^4\d\d$
  pattern10 5xx ^5\d\d$
&lt;/match&gt;

# Determine threshold
# sample results: {"pattern":"code_500","target_tag":"apache.access","target_key":"5xx_count","check_type":"numeric_upward","level":"warn","threshold":1.0,"value":1.0,"message_time":"2014-01-28 16:47:39 +0900"}
&lt;match threshold.apache.access&gt;
  @type notifier
  input_tag_remove_prefix threshold
  &lt;def&gt;
    pattern code_500
    check numeric_upward
    warn_threshold  10
    crit_threshold  40
    tag alert.http_5xx_error
    target_key_pattern ^5xx_count$
  &lt;/def&gt;
&lt;/match&gt;

# Generate message
# sample results: {"message":"HTTP Status warn [5xx_count] apache.access: 1.0 (threshold 1.0)"}
&lt;match alert.http_5xx_error&gt;
  @type deparser
  tag irc.http_5xx_error&gt;
  format_key_names level,target_key,target_tag,value,threshold
  format HTTP Status %s [%s] %s: %s (threshold %s)
  key_name message
  reserve_data no
&lt;/match&gt;

# Send IRC message
&lt;match irc.http_5xx_error&gt;
  @type irc
  host localhost
  port 6667
  channel fluentd
  nick fluentd
  user fluentd
  real fluentd
  message %s
  out_keys message
&lt;/match&gt;

# Clear tag
&lt;match clear&gt;
  @type null
&lt;/match&gt;
</pre>
<a name="faq"></a><h2>FAQ</h2>
<a name="with-rewrite-tag-filter,-logs-are-not-forwarded.-why?"></a><h3>With rewrite-tag-filter, logs are not forwarded. Why?</h3>
<p>If you have following configuration, it doesn’t work:</p>
<pre class="CodeRay">&lt;match app.**&gt;
  @type rewrite_tag_filter
  &lt;rule&gt;
    key     level
    pattern (.+)
    tag     app.$1
  &lt;/rule&gt;
&lt;match&gt;

&lt;match app.**&gt;
  @type forward
  # ...
&lt;/match&gt;
</pre>
<p>In this case, <code>rewrite_tag_filter</code> causes infinite loop because fluentd’s routing is executed from top to bottom.
So you need to change tag like below:</p>
<pre class="CodeRay">&lt;match app.**&gt;
  @type rewrite_tag_filter
  &lt;rule&gt;
    key     level
    pattern (.+)
    tag     level.app.$1
  &lt;/rule&gt;
&lt;match&gt;

&lt;match level.app.**&gt;
  @type forward
  # ...
&lt;/match&gt;
</pre>
<div style="text-align:right">
  Last updated: 2016-12-08 03:25:57 UTC
  </div>
<hr size="1" style="margin-top: 10px; margin-bottom: 10px; color: rgba(0, 0, 0, .15);"/>
<div style="text-align:right">
Versions 
  
    
    | <a href="/v1.0/articles/out_rewrite_tag_filter">v1.0 (td-agent3)</a>
    
  

  

  
    
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