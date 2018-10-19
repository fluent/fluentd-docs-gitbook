<section id="main">
<div id="page">
<div class="topic_content">
<article>
<div style="text-align:right">
<div style="text-align:right">
Versions 
  
    
    | <a href="/v1.0/articles/filter_stdout">v1.0 (td-agent3)</a>
    
  

  

  
    
    | <b><i>v0.12</i> (td-agent2)<b>
</b></b>
</div>
</div>
<hr size="1" style="margin-top: 10px; margin-bottom: 10px; color: rgba(0, 0, 0, .15);"/>
<hgroup>
<h1>stdout Filter Plugin</h1>
</hgroup>
<p>The <code>filter_stdout</code> filter plugin prints events to stdout (or logs if launched
with daemon mode). This filter plugin is useful for debugging purposes.</p>
<a name="example-configurations"></a>
<section id="table-of-contents"><h3>Table of Contents</h3>
<ul id="toc">
<li class="toc-item"><a href="#example-configurations">Example Configurations</a></li>
<li class="toc-item"><a href="#parameters">Parameters</a></li>
<li class="toc-item"><a href="#learn-more">Learn More</a></li>
</ul>
</section>
<h2>Example Configurations</h2>
<p><code>filter_stdout</code> is included in Fluentd’s core. No installation required.</p>
<pre class="CodeRay">&lt;filter pattern&gt;
  @type stdout
&lt;/filter&gt;
</pre>
<p>A sample output is as follows:</p>
<pre class="CodeRay">2015-05-02 12:12:17 +0900 tag: {"field1":"value1","field2":"value2"}
</pre>
<p>where the first part shows the output time, the second part shows the tag,
and the third part shows the record.</p>
<table class="note">
<td class="icon"></td>
<td class="content">The first part shows the **output** time, not the time attribute
of message event structure as `out_stdout` does.</td>
</table>
<a name="parameters"></a><h2>Parameters</h2>
<h4>type (required)</h4>
<p>The value must be <code>stdout</code>.</p>
<h4>format</h4>
<p>The format of the output. The default is <code>stdout</code>.</p>
<h4>output_type</h4>
<p>This is the option of <code>stdout</code> format. Configure the format of record (third
part). Any formatter plugins can be specified. The default is <code>json</code>.</p>
<h4>out_file</h4>
<p>Output time, tag and json record separated by a delimiter:</p>
<pre class="CodeRay">time[delimiter]tag[delimiter]record\n
</pre>
<p>Example:</p>
<pre class="CodeRay">2014-06-08T23:59:40[TAB]file.server.logs[TAB]{"field1":"value1","field2":"value2"}\n
</pre>
<p><code>out_file</code> format has several options to customize the format.</p>
<pre class="CodeRay">delimiter SPACE   # Optional, SPACE or COMMA. "\t"(TAB) is used by default
output_tag false  # Optional, defaults to true. Output the tag field if true.
output_time true  # Optional, defaults to true. Output the time field if true.
</pre>
<p>For this format, the following common parameters are also supported.</p>
<ul>
<li>
<strong>include_time_key</strong> (Boolean, Optional, defaults to false)
If true, the time field (as specified by the <code>time_key</code> parameter) is kept in the record.</li>
<li>
<strong>time_key</strong> (String, Optional, defaults to “time”)
The field name for the time key.</li>
<li>
<strong>time_format</strong> (String. Optional)
By default, the output format is iso8601 (e.g. “2008-02-01T21:41:49”). One can specify their own format with this parameter.</li>
<li>
<strong>include_tag_key</strong> (Boolean. Optional, defaults to false)
If true, the tag field (as specified by the <code>tag_key</code> parameter) is kept in the record.</li>
<li>
<strong>tag_key</strong> (String, Optional, defaults to “tag”)
The field name for the tag key.</li>
<li>
<strong>localtime</strong> (Boolean. Optional, defaults to true)
If true, use local time. Otherwise, UTC is used. This parameter is overwritten by the <code>utc</code> parameter.</li>
<li>
<p><strong>timezone</strong> (String. Optional)
  By setting this parameter, one can parse the time value in the specified timezone. The following formats are accepted:</p>
