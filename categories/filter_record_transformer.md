<section id="main">
<div id="page">
<div class="topic_content">
<article>
<div style="text-align:right">
<div style="text-align:right">
Versions 
  
    
    | <a href="/v1.0/articles/filter_record_transformer">v1.0 (td-agent3)</a>
    
  

  

  
    
    | <b><i>v0.12</i> (td-agent2)<b>
</b></b>
</div>
</div>
<hr size="1" style="margin-top: 10px; margin-bottom: 10px; color: rgba(0, 0, 0, .15);"/>
<hgroup>
<h1>record_transformer Filter Plugin</h1>
</hgroup>
<p>The <code>filter_record_transformer</code> filter plugin mutates/transforms incoming event streams in a versatile manner. If there is a need to add/delete/modify events, this plugin is the first filter to try.</p>
<a name="example-configurations"></a>
<section id="table-of-contents"><h3>Table of Contents</h3>
<ul id="toc">
<li class="toc-item"><a href="#example-configurations">Example Configurations</a></li>
<li class="toc-item"><a href="#parameters">Parameters</a></li>
<ul class="sub-toc">
<li class="sub-toc-item"><a href="#&lt;record&gt;-directive">&lt;record&gt; directive</a></li>
<li class="sub-toc-item"><a href="#enable_ruby-(optional)">enable_ruby (optional)</a></li>
<li class="sub-toc-item"><a href="#auto_typecast-(optional)">auto_typecast (optional)</a></li>
<li class="sub-toc-item"><a href="#renew_record-(optional)">renew_record (optional)</a></li>
<li class="sub-toc-item"><a href="#renew_time_key-(optional,-string-type)">renew_time_key (optional, string type)</a></li>
<li class="sub-toc-item"><a href="#keep_keys-(optional,-array-type)">keep_keys (optional, array type)</a></li>
<li class="sub-toc-item"><a href="#remove_keys-(optional,-array-type)">remove_keys (optional, array type)</a></li>
</ul>
<li class="toc-item"><a href="#need-more-performance?">Need more performance?</a></li>
<li class="toc-item"><a href="#faq">FAQ</a></li>
<li class="toc-item"><a href="#learn-more">Learn More</a></li>
</ul>
</section>
<h2>Example Configurations</h2>
<p><code>filter_record_transformer</code> is included in Fluentd’s core. No installation required.</p>
<pre class="CodeRay">&lt;filter foo.bar&gt;
  @type record_transformer
  &lt;record&gt;
    hostname "#{Socket.gethostname}"
    tag ${tag}
  &lt;/record&gt;
&lt;/filter&gt;
</pre>
<p>The above filter adds the new field “hostname” with the server’s hostname as its value (It is taking advantage of Ruby’s string interpolation) and the new field “tag” with tag value. So, an input like</p>
<pre class="CodeRay">{"message":"hello world!"}
</pre>
<p>is transformed into</p>
<pre class="CodeRay">{"message":"hello world!", "hostname":"db001.internal.example.com", "tag":"foo.bar"}
</pre>
<p>Here is another example where the field “total” is divided by the field “count” to create a new field “avg”:</p>
<pre class="CodeRay">&lt;filter foo.bar&gt;
  @type record_transformer
  enable_ruby
  &lt;record&gt;
    avg ${record["total"] / record["count"]}
  &lt;/record&gt;
&lt;/filter&gt;
</pre>
<p>It transforms an event like</p>
<pre class="CodeRay">{"total":100, "count":10}
</pre>
<p>into</p>
<pre class="CodeRay">{"total":100, "count":10, "avg":"10"}
</pre>
<p>With the <code>enable_ruby</code> option, an arbitrary Ruby expression can be used inside <code>${...}</code>. Note that the “avg” field is typed as string in this example. You may use <code>auto_typecast true</code> option to treat the field as a float.</p>
<p>You can also use this plugin to modify your existing fields as</p>
<pre class="CodeRay">&lt;filter foo.bar&gt;
  @type record_transformer
  &lt;record&gt;
    message yay, ${record["message"]}
  &lt;/record&gt;
&lt;/filter&gt;
</pre>
<p>An input like</p>
<pre class="CodeRay">{"message":"hello world!"}
</pre>
<p>is transformed into</p>
<pre class="CodeRay">{"message":"yay, hello world!"}
</pre>
<p>Finally, this configuration embeds the value of the second part of the tag in the field “service_name”. It might come in handy when aggregating data across many services.</p>
<pre class="CodeRay">&lt;filter web.*&gt;
  @type record_transformer
  &lt;record&gt;
    service_name ${tag_parts[1]}
  &lt;/record&gt;
&lt;/filter&gt;
</pre>
<p>So, if an event with the tag “web.auth” and record <code>{"user_id":1, "status":"ok"}</code> comes in, it transforms it into <code>{"user_id":1, "status":"ok", "service_name":"auth"}</code>.</p>
<a name="parameters"></a><h2>Parameters</h2>
<a name="&lt;record&gt;-directive"></a><h3>&lt;record&gt; directive</h3>
<p>Parameters inside <code>&lt;record&gt;</code> directives are considered to be new key-value pairs:</p>
<pre class="CodeRay">&lt;record&gt;
  NEW_FIELD NEW_VALUE
