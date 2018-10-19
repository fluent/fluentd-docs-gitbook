<article>
<div style="text-align:right">
<div style="text-align:right">
Versions 
  
    
    | <a href="/v1.0/articles/buffer-plugin-overview">v1.0 (td-agent3)</a>
    
  

  

  
    
    | <b><i>v0.12</i> (td-agent2)<b>
</b></b>
</div>
</div>
<hr size="1" style="margin-top: 10px; margin-bottom: 10px; color: rgba(0, 0, 0, .15);"/>
<hgroup>
<h1>Buffer Plugin Overview</h1>
</hgroup>
<p>Fluentd has 6 types of plugins: <a href="input-plugin-overview">Input</a>, <a href="parser-plugin-overview">Parser</a>, <a href="filter-plugin-overview">Filter</a>, <a href="output-plugin-overview">Output</a>, <a href="formatter-plugin-overview">Formatter</a> and <a href="buffer-plugin-overview">Buffer</a>. This article will provide a high-level overview of Buffer plugins.</p>
<a name="buffer-plugin-overview"></a>
<section id="table-of-contents"><h3>Table of Contents</h3>
<ul id="toc">
<li class="toc-item"><a href="#buffer-plugin-overview">Buffer Plugin Overview</a></li>
<li class="toc-item"><a href="#buffer-structure">Buffer Structure</a></li>
<ul class="sub-toc">
<li class="sub-toc-item"><a href="#common-parameters">Common Parameters</a></li>
<li class="sub-toc-item"><a href="#handling-queue-overflow">Handling queue overflow</a></li>
<li class="sub-toc-item"><a href="#handling-write-failures">Handling write failures</a></li>
</ul>
<li class="toc-item"><a href="#slicing-data-by-time">Slicing Data by Time</a></li>
<ul class="sub-toc">
<li class="sub-toc-item"><a href="#faq">FAQ</a></li>
</ul>
<li class="toc-item"><a href="#list-of-buffer-plugins">List of Buffer Plugins</a></li>
</ul>
</section>
<h2>Buffer Plugin Overview</h2>
<p>Buffer plugins are used by output plugins. For example, <code>out_s3</code> uses <code>buf_file</code> plugin by default to store incoming stream temporally before transmitting to S3.</p>
<p>Buffer plugins are, as you can tell by the name, <em>pluggable</em>. So you can choose a suitable backend based on your system requirements.</p>
<a name="buffer-structure"></a><h2>Buffer Structure</h2>
<p>A buffer is essentially a set of “chunks”. A chunk is a collection of records concatenated into a single blob. Chunks are periodically flushed to the output queue and then sent to the specified destination. Here is the diagram of how it works:</p>
<div>
<a href="/images/buffer-internal-and-parameters.png">
<img src="/images/buffer-internal-and-parameters.png" style="width: 100%;"/>
</a>
</div>
<a name="common-parameters"></a><h3>Common Parameters</h3>
<p>Buffer plugins allow fine-grained controls over the buffering behaviours through config options.</p>
<h4><code>buffer_type</code></h4>
<ul>
<li>This option specifies which plugin to use as the backend.</li>
<li>In default installations, supported values are <code>file</code> and <code>memory</code>.</li>
</ul>
<h4><code>buffer_chunk_limit</code></h4>
<ul>
<li>The maximum size of a chunk allowed (default: 8MB)</li>
<li>If a chunk grows more than the limit, it gets flushed to the output queue automatically.</li>
</ul>
<h4><code>buffer_queue_limit</code></h4>
<ul>
<li>The maximum length of the output queue (default: 256)</li>
<li>If the limit gets exceeded, Fluentd will invoke an error handling mechanism (See “Handling queue overflow” below for details).</li>
</ul>
<h4><code>flush_interval</code></h4>
<ul>
<li>The interval in seconds to wait before invoking the next buffer flush (default: 60)</li>
</ul>
<a name="handling-queue-overflow"></a><h3>Handling queue overflow</h3>
<p>The <code>buffer_queue_full_action</code> option controls the behaviour when the queue becomes full. For now, three modes are supported:</p>
<ol>
<li>
<em>exception</em> (default)

