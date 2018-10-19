<section id="main">
<div id="page">
<div class="topic_content">
<article>
<div style="text-align:right">
<div style="text-align:right">
Versions 
  
    
    | <a href="/v1.0/articles/out_mongo_replset">v1.0 (td-agent3)</a>
    
  

  

  
    
    | <b><i>v0.12</i> (td-agent2)<b>
</b></b>
</div>
</div>
<hr size="1" style="margin-top: 10px; margin-bottom: 10px; color: rgba(0, 0, 0, .15);"/>
<hgroup>
<h1>MongoDB ReplicaSet Output Plugin</h1>
</hgroup>
<p>The <code>out_mongo_replset</code> Buffered Output plugin writes records into <a href="http://mongodb.org/">MongoDB</a>, the emerging document-oriented database system.</p>
<table class="note">
<td class="icon"></td>
<td class="content">This plugin is for users using ReplicaSet. If you are not using ReplicaSet, please see the <a href="out_mongo">out_mongo</a> article instead.</td>
</table>
<a name="why-fluentd-with-mongodb?"></a>
<section id="table-of-contents"><h3>Table of Contents</h3>
<ul id="toc">
<li class="toc-item"><a href="#why-fluentd-with-mongodb?">Why Fluentd with MongoDB?</a></li>
<li class="toc-item"><a href="#install">Install</a></li>
<li class="toc-item"><a href="#example-configuration">Example Configuration</a></li>
<li class="toc-item"><a href="#parameters">Parameters</a></li>
<ul class="sub-toc">
<li class="sub-toc-item"><a href="#type-(required)">type (required)</a></li>
<li class="sub-toc-item"><a href="#nodes-(required)">nodes (required)</a></li>
<li class="sub-toc-item"><a href="#database-(required)">database (required)</a></li>
<li class="sub-toc-item"><a href="#collection-(required-if-not-tag_mapped)">collection (required if not tag_mapped)</a></li>
<li class="sub-toc-item"><a href="#capped">capped</a></li>
<li class="sub-toc-item"><a href="#capped_size">capped_size</a></li>
<li class="sub-toc-item"><a href="#user">user</a></li>
<li class="sub-toc-item"><a href="#password">password</a></li>
<li class="sub-toc-item"><a href="#tag_mapped">tag_mapped</a></li>
<li class="sub-toc-item"><a href="#name">name</a></li>
<li class="sub-toc-item"><a href="#read">read</a></li>
<li class="sub-toc-item"><a href="#refresh_mode">refresh_mode</a></li>
<li class="sub-toc-item"><a href="#refresh_interval">refresh_interval</a></li>
<li class="sub-toc-item"><a href="#num_retries">num_retries</a></li>
</ul>
<li class="toc-item"><a href="#buffered-output-parameters">Buffered Output Parameters</a></li>
<ul class="sub-toc">
<li class="sub-toc-item"><a href="#buffer_type">buffer_type</a></li>
<li class="sub-toc-item"><a href="#buffer_queue_limit,-buffer_chunk_limit">buffer_queue_limit, buffer_chunk_limit</a></li>
<li class="sub-toc-item"><a href="#flush_interval">flush_interval</a></li>
<li class="sub-toc-item"><a href="#flush_at_shutdown">flush_at_shutdown</a></li>
<li class="sub-toc-item"><a href="#retry_wait,-max_retry_wait">retry_wait, max_retry_wait</a></li>
<li class="sub-toc-item"><a href="#retry_limit,-disable_retry_limit">retry_limit, disable_retry_limit</a></li>
<li class="sub-toc-item"><a href="#num_threads">num_threads</a></li>
<li class="sub-toc-item"><a href="#slow_flush_log_threshold">slow_flush_log_threshold</a></li>
</ul>
<li class="toc-item"><a href="#further-readings">Further Readings</a></li>
</ul>
</section>
<h2>Why Fluentd with MongoDB?</h2>
<p>Fluentd enables your apps to insert records to MongoDB asynchronously with batch-insertion, unlike direct insertion of records from your apps. This has the following advantages:</p>
<ol>
<li>less impact on application performance</li>
<li>higher MongoDB insertion throughput while maintaining JSON record structure</li>
</ol>
<a name="install"></a><h2>Install</h2>
<p><code>out_mongo_replset</code> is included in td-agent by default. Fluentd gem users will need to install the fluent-plugin-mongo gem using the following command.</p>
<pre class="CodeRay"><span class="comment">$</span><span class="function"> fluent-gem install fluent-plugin-mongo
</span></pre>
<a name="example-configuration"></a><h2>Example Configuration</h2>
<pre class="CodeRay"># Single MongoDB
&lt;match mongo.**&gt;
  @type mongo_replset
  database fluentd
  collection test
  nodes localhost:27017,localhost:27018,localhost:27019

  # flush
  flush_interval 10s
