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
<h1>Secure Forward Output Plugin</h1>
</hgroup>
<p>The <code>out_secure_forward</code> output plugin sends messages via <strong>SSL with authentication</strong> (cf. <a href="in_secure_forward">in_secure_forward</a>).</p>
<table class="note">
<td class="icon"></td>
<td class="content">This document doesn't describe all parameters. If you want to know full features, check the Further Reading section.</td>
</table>
<a name="installation"></a>
<section id="table-of-contents"><h3>Table of Contents</h3>
<ul id="toc">
<li class="toc-item"><a href="#installation">Installation</a></li>
<li class="toc-item"><a href="#example-configurations">Example Configurations</a></li>
<ul class="sub-toc">
<li class="sub-toc-item"><a href="#minimalist-configuration">Minimalist Configuration</a></li>
<li class="sub-toc-item"><a href="#multiple-forward-destinations-over-ssl">Multiple Forward Destinations over SSL</a></li>
<li class="sub-toc-item"><a href="#secure-sender-receiver-setup">Secure Sender-Receiver Setup</a></li>
</ul>
<li class="toc-item"><a href="#parameters">Parameters</a></li>
<ul class="sub-toc">
<li class="sub-toc-item"><a href="#@type">@type</a></li>
<li class="sub-toc-item"><a href="#port-(integer)">port (integer)</a></li>
<li class="sub-toc-item"><a href="#bind-(string)">bind (string)</a></li>
<li class="sub-toc-item"><a href="#secure-(bool)">secure (bool)</a></li>
<li class="sub-toc-item"><a href="#ca_cert_path-(string)">ca_cert_path (string)</a></li>
<li class="sub-toc-item"><a href="#self_hostname-(string)">self_hostname (string)</a></li>
<li class="sub-toc-item"><a href="#shared_key-(string)">shared_key (string)</a></li>
<li class="sub-toc-item"><a href="#keepalive-(time)">keepalive (time)</a></li>
<li class="sub-toc-item"><a href="#send_timeout-(time)">send_timeout (time)</a></li>
<li class="sub-toc-item"><a href="#reconnect_interval-(time)">reconnect_interval (time)</a></li>
<li class="sub-toc-item"><a href="#read_length-(integer)">read_length (integer)</a></li>
<li class="sub-toc-item"><a href="#read_interval_msec-(integer)">read_interval_msec (integer)</a></li>
<li class="sub-toc-item"><a href="#socket_interval_msec-(integer)">socket_interval_msec (integer)</a></li>
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
<li class="toc-item"><a href="#further-reading">Further Reading</a></li>
</ul>
</section>
<h2>Installation</h2>
<p><code>out_secure_forward</code> is <strong>not</strong> included in either <code>td-agent</code> package or <code>fluentd</code> gem. In order to install it, please refer to the <a href="plugin-management">Plugin Management</a> article.</p>
<a name="example-configurations"></a><h2>Example Configurations</h2>
<p>This section provides some example configurations for <code>out_secure_forward</code>.</p>
<a name="minimalist-configuration"></a><h3>Minimalist Configuration</h3>
<p>At first, generate private CA file on side of input plugin by <code>secure-forward-ca-generate</code>, then copy that file to output plugin side by safe way (scp, or anyway else).</p>
<pre class="CodeRay">&lt;match secret.data.**&gt;
  @type secure_forward
  shared_key secret_string
  self_hostname client.fqdn.local
  secure true
  ca_cert_path /path/to/certificate/ca_cert.pem

  &lt;server&gt;
    host server.fqdn.local  # or IP
    # port 24284
  &lt;/server&gt;
&lt;/match&gt;
</pre>
<table class="note">
<td class="icon"></td>
<td class="content">Without hostname ACL (not yet implemented), `self_hostname` is not checked in any state. The `"#{Socket.gethostname}"` placeholder is available for such cases.</td>
</table>
<pre class="CodeRay">&lt;match secret.data.**&gt;
  @type secure_forward
  shared_key secret_string
  self_hostname "#{Socket.gethostname}"
  secure true
  ca_cert_path /path/to/certificate/ca_cert.pem

  &lt;server&gt;
    host server.fqdn.local  # or IP
    # port 24284
  &lt;/server&gt;
&lt;/match&gt;
</pre>
<a name="multiple-forward-destinations-over-ssl"></a><h3>Multiple Forward Destinations over SSL</h3>
<p>When two or more <code>&lt;server&gt;...&lt;/server&gt;</code> clauses are specified, <code>out_secure_forward</code> uses these server nodes in a round-robin order. The servers with <code>standby yes</code> are NOT selected until all non-standby servers go down.</p>
<table class="note">
<td class="icon"></td>
<td class="content">If a server requires username &amp; password, set `username` and `password` in the `<server>` section:</server>
</td>
</table>
<pre class="CodeRay">&lt;match secret.data.**&gt;
  @type secure_forward
  shared_key secret_string
  self_hostname client.fqdn.local
  secure true
  ca_cert_path /path/to/certificate/ca_cert.pem

  &lt;server&gt;
    host first.fqdn.local
    username repeatedly
    password sushi
  &lt;/server&gt;
  &lt;server&gt;
    host second.fqdn.local
    username sasatatsu
    password karaage
  &lt;/server&gt;
  &lt;server&gt;
    host standby.fqdn.local
    username kzk
    password hawaii
    standby  yes
  &lt;/server&gt;
