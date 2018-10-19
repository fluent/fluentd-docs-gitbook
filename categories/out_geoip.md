<section id="main">
<div id="page">
<div class="topic_content">
<article>
<div style="text-align:right">
<div style="text-align:right">
Versions 
  

  

  
    
    | <b><i>v0.12</i> (td-agent2)<b>
</b></b>
</div>
</div>
<hr size="1" style="margin-top: 10px; margin-bottom: 10px; color: rgba(0, 0, 0, .15);"/>
<hgroup>
<h1>GeoIP Output Plugin</h1>
</hgroup>
<p>The <code>out_geoip</code> Buffered Output plugin adds geographic location information to logs using the Maxmind GeoIP databases.</p>
<table class="note">
<td class="icon"></td>
<td class="content">This document doesn't describe all parameters. If you want to know full features, check the Further Reading section.</td>
</table>
<a name="prerequisites"></a>
<section id="table-of-contents"><h3>Table of Contents</h3>
<ul id="toc">
<li class="toc-item"><a href="#prerequisites">Prerequisites</a></li>
<li class="toc-item"><a href="#install">Install</a></li>
<li class="toc-item"><a href="#example-configuration">Example Configuration</a></li>
<li class="toc-item"><a href="#parameters">Parameters</a></li>
<ul class="sub-toc">
<li class="sub-toc-item"><a href="#geoip_lookup_key-(required)">geoip_lookup_key (required)</a></li>
<li class="sub-toc-item"><a href="#remove_tag_prefix-/-add_tag_prefix-(requires-one-or-the-other)">remove_tag_prefix / add_tag_prefix (requires one or the other)</a></li>
<li class="sub-toc-item"><a href="#enable_key_***-(requires-at-least-one)">enable_key_*** (requires at least one)</a></li>
<li class="sub-toc-item"><a href="#include_tag_key">include_tag_key</a></li>
<li class="sub-toc-item"><a href="#tag_key">tag_key</a></li>
</ul>
<li class="toc-item"><a href="#buffer-parameters">Buffer Parameters</a></li>
<ul class="sub-toc">
<li class="sub-toc-item"><a href="#buffer_type">buffer_type</a></li>
<li class="sub-toc-item"><a href="#buffer_queue_limit,-buffer_chunk_limit">buffer_queue_limit, buffer_chunk_limit</a></li>
<li class="sub-toc-item"><a href="#flush_interval">flush_interval</a></li>
</ul>
<li class="toc-item"><a href="#use-cases">Use Cases</a></li>
<li class="toc-item"><a href="#further-reading">Further Reading</a></li>
</ul>
</section>
<h2>Prerequisites</h2>
<ul>
<li>
<p>The GeoIP library.</p>
<p>  :::term
  # for RHEL/CentOS
  $ sudo yum install geoip-devel –enablerepo=epel</p>
<p>  # for Ubuntu/Debian
  $ sudo apt-get install libgeoip-dev</p>
<p>  # for MacOSX (brew)
  $ brew install geoip</p>
</li>
</ul>
<a name="install"></a><h2>Install</h2>
<p><code>out_geoip</code> is not included in td-agent. All users must install the fluent-plugin-geoip gem using the following command.</p>
<pre class="CodeRay"><span class="comment">$</span><span class="function"> fluent-gem install fluent-plugin-geoip
</span><span class="comment">$</span><span class="function"> sudo /usr/sbin/td-agent-gem install fluent-plugin-geoip
</span></pre>
<a name="example-configuration"></a><h2>Example Configuration</h2>
<p>The configuration shown below adds geolocation information to apache.access</p>
<pre class="CodeRay">&lt;match test.message&gt;
  @type geoip
  geoip_lookup_key        host
  enable_key_country_code geoip_country
  enable_key_city         geoip_city
  enable_key_latitude     geoip_lat
  enable_key_longitude    geoip_lon
  remove_tag_prefix       test.
  add_tag_prefix          geoip.
  flush_interval          5s
&lt;/match&gt;


:::text
# original record
test.message {
  "host":"66.102.9.80",
  "message":"test"
}