&lt;/match&gt;
</pre>
<p>Please see the <a href="apache-to-mongodb">Store Apache Logs into MongoDB</a> article for real-world use cases.</p>
<table class="note">
<td class="icon"></td>
<td class="content">Please see the <a href="config-file">Config File</a> article for the basic structure and syntax of the configuration file.</td>
</table>
<a name="parameters"></a><h2>Parameters</h2>
<a name="type-(required)"></a><h3>type (required)</h3>
<p>The value must be <code>mongo</code>.</p>
<a name="nodes-(required)"></a><h3>nodes (required)</h3>
<p>The comma separated node strings (e.g. host1:27017,host2:27017,host3:27017).</p>
<a name="database-(required)"></a><h3>database (required)</h3>
<p>The database name.</p>
<a name="collection-(required-if-not-tag_mapped)"></a><h3>collection (required if not tag_mapped)</h3>
<p>The collection name.</p>
<a name="capped"></a><h3>capped</h3>
<p>This option enables capped collection. This is always recommended because MongoDB is not suited to storing large amounts of historical data.</p>
<a name="capped_size"></a><h3>capped_size</h3>
<p>Sets the capped collection size.</p>
<a name="user"></a><h3>user</h3>
<p>The username to use for authentication.</p>
<a name="password"></a><h3>password</h3>
<p>The password to use for authentication.</p>
<a name="tag_mapped"></a><h3>tag_mapped</h3>
<p>This option will allow out_mongo to use Fluentd’s tag to determine the destination collection.</p>
<p>For example, if you generate records with tags ‘mongo.foo’, the records will be inserted into the <code>foo</code> collection within the <code>fluentd</code> database.</p>
<pre class="CodeRay">&lt;match mongo.*&gt;
  @type mongo_replset
  database fluentd
  nodes localhost:27017,localhost:27018,localhost:27019

  # Set 'tag_mapped' if you want to use tag mapped mode.
  tag_mapped

  # If the tag is "mongo.foo", then the prefix "mongo." is removed.
  # The inserted collection name is "foo".
  remove_tag_prefix mongo.

  # This configuration is used if the tag is not found. The default is 'untagged'.
  collection misc