&lt;/match&gt;
</pre>
<p>Use the <code>keepalive</code> parameter to specify keepalive timeouts. For example, the configuration below disconnects and re-connects its SSL connection every hour. By default, <code>keepalive</code> is set to 0 and the connection does NOT get disconnected unless there is a connection issue (This feature is for DNS name updates and refreshing SSL common keys).</p>
<pre class="CodeRay">&lt;match secret.data.**&gt;
  @type secure_forward
  shared_key secret_string
  self_hostname client.fqdn.local
  keepalive 3600
  secure true
  ca_cert_path /path/to/certificate/ca_cert.pem

  &lt;server&gt;
    host server.fqdn.local  # or IP
    # port 24284
  &lt;/server&gt;
&lt;/match&gt;
</pre>
<a name="secure-sender-receiver-setup"></a><h3>Secure Sender-Receiver Setup</h3>
<p>Example to send and receive several different kinds of logs (format is set to none for simplicity here).</p>
<h4>Sender</h4>
<pre class="CodeRay"># td-agent secured client (sender)

&lt;source&gt;
  @type tail
  path /appbase/logs/apache/apache_access_log
  pos_file /var/log/td-agent/tmp/apache.access.pos
  tag apache.access
  format none
&lt;/source&gt;

&lt;source&gt;
  @type tail
  path /appbase/logs/apache/apache_error_log
  pos_file /var/log/td-agent/tmp/apache.error.pos
  tag apache.error
  format none
&lt;/source&gt;

&lt;source&gt;
  @type tail
  path /appbase/logs/webapp/elastic_search.log
  pos_file /var/log/td-agent/tmp/elastic.search.pos
  tag elastic.search
  format none
&lt;/source&gt;

&lt;source&gt;
  @type tail
  path /appbase/logs/webapp/elastic_search_poller.log
  pos_file /var/log/td-agent/tmp/elastic.search.poller.pos
  tag elastic.poller
  format none
&lt;/source&gt;

&lt;source&gt;
  @type tail
  path /appbase/logs/webapp/ldap.log
  pos_file /var/log/td-agent/tmp/ldap.log.pos
  tag ldap.log
  format none
&lt;/source&gt;



#-- Application Logs

&lt;match apache.*&gt;
  @type copy
  &lt;store&gt;
    @type secure_forward
    shared_key Supers3cr3t
    allow_self_signed_certificate true
    self_hostname frontend01.dev.company.net
    secure true
    ca_cert_path /path/to/certificate/ca_cert.pem

    &lt;server&gt;
      host logserver01.prd.company.net
      port 2514
    &lt;/server&gt;
    &lt;server&gt;
      host logserver02.prd.company.net
      port 2514
    &lt;/server&gt;
  &lt;/store&gt;
&lt;/match&gt;

&lt;match elastic.*&gt;
  @type copy
  &lt;store&gt;
    @type secure_forward
    shared_key Supers3cr3t
    allow_self_signed_certificate true
    self_hostname frontend01.dev.company.net
    secure true
    ca_cert_path /path/to/certificate/ca_cert.pem

    &lt;server&gt;
      host logserver01.prd.company.net
      port 2514
    &lt;/server&gt;
    &lt;server&gt;
      host logserver02.prd.company.net
      port 2514
    &lt;/server&gt;
  &lt;/store&gt;
&lt;/match&gt;

&lt;match ldap.*&gt;
  @type copy
  &lt;store&gt;
    @type secure_forward
    shared_key Supers3cr3t
    allow_self_signed_certificate true
    self_hostname frontend01.dev.company.net
    secure true
    ca_cert_path /path/to/certificate/ca_cert.pem

    &lt;server&gt;
      host logserver01.prd.company.net
      port 2514
    &lt;/server&gt;
    &lt;server&gt;
      host logserver02.prd.company.net
      port 2514
    &lt;/server&gt;
  &lt;/store&gt;
&lt;/match&gt;

#-- NOTE for troubleshooting any actions afer "type copy",
#-- and receive more output in td-agent.log, add:
#--       &lt;store&gt;
#--           @type stdout
#--       &lt;/store&gt;


#-- Fluent Internal Logs

