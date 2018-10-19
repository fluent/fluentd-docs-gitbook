<section id="main">
<div id="page">
<div class="topic_content">
<article>
<div style="text-align:right">
<div style="text-align:right">
Versions 
  
    
    | <a href="/v1.0/articles/out_forward">v1.0 (td-agent3)</a>
    
  

  

  
    
    | <b><i>v0.12</i> (td-agent2)<b>
</b></b>
</div>
</div>
<hr size="1" style="margin-top: 10px; margin-bottom: 10px; color: rgba(0, 0, 0, .15);"/>
<hgroup>
<h1>forward Output Plugin</h1>
</hgroup>
<p>The <code>out_forward</code> Buffered Output plugin forwards events to other fluentd nodes. This plugin supports load-balancing and automatic fail-over (a.k.a. active-active backup). For replication, please use the <a href="out_copy">out_copy</a> plugin.</p>
<p>The <code>out_forward</code> plugin detects server faults using a “φ accrual failure detector” algorithm. You can customize the parameters of the algorithm. When a server fault recovers, the plugin makes the server available automatically after a few seconds.</p>
<p>The <code>out_forward</code> plugin supports at-most-once and at-least-once semantics. The default is at-most-once.</p>
<table class="note">
<td class="icon"></td>
<td class="content">Do <b>NOT</b> use this plugin for inter-DC or public internet data transfer without secure connections. All the data is not encrypted, and this plugin is not designed for high-latency network environment. If you require a secure connection between nodes, please consider using <a href="in_secure_forward">in_secure_forward</a>.</td>
</table>
<a name="example-configuration"></a>
<section id="table-of-contents"><h3>Table of Contents</h3>
<ul id="toc">
<li class="toc-item"><a href="#example-configuration">Example Configuration</a></li>
<li class="toc-item"><a href="#parameters">Parameters</a></li>
<ul class="sub-toc">
<li class="sub-toc-item"><a href="#@type-(required)">@type (required)</a></li>
<li class="sub-toc-item"><a href="#&lt;server&gt;-(at-least-one-is-required)">&lt;server&gt; (at least one is required)</a></li>
<li class="sub-toc-item"><a href="#require_ack_response">require_ack_response</a></li>
<li class="sub-toc-item"><a href="#ack_response_timeout">ack_response_timeout</a></li>
<li class="sub-toc-item"><a href="#&lt;secondary&gt;-(optional)">&lt;secondary&gt; (optional)</a></li>
<li class="sub-toc-item"><a href="#send_timeout">send_timeout</a></li>
<li class="sub-toc-item"><a href="#recover_wait">recover_wait</a></li>
<li class="sub-toc-item"><a href="#heartbeat_type">heartbeat_type</a></li>
<li class="sub-toc-item"><a href="#heartbeat_interval">heartbeat_interval</a></li>
<li class="sub-toc-item"><a href="#phi_failure_detector">phi_failure_detector</a></li>
<li class="sub-toc-item"><a href="#phi_threshold">phi_threshold</a></li>
<li class="sub-toc-item"><a href="#hard_timeout">hard_timeout</a></li>
<li class="sub-toc-item"><a href="#standby">standby</a></li>
<li class="sub-toc-item"><a href="#expire_dns_cache">expire_dns_cache</a></li>
<li class="sub-toc-item"><a href="#dns_round_robin">dns_round_robin</a></li>
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
<li class="toc-item"><a href="#troubleshooting">Troubleshooting</a></li>
<ul class="sub-toc">
<li class="sub-toc-item"><a href="#%E2%80%9Cno-nodes-are-available%E2%80%9D">“no nodes are available”</a></li>
</ul>
</ul>
</section>
<h2>Example Configuration</h2>
<p><code>out_forward</code> is included in Fluentd’s core. No additional installation process is required.</p>
<pre class="CodeRay">&lt;match pattern&gt;
  @type forward
  send_timeout 60s
  recover_wait 10s
  hard_timeout 60s

  &lt;server&gt;
    name myserver1
    host 192.168.1.3
    port 24224
    weight 60
  &lt;/server&gt;
  &lt;server&gt;
    name myserver2
    host 192.168.1.4
    port 24224
    weight 60
  &lt;/server&gt;
  ...

  &lt;secondary&gt;
    @type file
    path /var/log/fluent/forward-failed
  &lt;/secondary&gt;