&lt;/match&gt;
</pre>
<a name="name"></a><h3>name</h3>
<p>The ReplicaSet name.</p>
<a name="read"></a><h3>read</h3>
<p>The ReplicaSet read preference (e.g. secondary, etc).</p>
<a name="refresh_mode"></a><h3>refresh_mode</h3>
<p>The ReplicaSet refresh mode (e.g. sync, etc).</p>
<a name="refresh_interval"></a><h3>refresh_interval</h3>
<p>The ReplicaSet refresh interval.</p>
<a name="num_retries"></a><h3>num_retries</h3>
<p>The ReplicaSet failover threshold. The default threshold is 60. If the retry count reaches this threshold, the plugin raises an exception.</p>
<a name="buffered-output-parameters"></a><h2>Buffered Output Parameters</h2>
<p>For advanced usage, you can tune Fluentd’s internal buffering mechanism with these parameters.</p>
<a name="buffer_type"></a><h3>buffer_type</h3>
<p>The buffer type is <code>memory</code> by default (<a href="buf_memory">buf_memory</a>) for the ease of testing, however <code>file</code> (<a href="buf_file">buf_file</a>) buffer type is always recommended for the production deployments. If you use <code>file</code> buffer type, <code>buffer_path</code> parameter is required.</p>
<a name="buffer_queue_limit,-buffer_chunk_limit"></a><h3>buffer_queue_limit, buffer_chunk_limit</h3>
<p>The length of the chunk queue and the size of each chunk, respectively. Please see the <a href="buffer-plugin-overview">Buffer Plugin Overview</a> article for the basic buffer structure. The default values are 64 and 8m, respectively. The suffixes “k” (KB), “m” (MB), and “g” (GB) can be used for buffer_chunk_limit.</p>
<a name="flush_interval"></a><h3>flush_interval</h3>
<p>The interval between data flushes. The default is 60s. The suffixes “s” (seconds), “m” (minutes), and “h” (hours) can be used.</p>
<a name="flush_at_shutdown"></a><h3>flush_at_shutdown</h3>
<p>If set to true, Fluentd waits for the buffer to flush at shutdown. By default, it is set to true for Memory Buffer and false for File Buffer.</p>
<a name="retry_wait,-max_retry_wait"></a><h3>retry_wait, max_retry_wait</h3>
<p>The initial and maximum intervals between write retries.  The default values are 1.0 seconds and unset (no limit).  The interval doubles (with +/-12.5% randomness) every retry until <code>max_retry_wait</code> is reached.</p>
<p>Since td-agent will retry 17 times before giving up by default (see the <code>retry_limit</code> parameter for details), the sleep interval can be up to approximately 131072 seconds (roughly 36 hours) in the default configurations.</p>
<a name="retry_limit,-disable_retry_limit"></a><h3>retry_limit, disable_retry_limit</h3>
<p>The limit on the number of retries before buffered data is discarded, and an
option to disable that limit (if true, the value of <code>retry_limit</code> is ignored and
there is no limit).  The default values are 17 and false (not disabled). If the limit is reached, buffered data is discarded and the retry interval is reset to its initial value (<code>retry_wait</code>).</p>
<a name="num_threads"></a><h3>num_threads</h3>
<p>The number of threads to flush the buffer. This option can be used to parallelize writes into the output(s) designated by the output plugin. Increasing the number of threads improves the flush throughput to hide write / network latency. The default is 1.</p>
<a name="slow_flush_log_threshold"></a><h3>slow_flush_log_threshold</h3>
<p>The threshold for checking chunk flush performance. The default value is <code>20.0</code> seconds. Note that parameter type is <code>float</code>, not <code>time</code>.</p>
<p>If chunk flush takes longer time than this threshold, fluentd logs warning message like below:</p>
<pre class="CodeRay">2016-12-19 12:00:00 +0000 [warn]: buffer flush took longer time than slow_flush_log_threshold: elapsed_time = 15.0031226690043695 slow_flush_log_threshold=10.0 plugin_id="foo"
</pre>
<h4>log_level option</h4>
<p>The <code>log_level</code> option allows the user to set different levels of logging for each plugin. The supported log levels are: <code>fatal</code>, <code>error</code>, <code>warn</code>, <code>info</code>, <code>debug</code>, and <code>trace</code>.</p>
<p>Please see the <a href="logging">logging article</a> for further details.</p>
<a name="further-readings"></a><h2>Further Readings</h2>
<ul>
<li><a href="https://github.com/fluent/fluent-plugin-mongo">fluent-plugin-webhdfs mongo</a></li>
</ul>
<div style="text-align:right">
  Last updated: 2015-12-01 21:20:32 UTC
  </div>
<hr size="1" style="margin-top: 10px; margin-bottom: 10px; color: rgba(0, 0, 0, .15);"/>
<div style="text-align:right">
Versions 
  
    
    | <a href="/v1.0/articles/out_mongo_replset">v1.0 (td-agent3)</a>
    
  

  

  
    
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