&lt;match **&gt;
  @type secure_forward
  shared_key Supers3cr3t
  self_hostname frontend01.dev.company.net
  flush_interval 8s
  secure true
  ca_cert_path /path/to/certificate/ca_cert.pem

  &lt;server&gt;
    host logserver01.prd.company.net
    port 2514
  &lt;/server&gt;
  &lt;server&gt;
    host logserver02.prd.company.net
    port 2514
  &lt;/server&gt;
&lt;/match&gt;
</pre>
<h4>Receiver</h4>
<pre class="CodeRay"># td-agent secured receiver (server)

&lt;source&gt;
  @type secure_forward
  shared_key         Supers3cr3t
  self_hostname      logserver01.prd.company.net
  port 2514
  secure true
  ca_cert_path        /path/to/certificate/ca_cert.pem
  ca_private_key_path /path/to/certificate/ca_key.pem
  ca_private_key_passphrase passphrase_for_private_CA_secret_key
&lt;/source&gt;


#-- Application Logs

&lt;match *.access&gt;
  @type file
  append true
  path /appbase/logs/received/access
  time_slice_format %Y%m%d
  time_slice_wait 5m
  time_format %Y%m%dT%H:%M:%S%z
&lt;/match&gt;

&lt;match *.error&gt;
  @type file
  append true
  path /appbase/logs/received/error
  time_slice_format %Y%m%d
  time_slice_wait 5m
  time_format %Y%m%dT%H:%M:%S%z
&lt;/match&gt;

&lt;match elastic.search&gt;
  @type file
  append true
  path /appbase/logs/received/elastic_search
  time_slice_format %Y%m%d
  time_slice_wait 5m
  time_format %Y%m%dT%H:%M:%S%z
&lt;/match&gt;

&lt;match elastic.poller&gt;
  @type file
  append true
  path /appbase/logs/received/elastic_search_poller
  time_slice_format %Y%m%d
  time_slice_wait 5m
  time_format %Y%m%dT%H:%M:%S%z
&lt;/match&gt;

&lt;match ldap.*&gt;
  @type file
  append true
  path /appbase/logs/received/ldap
  time_slice_format %Y%m%d
  time_slice_wait 5m
  time_format %Y%m%dT%H:%M:%S%z
&lt;/match&gt;


#-- Fluent Internal Logs

&lt;match fluent.info&gt;
  @type file
  append true
  path /appbase/logs/received/fluent-info
&lt;/match&gt;

&lt;match fluent.warn&gt;
  @type file
  append true
  path /appbase/logs/received/fluent-warn
&lt;/match&gt;
</pre>
<a name="parameters"></a><h2>Parameters</h2>
<a name="@type"></a><h3>@type</h3>
<p>This parameter is required. Its value must be <code>secure_forward</code>.</p>
<a name="port-(integer)"></a><h3>port (integer)</h3>
<p>The default value is 24284.</p>
<a name="bind-(string)"></a><h3>bind (string)</h3>
<p>The default value is 0.0.0.0.</p>
<a name="secure-(bool)"></a><h3>secure (bool)</h3>
<p>Indicate published connection is secure or not. Specify <code>yes</code> (or <code>true</code>) if secure encryption needed.</p>
<a name="ca_cert_path-(string)"></a><h3>ca_cert_path (string)</h3>
<p>The file path of private CA certificate file. This file must be shared with input plugin. The default is blank, but this parameter must be specified except for the case to use certificates signed by public CA.</p>
<a name="self_hostname-(string)"></a><h3>self_hostname (string)</h3>
<p>Default value of the auto-generated certificate common name (CN).</p>
<a name="shared_key-(string)"></a><h3>shared_key (string)</h3>
<p>Shared key between nodes..</p>
<a name="keepalive-(time)"></a><h3>keepalive (time)</h3>
<p>The duration for keepalive. If this parameter is not specified, keepalive is disabled.</p>
<a name="send_timeout-(time)"></a><h3>send_timeout (time)</h3>
<p>The send timeout value for sockets. The default value is 60 seconds.</p>
<a name="reconnect_interval-(time)"></a><h3>reconnect_interval (time)</h3>
<p>The interval between SSL reconnects. The default value is 5 seconds.</p>
<a name="read_length-(integer)"></a><h3>read_length (integer)</h3>
<p>The number of bytes read per nonblocking read. The default value is 8MB=8<em>1024</em>1024 bytes.</p>
<a name="read_interval_msec-(integer)"></a><h3>read_interval_msec (integer)</h3>
<p>The interval between the non-blocking reads, in milliseconds. The default value is 50.</p>
<a name="socket_interval_msec-(integer)"></a><h3>socket_interval_msec (integer)</h3>
<p>The interval between SSL reconnects in milliseconds. The default value is 200.</p>
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
<a name="further-reading"></a><h2>Further Reading</h2>
<ul>
<li><a href="https://github.com/tagomoris/fluent-plugin-secure-forward">fluent-plugin-secure-forward repository</a></li>
</ul>
<div style="text-align:right">
  Last updated: 2016-07-01 09:50:35 UTC
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