<ul>
<li>This mode raises a <code>BufferQueueLimitError</code> exception to the input plugin.</li>
<li>This mode is suitable for data streaming.</li>
<li>It’s up to the input plugin to decide how to handle raised exceptions.</li>
</ul>
</li>
<li>
<em>block</em>
<ul>
<li>This mode blocks the thread until the free space is vacated.</li>
<li>This mode is good for batch-like use-case.</li>
<li>DO NOT use this option casually just for avoiding <code>BufferQueueLimitError</code> exceptions (see the deployment tips below).</li>
</ul>
</li>
<li>
<em>drop_oldest_chunk</em>
<ul>
<li>This mode drops the oldest chunks.</li>
<li>This mode might be useful for monitoring systems, since newer events are much more important than the older ones in this context.</li>
</ul>
</li>
</ol>
<h4>Deployment tips</h4>
<p>If your Fluentd daemon experiences overflows frequently, it means that your destination is insufficient for your traffic. There are several measures you can take:</p>
<ol>
<li>Upgrade the destination node to provide enough data-processing capacity.</li>
<li>Use an <code>@ERROR</code> label to route overflowed events to another backup destination.</li>
<li>Use a <code>&lt;secondary&gt;</code> tag to route overflowed events to another backup destination.</li>
</ol>
<a name="handling-write-failures"></a><h3>Handling write failures</h3>
<p>The chunks in the output queue are written out to the destination one by one. However, the problem is that there might occur an error while writing out a chunk. For such cases, buffer plugins are equipped with a “retry” mechanism that handles write failures gracefully.</p>
<p>Here is how it works. If Fluentd fails to write out a chunk, the chunk will not be purged from the queue, and then, after a certain interval, Fluentd will retry to write the chunk again. The intervals between retry attempts are determined by the exponential backoff algorithm, and we can control the behaviour finely through the following options:</p>
<h4><code>retry_limit</code></h4>
<ul>
<li>The maximum number of retries for sending a chunk (default: 17)</li>
<li>If <code>retry_limit</code> is exceeded, Fluentd will discard the given chunk.</li>
</ul>
<h4><code>disable_retry_limit</code></h4>
<ul>
<li>If set true, it disables <code>retry_limit</code> and make Fluentd retry indefinitely (default: false).</li>
</ul>
<h4><code>retry_wait</code></h4>
<ul>
<li>The number of seconds the first retry will wait (default: 1.0)</li>
<li>This is the seed value used by the exponential backoff algorithm; The wait interval will be doubled on each retry.</li>
</ul>
<h4><code>max_retry_wait</code></h4>
<ul>
<li>The maximum interval seconds to wait between retries (default: unset)</li>
<li>If the wait interval reaches this limit, the exponentiation stops.</li>
</ul>
<a name="slicing-data-by-time"></a><h2>Slicing Data by Time</h2>
<p>Buffer plugins support a special mode that groups the incoming data by time frames. For example, you can group the incoming access logs by date and save them to separate files. Under this mode, a buffer plugin will behave quite differently in a few key aspects:</p>
<ol>
<li>It supports the additional <code>time_slice_*</code> options (See Q1/Q2 below for details)</li>
<li>Chunks will be flushed “lazily” based on the settings of the <code>time_slice_format</code> option. See Q2 for the relationship of this option and <code>flush_interval</code>.</li>
<li>The default value of <code>buffer_chunk_limit</code> becomes 256mb.</li>
</ol>
<p>Normally, the output plugin determines in which mode the buffer plugin operates. For example, <code>out_s3</code> and <code>out_file</code> will enable the time-slicing mode. For the list of output plugins which enable the time-slicing mode, see <a href="output-plugin-overview#list-of-time-sliced-output-plugins">this page</a>.</p>
<a name="faq"></a><h3>FAQ</h3>
<h4>Q1. How do we specify the granularity of time chunks?</h4>
<p>This is done through the <code>time_slice_format</code> option, which is set to “%Y%m%d” (daily) by default. If you want your chunks to be hourly, “%Y%m%d%H” will do the job.</p>
<h4>Q2. What if new logs come after the time corresponding the current chunk?</h4>
<p>For example, what happens to an event, timestamped at 2013-01-01 02:59:45 UTC, comes in at 2013-01-01 03:00:15 UTC? Would it make into the 2013-01-01 02:00:00-02:59:59 chunk?</p>
<p>This issue is addressed by setting the <code>time_slice_wait</code> parameter. <code>time_slice_wait</code> sets, in seconds, how long fluentd waits to accept “late” events into the chunk <em>past the max time corresponding to that chunk</em>. The default value is 600, which means it waits for 10 minutes before moving on. So, in the current example, as long as the events come in before 2013-01-01 03:10:00, it will make it in to the 2013-01-01 02:00:00-02:59:59 chunk.</p>
<p>Alternatively, you can also flush the chunks regularly using <code>flush_interval</code>. Note that <code>flush_interval</code> and <code>time_slice_wait</code> are mutually exclusive. If you set <code>flush_interval</code>, <code>time_slice_wait</code> will be ignored and fluentd would issue a warning.</p>
<a name="list-of-buffer-plugins"></a><h2>List of Buffer Plugins</h2>
<ul>
<li><a href="buf_memory">buf_memory</a></li>
<li><a href="buf_file">buf_file</a></li>
</ul>
<div style="text-align:right">
  Last updated: 2016-12-07 08:32:02 UTC
  </div>
<hr size="1" style="margin-top: 10px; margin-bottom: 10px; color: rgba(0, 0, 0, .15);"/>
<div style="text-align:right">
Versions 
  
    
    | <a href="/v1.0/articles/buffer-plugin-overview">v1.0 (td-agent3)</a>
    
  

  

  
    
    | <b><i>v0.12</i> (td-agent2)<b>
</b></b>
</div>
<hr size="1" style="margin-top: 10px; margin-bottom: 10px; color: rgba(0, 0, 0, .15);"/>
<p>
    If this article is incorrect or outdated, or omits critical information, please <a href="https://github.com/fluent/fluentd-docs/issues?state=open">let us know</a>. <a href="http://www.fluentd.org/">Fluentd</a> is a  open source project under <a href="https://cncf.io/">Cloud Native Computing Foundation (CNCF)</a>. All components are available under the Apache 2 License.
  </p>
</article>