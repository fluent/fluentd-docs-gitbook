<hgroup>
<h1>exec Output Plugin</h1>
</hgroup>
<p>The <code>out_exec</code> TimeSliced Output plugin passes events to an external program. The program receives the path to a file containing the incoming events as its last argument. The file format is tab-separated values (TSV) by default.</p>
<a name="example-configuration"></a>
<section id="table-of-contents"><h3>Table of Contents</h3>
<ul id="toc">
<li class="toc-item"><a href="#example-configuration">Example Configuration</a></li>
<li class="toc-item"><a href="#example:-running-fizzbuzz-against-data-stream">Example: Running FizzBuzz against data stream</a></li>
<li class="toc-item"><a href="#parameters">Parameters</a></li>
<ul class="sub-toc">
<li class="sub-toc-item"><a href="#@type-(required)">@type (required)</a></li>
<li class="sub-toc-item"><a href="#command-(required)">command (required)</a></li>
<li class="sub-toc-item"><a href="#format">format</a></li>
<li class="sub-toc-item"><a href="#tag_key">tag_key</a></li>
<li class="sub-toc-item"><a href="#time_key">time_key</a></li>
<li class="sub-toc-item"><a href="#time_format">time_format</a></li>
</ul>
<li class="toc-item"><a href="#time-sliced-output-parameters">Time Sliced Output Parameters</a></li>
<ul class="sub-toc">
<li class="sub-toc-item"><a href="#time_slice_format">time_slice_format</a></li>
<li class="sub-toc-item"><a href="#time_slice_wait">time_slice_wait</a></li>
<li class="sub-toc-item"><a href="#buffer_type">buffer_type</a></li>
<li class="sub-toc-item"><a href="#buffer_queue_limit,-buffer_chunk_limit">buffer_queue_limit, buffer_chunk_limit</a></li>
<li class="sub-toc-item"><a href="#flush_interval">flush_interval</a></li>
<li class="sub-toc-item"><a href="#flush_at_shutdown">flush_at_shutdown</a></li>
<li class="sub-toc-item"><a href="#retry_wait,-max_retry_wait">retry_wait, max_retry_wait</a></li>
<li class="sub-toc-item"><a href="#retry_limit,-disable_retry_limit">retry_limit, disable_retry_limit</a></li>
<li class="sub-toc-item"><a href="#num_threads">num_threads</a></li>
<li class="sub-toc-item"><a href="#slow_flush_log_threshold">slow_flush_log_threshold</a></li>
</ul>
</ul>
</section>
<h2>Example Configuration</h2>
<p><code>out_exec</code> is included in Fluentd’s core. No additional installation process is required.</p>
<pre class="CodeRay">&lt;match pattern&gt;
  @type exec
  command cmd arg arg
  format tsv
  keys k1,k2,k3
  tag_key k1
  time_key k2
  time_format %Y-%m-%d %H:%M:%S
&lt;/match&gt;
</pre>
<table class="note">
<td class="icon"></td>
<td class="content">Please see the <a href="config-file">Config File</a> article for the basic structure and syntax of the configuration file.</td>
</table>
<a name="example:-running-fizzbuzz-against-data-stream"></a><h2>Example: Running FizzBuzz against data stream</h2>
<p>This example illustrates how to run FizzBuzz with out_exec.</p>
<p>We assume that the input file is specified by the last argument in the command line (“ARGV[-1]”). The following script <code>fizzbuzz.py</code> runs <a href="http://en.wikipedia.org/wiki/Fizz_buzz">FizzBuzz</a> against the new-line delimited sequence of natural numbers (1, 2, 3…) and writes the output to “foobar.out”.</p>
<pre class="CodeRay">#!/usr/bin/env python
import sys
input = file(sys.argv[-1])
output = file("foobar.out", "a")
for line in input:
    fizzbuzz = int(line.split("\t")[0])
    s = ''
    if fizzbuzz%3 == 0:
        s += 'fizz'
    if fizzbuzz%5 == 0:
        s += 'buzz'
    if len(s) &gt; 0:
        output.write(s+"\n")
    else:
        output.write(str(fizzbuzz)+"\n")