<ol>
<li>[+-]HH:MM (e.g. “+09:00”)</li>
<li>[+-]HHMM (e.g. “+0900”)</li>
<li>[+-]HH (e.g. “+09”)</li>
<li>Region/Zone (e.g. “Asia/Tokyo”)</li>
<li>Region/Zone/Zone (e.g. “America/Argentina/Buenos_Aires”)</li>
</ol>
<p><strong>The timezone set in this parameter takes precedence over <code>localtime</code></strong>, e.g., if <code>localtime</code> is set to <code>true</code> but <code>timezone</code> is set to <code>+0000</code>, UTC would be used.</p>
</li>
</ul>
<h4>json</h4>
<p>Output a json record without the time or tag field:</p>
<pre class="CodeRay">{"field1":"value1","field2":"value2"}\n
</pre>
<p>For this format, the following common parameters are also supported.</p>
<ul>
<li>
<strong>include_time_key</strong> (Boolean, Optional, defaults to false)
If true, the time field (as specified by the <code>time_key</code> parameter) is kept in the record.</li>
<li>
<strong>time_key</strong> (String, Optional, defaults to “time”)
The field name for the time key.</li>
<li>
<strong>time_format</strong> (String. Optional)
By default, the output format is iso8601 (e.g. “2008-02-01T21:41:49”). One can specify their own format with this parameter.</li>
<li>
<strong>include_tag_key</strong> (Boolean. Optional, defaults to false)
If true, the tag field (as specified by the <code>tag_key</code> parameter) is kept in the record.</li>
<li>
<strong>tag_key</strong> (String, Optional, defaults to “tag”)
The field name for the tag key.</li>
<li>
<strong>localtime</strong> (Boolean. Optional, defaults to true)
If true, use local time. Otherwise, UTC is used. This parameter is overwritten by the <code>utc</code> parameter.</li>
<li>
<p><strong>timezone</strong> (String. Optional)
  By setting this parameter, one can parse the time value in the specified timezone. The following formats are accepted:</p>
<ol>
<li>[+-]HH:MM (e.g. “+09:00”)</li>
<li>[+-]HHMM (e.g. “+0900”)</li>
<li>[+-]HH (e.g. “+09”)</li>
<li>Region/Zone (e.g. “Asia/Tokyo”)</li>
<li>Region/Zone/Zone (e.g. “America/Argentina/Buenos_Aires”)</li>
</ol>
<p><strong>The timezone set in this parameter takes precedence over <code>localtime</code></strong>, e.g., if <code>localtime</code> is set to <code>true</code> but <code>timezone</code> is set to <code>+0000</code>, UTC would be used.</p>
</li>
</ul>
<h4>hash</h4>
<p>Output a record as ruby hash without the time or tag field:</p>
<pre class="CodeRay">{"field1"=&gt;"value1","field2"=&gt;"value2"}\n
</pre>
<p>For this format, the following common parameters are also supported.</p>
<ul>
<li>
<strong>include_time_key</strong> (Boolean, Optional, defaults to false)
If true, the time field (as specified by the <code>time_key</code> parameter) is kept in the record.</li>
<li>
<strong>time_key</strong> (String, Optional, defaults to “time”)
The field name for the time key.</li>
<li>
<strong>time_format</strong> (String. Optional)
By default, the output format is iso8601 (e.g. “2008-02-01T21:41:49”). One can specify their own format with this parameter.</li>
<li>
<strong>include_tag_key</strong> (Boolean. Optional, defaults to false)
If true, the tag field (as specified by the <code>tag_key</code> parameter) is kept in the record.</li>
<li>
<strong>tag_key</strong> (String, Optional, defaults to “tag”)
The field name for the tag key.</li>
<li>
<strong>localtime</strong> (Boolean. Optional, defaults to true)
If true, use local time. Otherwise, UTC is used. This parameter is overwritten by the <code>utc</code> parameter.</li>
<li>
<p><strong>timezone</strong> (String. Optional)
  By setting this parameter, one can parse the time value in the specified timezone. The following formats are accepted:</p>