# output record
geoip.message: {
  "host":"66.102.9.80",
  "message":"test",
  "geoip_country":"US",
  "geoip_city":"Mountain View",
  "geoip_lat":37.4192008972168,
  "geoip_lon":-122.05740356445312
}
</pre>
<table class="note">
<td class="icon"></td>
<td class="content">Please see the <a href="https://github.com/y-ken/fluent-plugin-geoip#readme">fluent-plugin-geoip README</a> for further details.</td>
</table>
<a name="parameters"></a><h2>Parameters</h2>
<a name="geoip_lookup_key-(required)"></a><h3>geoip_lookup_key (required)</h3>
<p>Specifies the geoip lookup field (default: host)
If accessing a nested hash value, delimit the key with ‘.’, as in ‘host.ip’.</p>
<a name="remove_tag_prefix-/-add_tag_prefix-(requires-one-or-the-other)"></a><h3>remove_tag_prefix / add_tag_prefix (requires one or the other)</h3>
<p>Set tag replace rule.</p>
<a name="enable_key_***-(requires-at-least-one)"></a><h3>enable_key_*** (requires at least one)</h3>
<p>Specifies the geographic data that will be added to the record. The supported parameters are shown below:</p>
<ul>
<li>enable_key_city</li>
<li>enable_key_latitude</li>
<li>enable_key_longitude</li>
<li>enable_key_country_code3</li>
<li>enable_key_country_code</li>
<li>enable_key_country_name</li>
<li>enable_key_dma_code</li>
<li>enable_key_area_code</li>
<li>enable_key_region</li>
</ul>
<a name="include_tag_key"></a><h3>include_tag_key</h3>
<p>Set to <code>true</code> to include the original tag name in the record. (default: false)</p>
<a name="tag_key"></a><h3>tag_key</h3>
<p>Adds the tag name into the record using this value as the key name When <code>include_tag_key</code> is set to <code>true</code>.</p>
<a name="buffer-parameters"></a><h2>Buffer Parameters</h2>
<p>For advanced usage, you can tune Fluentd’s internal buffering mechanism with these parameters.</p>
<a name="buffer_type"></a><h3>buffer_type</h3>
<p>The buffer type is <code>memory</code> by default (<a href="buf_memory">buf_memory</a>). The <code>file</code> (<a href="buf_file">buf_file</a>) buffer type can be chosen as well. Unlike many other output plugins, the <code>buffer_path</code> parameter MUST be specified when using <code>buffer_type file</code>.</p>
<a name="buffer_queue_limit,-buffer_chunk_limit"></a><h3>buffer_queue_limit, buffer_chunk_limit</h3>
<p>The length of the chunk queue and the size of each chunk, respectively. Please see the <a href="buffer-plugin-overview">Buffer Plugin Overview</a> article for the basic buffer structure. The default values are 64 and 256m, respectively. The suffixes “k” (KB), “m” (MB), and “g” (GB) can be used for buffer_chunk_limit.</p>
<a name="flush_interval"></a><h3>flush_interval</h3>
<p>The interval between forced data flushes. The default is nil (don’t force flush and wait until the end of time slice + time_slice_wait). The suffixes “s” (seconds), “m” (minutes), and “h” (hours) can be used.</p>
<h4>log_level option</h4>
<p>The <code>log_level</code> option allows the user to set different levels of logging for each plugin. The supported log levels are: <code>fatal</code>, <code>error</code>, <code>warn</code>, <code>info</code>, <code>debug</code>, and <code>trace</code>.</p>
<p>Please see the <a href="logging">logging article</a> for further details.</p>
<a name="use-cases"></a><h2>Use Cases</h2>
<h4>Plot real time access statistics on a world map using Elasticsearch and Kibana</h4>
<p>The <code>country_code</code> field is needed to visualize access statistics on a world map using <a href="http://www.elasticsearch.org/overview/kibana/">Kibana</a>.</p>
<p>Note: The following plugins are required:
 * fluent-plugin-geoip
 * fluent-plugin-elasticsearch</p>
<pre class="CodeRay">&lt;match td.apache.access&gt;
  @type geoip

  # Set key name for the client ip address values
  geoip_lookup_key     host

  # Specify key name for the country_code values
  enable_key_country_code  geoip_country

  # Swap tag prefix from 'td.' to 'es.'
  remove_tag_prefix    td.
  add_tag_prefix       es.
&lt;/match&gt;

&lt;match es.apache.access&gt;
  @type            elasticsearch
  host            localhost
  port            9200
  type_name       apache
  logstash_format true
  flush_interval  10s
&lt;/match&gt;
</pre>
<a name="further-reading"></a><h2>Further Reading</h2>
<ul>
<li><a href="https://github.com/y-ken/fluent-plugin-geoip">fluent-plugin-geoip repository</a></li>
</ul>
<div style="text-align:right">
  Last updated: 2016-08-29 20:30:56 UTC
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
</article>
</div>
<!-- /#topic_content -->
</div>
<!-- /#page -->
</section>