&lt;/record&gt;
</pre>
<p>For NEW_FIELD and NEW_VALUE, a special syntax <code>${}</code> allows the user to generate a new field dynamically. Inside the curly braces, the following variables are available:</p>
<ul>
<li>The incoming event’s existing values can be referred by their field names. So, if the record is <code>{"total":100, "count":10}</code>, then <code>record["total"]=100</code> and <code>record["count"]=10</code>.</li>
<li>
<code>tag</code> refers to the whole tag.</li>
<li>
<code>time</code> refers to stringanized event time.</li>
<li>
<code>hostname</code> refers to machine’s hostname. The actual value is result of <a href="https://docs.ruby-lang.org/en/trunk/Socket.html#method-c-gethostname">Socket.gethostname</a>.</li>
</ul>
<p>You can also access to a certain potion of a tag using the following notations:</p>
<ul>
<li>
<code>tag_parts[N]</code> refers to the Nth part of the tag.</li>
<li>
<code>tag_prefix[N]</code> refers to the [0..N] part of the tag.</li>
<li>
<code>tag_suffix[N]</code> refers to the [N..] part of the tag.</li>
</ul>
<p>All indices are zero-based. For example, if you have an incoming event tagged <code>debug.my.app</code>, then <code>tag_parts[1]</code> will represent “my”. Also in this case, <code>tag_prefix[N]</code> and <code>tag_suffix[N]</code> will work as follows:</p>
<pre class="CodeRay">tag_prefix[0] = debug          tag_suffix[0] = debug.my.app
tag_prefix[1] = debug.my       tag_suffix[1] = my.app
tag_prefix[2] = debug.my.app   tag_suffix[2] = app
</pre>
<a name="enable_ruby-(optional)"></a><h3>enable_ruby (optional)</h3>
<p>When set to true, the full Ruby syntax is enabled in the <code>${...}</code> expression. The default value is false.</p>
<p>With <code>true</code>, additional variables could be used inside <code>${}</code>.</p>
<ul>
<li>
<code>record</code> refers to the whole record.</li>
<li>
<code>time</code> refers to event time as Time object, not stringanized event time.</li>
</ul>
<p>Here is the examples:</p>
<pre class="CodeRay">jsonized_record ${record.to_json}
avg ${record["total"] / record["count"]}
formatted_time ${time.strftime('%Y-%m-%dT%H:%M:%S%z')}
escaped_tag ${tag.gsub('.', '-')}
last_tag ${tag_parts.last}
foo_${record["key"]} bar_${record["value"]}
</pre>
<a name="auto_typecast-(optional)"></a><h3>auto_typecast (optional)</h3>
<p>Automatically cast the field types. Default is false.</p>
<p>LIMITATION: This option is effective only for field values comprised of a single placeholder.</p>
<p>Effective Examples:</p>
<pre class="CodeRay">foo ${record["foo"]}
</pre>
<p>Non-Effective Examples:</p>
<pre class="CodeRay">foo ${record["foo"]}${record["bar"]}
foo ${record["foo"]}bar
foo 1
</pre>
<p>Internally, this keeps the original value type only when a single placeholder is used.</p>
<a name="renew_record-(optional)"></a><h3>renew_record (optional)</h3>
<p>By default, the record transformer filter mutates the incoming data. However, if this parameter is set to true, it modifies a new empty hash instead.</p>
<a name="renew_time_key-(optional,-string-type)"></a><h3>renew_time_key (optional, string type)</h3>
<p><code>renew_time_key foo</code> overwrites the time of events with a value of the record field <code>foo</code> if exists. The value of <code>foo</code> must be a unix time.</p>
<a name="keep_keys-(optional,-array-type)"></a><h3>keep_keys (optional, array type)</h3>
<p>A list of keys to keep. Only relevant if <code>renew_record</code> is set to true.</p>
<a name="remove_keys-(optional,-array-type)"></a><h3>remove_keys (optional, array type)</h3>
<p>A list of keys to delete.</p>
<a name="need-more-performance?"></a><h2>Need more performance?</h2>
<p><a href="https://github.com/repeatedly/fluent-plugin-record-modifier">filter_record_modifier</a> is light-weight and faster version of <code>filter_record_transformer</code>. <code>filter_record_modifier</code> doesn’t provide several <code>filter_record_transformer</code> features, but it covers popular cases. If you need better performace for mutating records, consider <code>filter_record_modifier</code> instead.</p>
<a name="faq"></a><h2>FAQ</h2>
<h3>What are the differences between <code>${record["key"]}</code> and <code>${key}</code>?</h3>
<p><code>${key}</code> is short-cut for <code>${record["key"]}</code>. This is error prone because <code>${tag}</code> is unclear for event tag or <code>record["tag"]</code>.
So the <code>${key}</code> syntax is now deprecated for avoiding this problem. Don’t use <code>${key}</code> short-cut syntax on the production.</p>
<p>Since v0.14, <code>${key}</code> short-cut syntax is removed.</p>
<a name="learn-more"></a><h2>Learn More</h2>
<ul>
<li><a href="filter-plugin-overview">Filter Plugin Overview</a></li>
</ul>
<div style="text-align:right">
  Last updated: 2017-03-28 08:14:54 UTC
  </div>
<hr size="1" style="margin-top: 10px; margin-bottom: 10px; color: rgba(0, 0, 0, .15);"/>
<div style="text-align:right">
Versions 
  
    
    | <a href="/v1.0/articles/filter_record_transformer">v1.0 (td-agent3)</a>
    
  

  

  
    
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