<ol>
<li>[+-]HH:MM (e.g. “+09:00”)</li>
<li>[+-]HHMM (e.g. “+0900”)</li>
<li>[+-]HH (e.g. “+09”)</li>
<li>Region/Zone (e.g. “Asia/Tokyo”)</li>
<li>Region/Zone/Zone (e.g. “America/Argentina/Buenos_Aires”)</li>
</ol>
<p><strong>The timezone set in this parameter takes precedence over <code>localtime</code></strong>, e.g., if <code>localtime</code> is set to <code>true</code> but <code>timezone</code> is set to <code>+0000</code>, UTC would be used.</p>
</li>
</ul>
<h4>ltsv</h4>
<p>Output the record as <a href="http://ltsv.org">LTSV</a>:</p>
<pre class="CodeRay">field1[label_delimiter]value1[delimiter]field2[label_delimiter]value2\n
</pre>
<p><code>ltsv</code> format supports <code>delimiter</code> and <code>label_delimiter</code> options.</p>
<pre class="CodeRay">format ltsv
delimiter SPACE   # Optional. "\t"(TAB) is used by default
label_delimiter = # Optional. ":" is used by default
</pre>
<p>For this format, the following common parameters are also supported.</p>
<ul>
<li>
<strong>include_time_key</strong> (Boolean, Optional, defaults to false)
If true, the time field (as specified by the <code>time_key</code> parameter) is kept in the record.</li>
<li>
<strong>time_key</strong> (String, Optional, defaults to “time”)
The field name for the time key.</li>
<li>
<strong>time_format</strong> (String. Optional)
By default, the output format is iso8601 (e.g. “2008-02-01T21:41:49”). One can specify their own format with this parameter.</li>
<li>
<strong>include_tag_key</strong> (Boolean. Optional, defaults to false)
If true, the tag field (as specified by the <code>tag_key</code> parameter) is kept in the record.</li>
<li>
<strong>tag_key</strong> (String, Optional, defaults to “tag”)
The field name for the tag key.</li>
<li>
<strong>localtime</strong> (Boolean. Optional, defaults to true)
If true, use local time. Otherwise, UTC is used. This parameter is overwritten by the <code>utc</code> parameter.</li>
<li>
<p><strong>timezone</strong> (String. Optional)
  By setting this parameter, one can parse the time value in the specified timezone. The following formats are accepted:</p>
<ol>
<li>[+-]HH:MM (e.g. “+09:00”)</li>
<li>[+-]HHMM (e.g. “+0900”)</li>
<li>[+-]HH (e.g. “+09”)</li>
<li>Region/Zone (e.g. “Asia/Tokyo”)</li>
<li>Region/Zone/Zone (e.g. “America/Argentina/Buenos_Aires”)</li>
</ol>
<p><strong>The timezone set in this parameter takes precedence over <code>localtime</code></strong>, e.g., if <code>localtime</code> is set to <code>true</code> but <code>timezone</code> is set to <code>+0000</code>, UTC would be used.</p>
</li>
</ul>
<h4>single_value</h4>
<p>Output the value of a single field instead of the whole record. Often used in conjunction with <a href="in_tail">in_tail</a>’s <code>format none</code>.</p>
<pre class="CodeRay">value1\n
</pre>
<p><code>single_value</code> format supports the <code>add_newline</code> and <code>message_key</code> options.</p>
<pre class="CodeRay">add_newline false # Optional, defaults to true. If there is a trailing "\n" already, set it "false"
message_key my_field # Optional, defaults to "message". The value of this field is outputted.
</pre>
<h4>csv</h4>
<p>Output the record as CSV/TSV:</p>
<pre class="CodeRay">"value1"[delimiter]"value2"[delimiter]"value3"\n
</pre>
<p><code>csv</code> format supports the <code>delimiter</code> and <code>force_quotes</code> options.</p>
<pre class="CodeRay">format csv
fields field1,field2,field3
delimiter \t   # Optional. "," is used by default.
force_quotes false # Optional. true is used by default. If false, value won't be framed by quotes.
</pre>
<p>For this format, the following common parameters are also supported.</p>
<ul>
<li>
<strong>include_time_key</strong> (Boolean, Optional, defaults to false)
If true, the time field (as specified by the <code>time_key</code> parameter) is kept in the record.</li>
<li>
<strong>time_key</strong> (String, Optional, defaults to “time”)
The field name for the time key.</li>
<li>
<strong>time_format</strong> (String. Optional)
By default, the output format is iso8601 (e.g. “2008-02-01T21:41:49”). One can specify their own format with this parameter.</li>
<li>
<strong>include_tag_key</strong> (Boolean. Optional, defaults to false)
If true, the tag field (as specified by the <code>tag_key</code> parameter) is kept in the record.</li>
<li>
<strong>tag_key</strong> (String, Optional, defaults to “tag”)
The field name for the tag key.</li>
<li>
<strong>localtime</strong> (Boolean. Optional, defaults to true)
If true, use local time. Otherwise, UTC is used. This parameter is overwritten by the <code>utc</code> parameter.</li>
<li>
<p><strong>timezone</strong> (String. Optional)
  By setting this parameter, one can parse the time value in the specified timezone. The following formats are accepted:</p>