&lt;/match&gt;
</pre>
<table class="note">
<td class="icon"></td>
<td class="content">Please see the <a href="config-file">Config File</a> article for the basic structure and syntax of the configuration file.</td>
</table>
<a name="parameters"></a><h2>Parameters</h2>
<a name="@type-(required)"></a><h3>@type (required)</h3>
<p>The value must be <code>forward</code>.</p>
<a name="&lt;server&gt;-(at-least-one-is-required)"></a><h3>&lt;server&gt; (at least one is required)</h3>
<p>The destination servers. Each server must have following information.</p>
<ul>
<li>
<em>name</em>: The name of the server. This parameter is used in error messages.</li>
<li>
<em>host</em> (required): The IP address or host name of the server.</li>
<li>
<em>port</em>: The port number of the host. The default is <code>24224</code>. Note that both TCP packets (event stream) and UDP packets (heartbeat message) are sent to this port.</li>
<li>
<em>weight</em>: The load balancing weight. If the weight of one server is 20 and the weight of the other server is 30, events are sent in a 2:3 ratio. The default weight is 60.</li>
<li>
<em>standby</em>: Set the destination to standby node. The default is <code>false</code>. standby servers will be selected when all non-standby servers went down.</li>
</ul>
<a name="require_ack_response"></a><h3>require_ack_response</h3>
<p>Change the protocol to at-least-once. The plugin waits the ack from destination’s in_forward plugin.</p>
<a name="ack_response_timeout"></a><h3>ack_response_timeout</h3>
<p>This option is used when <code>require_ack_response</code> is <code>true</code>. The default is 190. This default value is based on popular tcp_syn_retries.</p>
<p>If set <code>0</code>, this plugin doesn’t wait the ack response.</p>
<a name="&lt;secondary&gt;-(optional)"></a><h3>&lt;secondary&gt; (optional)</h3>
<p>The backup destination that is used when all servers are unavailable.</p>
<a name="send_timeout"></a><h3>send_timeout</h3>
<p>The timeout time when sending event logs. The default is 60 seconds.</p>
<a name="recover_wait"></a><h3>recover_wait</h3>
<p>The wait time before accepting a server fault recovery. The default is 10 seconds.</p>
<a name="heartbeat_type"></a><h3>heartbeat_type</h3>
<p>The transport protocol to use for heartbeats. The default is “udp”, but you can select “tcp” as well. Set “none” to disable heartbeat.</p>
<a name="heartbeat_interval"></a><h3>heartbeat_interval</h3>
<p>The interval of the heartbeat packer. The default is 1 second.</p>
<a name="phi_failure_detector"></a><h3>phi_failure_detector</h3>
<p>Use the “Phi accrual failure detector” to detect server failure. The default value is <code>true</code>.</p>
<a name="phi_threshold"></a><h3>phi_threshold</h3>
<p>The threshold parameter used to detect server faults. The default value is 16.</p>
<table class="note">
<td class="icon"></td>
<td class="content">`phi_threshold` is deeply related to `heartbeat_interval`. If you are using longer `heartbeat_interval`, please use the larger `phi_threshold`. Otherwise you will see frequent detachments of destination servers. The default value 16 is tuned for `heartbeat_interval` 1s.</td>
</table>
<a name="hard_timeout"></a><h3>hard_timeout</h3>
<p>The hard timeout used to detect server failure. The default value is equal to the send_timeout parameter.</p>
<a name="standby"></a><h3>standby</h3>
<p>Marks a node as the standby node for an Active-Standby model between Fluentd nodes. When an active node goes down, the standby node is promoted to an active node. The standby node is not used by the <code>out_forward</code> plugin until then.</p>
<pre class="CodeRay">&lt;match pattern&gt;
  @type forward
  ...

  &lt;server&gt;
    name myserver1
    host 192.168.1.3
    weight 60
  &lt;/server&gt;
  &lt;server&gt;  # forward doesn't use myserver2 until myserver1 goes down
    name myserver2
    host 192.168.1.4
    weight 60
    standby
  &lt;/server&gt;
  ...
&lt;/match&gt;
</pre>
<a name="expire_dns_cache"></a><h3>expire_dns_cache</h3>
<p>Set TTL to expire DNS cache in seconds. Set 0 not to use DNS Cache. The default is nil (which means the persistent cache).</p>
<a name="dns_round_robin"></a><h3>dns_round_robin</h3>
<p>Enable client-side DNS round robin. Uniform randomly pick an IP address to send data when a hostname has serveral IP addresses.</p>
<table class="note">
<td class="icon"></td>
<td class="content">`heartbeat_type udp` is not available with `dns_round_robin true`. Use `heartbeat_type tcp` or `heartbeat_type none`. </td>
</table>
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
<a name="troubleshooting"></a><h2>Troubleshooting</h2>
<a name="%E2%80%9Cno-nodes-are-available%E2%80%9D"></a><h3>“no nodes are available”</h3>
<p>Please make sure that you can communicate with port 24224 using <strong>not only TCP, but also UDP</strong>. These commands will be useful for checking the network configuration.</p>
<pre class="CodeRay"><span class="comment">$</span><span class="function"> telnet host 24224
</span><span class="comment">$</span><span class="function"> nmap -p 24224 -sU host
</span></pre>
<p>Please note that there is one <a href="http://kb.vmware.com/selfservice/microsites/search.do?language=en_US&amp;cmd=displayKC&amp;externalId=2019944">known issue</a> where VMware will occasionally lose small UDP packets used for heartbeat.</p>
<div style="text-align:right">
  Last updated: 2015-12-01 21:20:32 UTC
  </div>
<hr size="1" style="margin-top: 10px; margin-bottom: 10px; color: rgba(0, 0, 0, .15);"/>
<div style="text-align:right">
Versions 
  
    
    | <a href="/v1.0/articles/out_forward">v1.0 (td-agent3)</a>
    
  

  

  
    
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