output.close
</pre>
<p>Note that this program is written in Python. For out_exec (as well as out_exec_filter and in_exec), <strong>the program can be written in any language, not just Ruby.</strong></p>
<p>Then, configure Fluentd as follows</p>
<pre class="CodeRay">&lt;source&gt;
  @type forward
&lt;/source&gt;
&lt;match fizzbuzz&gt;
  @type exec
  command python /path/to/fizzbuzz.py
  buffer_path    /path/to/buffer_path
  format tsv
  keys fizzbuzz
  flush_interval 5s # for debugging/checking
&lt;/match&gt;
</pre>
<p>The “format tsv” and “keys fizzbuzz” tells Fluentd to extract the “fizzbuzz” field and output it as TSV. This simple example has a single key, but you can of course extract multiple fields and use “format json” to output newline-delimited JSONs.</p>
<p>The intermediary TSV is at <code>buffer_path</code>, and the command <code>python /path/to/fizzbuzz.py /path/to/buffer_path</code> is run. This is why in <code>fizzbuzz.py</code>, it’s reading the file at <code>sys.argv[-1]</code>.</p>
<p>If you start Fluentd and run</p>
<pre class="CodeRay">$ for i in `seq 15`; do echo "{\"fizzbuzz\":$i}" | fluent-cat fizzbuzz; done
</pre>
<p>Then, after 5 seconds, you get a file named <code>foobar.out</code>.</p>
<pre class="CodeRay">$ cat foobar.out
1
2
fizz
4
buzz
fizz
7
8
fizz
buzz
11
fizz
13
14
fizzbuzz
</pre>
<a name="parameters"></a><h2>Parameters</h2>
<a name="@type-(required)"></a><h3>@type (required)</h3>
<p>The value must be <code>exec</code>.</p>
<a name="command-(required)"></a><h3>command (required)</h3>
<p>The command (program) to execute. The exec plugin passes the path of a TSV file as the last argument.</p>
<a name="format"></a><h3>format</h3>
<p>The format used to map the incoming events to the program input.</p>
<p>The following formats are supported:</p>
<ul>
<li>tsv (default)</li>
</ul>
<p>When using the tsv format, please also specify the comma-separated <code>keys</code> parameter.</p>
<pre class="CodeRay">keys k1,k2,k3
</pre>
<ul>
<li>json</li>
<li>msgpack</li>
</ul>
<a name="tag_key"></a><h3>tag_key</h3>
<p>The name of the key to use as the event tag. This replaces the value in the event record.</p>
<a name="time_key"></a><h3>time_key</h3>
<p>The name of the key to use as the event time. This replaces the the value in the event record.</p>
<a name="time_format"></a><h3>time_format</h3>
<p>The format for event time used when the <code>time_key</code> parameter is specified. The default is UNIX time (integer).</p>
<a name="time-sliced-output-parameters"></a><h2>Time Sliced Output Parameters</h2>
<p>For advanced usage, you can tune Fluentd’s internal buffering mechanism with these parameters.</p>
<a name="time_slice_format"></a><h3>time_slice_format</h3>
<p>The time format used as part of the file name. The following characters are replaced with actual values when the file is created:</p>
<ul>
<li>%Y: year including the century (at least 4 digits)</li>
<li>%m: month of the year (01..12)</li>
<li>%d: Day of the month (01..31)</li>
<li>%H: Hour of the day, 24-hour clock (00..23)</li>
<li>%M: Minute of the hour (00..59)</li>
<li>%S: Second of the minute (00..60)</li>
</ul>
<p>The default format is <code>%Y%m%d%H</code>, which creates one file per hour.</p>
<a name="time_slice_wait"></a><h3>time_slice_wait</h3>
<p>The amount of time Fluentd will wait for old logs to arrive. This is used to account for delays in logs arriving to your Fluentd node. The default wait time is 10 minutes (‘10m’), where Fluentd will wait until 10 minutes past the hour for any logs that occurred within the past hour.</p>
<p>For example, when splitting files on an hourly basis, a log recorded at 1:59 but arriving at the Fluentd node between 2:00 and 2:10 will be uploaded together with all the other logs from 1:00 to 1:59 in one transaction, avoiding extra overhead. Larger values can be set as needed.</p>
<a name="buffer_type"></a><h3>buffer_type</h3>
<p>The buffer type is <code>file</code> by default (<a href="buf_file">buf_file</a>). The <code>memory</code> (<a href="buf_memory">buf_memory</a>) buffer type can be chosen as well. If you use <code>file</code> buffer type, <code>buffer_path</code> parameter is required.</p>
<a name="buffer_queue_limit,-buffer_chunk_limit"></a><h3>buffer_queue_limit, buffer_chunk_limit</h3>
<p>The length of the chunk queue and the size of each chunk, respectively. Please see the <a href="buffer-plugin-overview">Buffer Plugin Overview</a> article for the basic buffer structure. The default values are 64 and 8m, respectively. The suffixes “k” (KB), “m” (MB), and “g” (GB) can be used for buffer_chunk_limit.</p>
<a name="flush_interval"></a><h3>flush_interval</h3>
<p>The interval between data flushes. The default is 60s. The suffixes “s” (seconds), “m” (minutes), and “h” (hours) can be used.</p>
<a name="flush_at_shutdown"></a><h3>flush_at_shutdown</h3>
<p>If set to true, Fluentd waits for the buffer to flush at shutdown. By default, it is set to true for Memory Buffer and false for File Buffer.</p>
<a name="retry_wait,-max_retry_wait"></a><h3>retry_wait, max_retry_wait</h3>
<p>The initial and maximum intervals between write retries.  The default values are 1.0 and unset (no limit).  The interval doubles (with +/-12.5% randomness) every retry until <code>max_retry_wait</code> is reached.</p>
<p>Since td-agent will retry 17 times before giving up by default (see the <code>retry_limit</code> parameter for details), the sleep interval can be up to approximately 131072 seconds (roughly 36 hours) in the default configurations.</p>
<a name="retry_limit,-disable_retry_limit"></a><h3>retry_limit, disable_retry_limit</h3>
<p>The limit on the number of retries before buffered data is discarded, and an
option to disable that limit (if true, the value of <code>retry_limit</code> is ignored and
there is no limit).  The default values are 17 and false (not disabled). If the limit is reached, buffered data is discarded and the retry interval is reset to its initial value (<code>retry_wait</code>).</p>
<a name="num_threads"></a><h3>num_threads</h3>
<p>The number of threads to flush the buffer. This option can be used to parallelize writes into the output(s) designated by the output plugin. The default is 1.</p>
<a name="slow_flush_log_threshold"></a><h3>slow_flush_log_threshold</h3>
<p>Same as Buffered Output but default value is changed to <code>40.0</code> seconds.</p>
<h4>log_level option</h4>
<p>The <code>log_level</code> option allows the user to set different levels of logging for each plugin. The supported log levels are: <code>fatal</code>, <code>error</code>, <code>warn</code>, <code>info</code>, <code>debug</code>, and <code>trace</code>.</p>
<p>Please see the <a href="logging">logging article</a> for further details.</p>
<div style="text-align:right">
  Last updated: 2015-12-01 21:20:32 UTC
  </div>
<hr size="1" style="margin-top: 10px; margin-bottom: 10px; color: rgba(0, 0, 0, .15);"/>
<div style="text-align:right">
Versions 
  
    
    | <a href="/v1.0/articles/out_exec">v1.0 (td-agent3)</a>
    
  

  

  
    
    | <b><i>v0.12</i> (td-agent2)<b>
</b></b>
</div>
<hr size="1" style="margin-top: 10px; margin-bottom: 10px; color: rgba(0, 0, 0, .15);"/>
<p>
    If this article is incorrect or outdated, or omits critical information, please <a href="https://github.com/fluent/fluentd-docs/issues?state=open">let us know</a>. <a href="http://www.fluentd.org/">Fluentd</a> is a  open source project under <a href="https://cncf.io/">Cloud Native Computing Foundation (CNCF)</a>. All components are available under the Apache 2 License.
  </p>