<ol>
<li>[+-]HH:MM (e.g. “+09:00”)</li>
<li>[+-]HHMM (e.g. “+0900”)</li>
<li>[+-]HH (e.g. “+09”)</li>
<li>Region/Zone (e.g. “Asia/Tokyo”)</li>
<li>Region/Zone/Zone (e.g. “America/Argentina/Buenos_Aires”)</li>
</ol>
<p><strong>The timezone set in this parameter takes precedence over <code>localtime</code></strong>, e.g., if <code>localtime</code> is set to <code>true</code> but <code>timezone</code> is set to <code>+0000</code>, UTC would be used.</p>
</li>
</ul>
<h4>stdout</h4>
<p>This format is aimed to be used by stdout plugins.</p>
<p>Output time, tag and formatted record as follows:</p>
<pre class="CodeRay">time tag: formatted_record\n
</pre>
<p>Example:</p>
<pre class="CodeRay">2015-05-02 12:12:17 +0900 tag: {"field1":"value1","field2":"value2"}\n
</pre>
<p><code>stdout</code> format has a following option to customize the format of the record
part.</p>
<pre class="CodeRay">output_type format # Optional, defaults to "json". The format of
`formatted_record`. Any formatter plugins can be specified.
</pre>
<p>For this format, the following common parameters are also supported.</p>
<ul>
<li>
<strong>include_time_key</strong> (Boolean, Optional, defaults to false)
If true, the time field (as specified by the <code>time_key</code> parameter) is kept in the record.</li>
<li>
<strong>time_key</strong> (String, Optional, defaults to “time”)
The field name for the time key.</li>
<li>
<strong>time_format</strong> (String. Optional)
By default, the output format is iso8601 (e.g. “2008-02-01T21:41:49”). One can specify their own format with this parameter.</li>
<li>
<strong>include_tag_key</strong> (Boolean. Optional, defaults to false)
If true, the tag field (as specified by the <code>tag_key</code> parameter) is kept in the record.</li>
<li>
<strong>tag_key</strong> (String, Optional, defaults to “tag”)
The field name for the tag key.</li>
<li>
<strong>localtime</strong> (Boolean. Optional, defaults to true)
If true, use local time. Otherwise, UTC is used. This parameter is overwritten by the <code>utc</code> parameter.</li>
<li>
<p><strong>timezone</strong> (String. Optional)
  By setting this parameter, one can parse the time value in the specified timezone. The following formats are accepted:</p>
<ol>
<li>[+-]HH:MM (e.g. “+09:00”)</li>
<li>[+-]HHMM (e.g. “+0900”)</li>
<li>[+-]HH (e.g. “+09”)</li>
<li>Region/Zone (e.g. “Asia/Tokyo”)</li>
<li>Region/Zone/Zone (e.g. “America/Argentina/Buenos_Aires”)</li>
</ol>
<p><strong>The timezone set in this parameter takes precedence over <code>localtime</code></strong>, e.g., if <code>localtime</code> is set to <code>true</code> but <code>timezone</code> is set to <code>+0000</code>, UTC would be used.</p>
</li>
</ul>
<h4>log_level option</h4>
<p>The <code>log_level</code> option allows the user to set different levels of logging for each plugin. The supported log levels are: <code>fatal</code>, <code>error</code>, <code>warn</code>, <code>info</code>, <code>debug</code>, and <code>trace</code>.</p>
<p>Please see the <a href="logging">logging article</a> for further details.</p>
<a name="learn-more"></a><h2>Learn More</h2>
<ul>
<li><a href="filter-plugin-overview">Filter Plugin Overview</a></li>
</ul>
<div style="text-align:right">
  Last updated: 2016-10-21 06:29:58 UTC
  </div>
<hr size="1" style="margin-top: 10px; margin-bottom: 10px; color: rgba(0, 0, 0, .15);"/>
<div style="text-align:right">
Versions 
  
    
    | <a href="/v1.0/articles/filter_stdout">v1.0 (td-agent3)</a>
    
  

  

  
    
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