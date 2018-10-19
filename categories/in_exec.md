<article>
<div style="text-align:right">
<div style="text-align:right">
Versions 
  
    
    | <a href="/v1.0/articles/in_exec">v1.0 (td-agent3)</a>
    
  

  

  
    
    | <b><i>v0.12</i> (td-agent2)<b>
</b></b>
</div>
</div>
<hr size="1" style="margin-top: 10px; margin-bottom: 10px; color: rgba(0, 0, 0, .15);"/>
<hgroup>
<h1>exec Input Plugin</h1>
</hgroup>
<p>The <code>in_exec</code> Input plugin executes external programs to receive or pull event logs. It will then read TSV (tab separated values), JSON or MessagePack from the stdout of the program.</p>
<p>You can run a program periodically or permanently. To run periodically, please use the run_interval parameter.</p>
<a name="example-configuration"></a>
<section id="table-of-contents"><h3>Table of Contents</h3>
<ul id="toc">
<li class="toc-item"><a href="#example-configuration">Example Configuration</a></li>
<li class="toc-item"><a href="#parameters">Parameters</a></li>
<ul class="sub-toc">
<li class="sub-toc-item"><a href="#@type-(required)">@type (required)</a></li>
<li class="sub-toc-item"><a href="#command-(required)">command (required)</a></li>
<li class="sub-toc-item"><a href="#format">format</a></li>
<li class="sub-toc-item"><a href="#tag-(required-if-tag_key-is-not-specified)">tag (required if tag_key is not specified)</a></li>
<li class="sub-toc-item"><a href="#tag_key">tag_key</a></li>
<li class="sub-toc-item"><a href="#time_key">time_key</a></li>
<li class="sub-toc-item"><a href="#time_format">time_format</a></li>
<li class="sub-toc-item"><a href="#run_interval">run_interval</a></li>
</ul>
<li class="toc-item"><a href="#real-world-use-case:-using-in_exec-to-scrape-hacker-news-top-page">Real World Use Case: using in_exec to scrape Hacker News Top Page</a></li>
</ul>
</section>
<h2>Example Configuration</h2>
<p><code>in_exec</code> is included in Fluentd’s core. No additional installation process is required.</p>
<pre class="CodeRay">&lt;source&gt;
  @type exec
  command cmd arg arg
  keys k1,k2,k3
  tag_key k1
  time_key k2
  time_format %Y-%m-%d %H:%M:%S
  run_interval 10s
&lt;/source&gt;
</pre>
<table class="note">
<td class="icon"></td>
<td class="content">Please see the <a href="config-file">Config File</a> article for the basic structure and syntax of the configuration file.</td>
</table>
<a name="parameters"></a><h2>Parameters</h2>
<a name="@type-(required)"></a><h3>@type (required)</h3>
<p>The value must be <code>exec</code>.</p>
<a name="command-(required)"></a><h3>command (required)</h3>
<p>The command (program) to execute.</p>
<a name="format"></a><h3>format</h3>
<p>The format used to map the program output to the incoming event.</p>
<p>The following formats are supported:</p>
<ul>
<li>tsv (default)</li>
<li>json</li>
<li>msgpack</li>
<li>
<a href="parser-plugin-overview">parser plugin formats</a>, e.g. ltsv, none.</li>
</ul>
<p>When using the tsv format, please also specify the comma-separated <code>keys</code> parameter.</p>
<pre class="CodeRay">keys k1,k2,k3
</pre>
<table class="note">
<td class="icon"></td>
<td class="content">When using the json format, this plugin uses the Yajl library to parse the program output. Yajl buffers data internally so the output isn't always instantaneous.</td>
</table>
<a name="tag-(required-if-tag_key-is-not-specified)"></a><h3>tag (required if tag_key is not specified)</h3>
<p>tag of the output events.</p>
<a name="tag_key"></a><h3>tag_key</h3>
<p>The key to use as the event tag instead of the value in the event record. If this parameter is not specified, the <code>tag</code> parameter will be used instead.</p>
<a name="time_key"></a><h3>time_key</h3>
<p>The key to use as the event time instead of the value in the event record. If this parameter is not specified, the current time will be used instead.</p>
<a name="time_format"></a><h3>time_format</h3>
<p>The format of the event time used for the time_key parameter. The default is UNIX time (integer).</p>
<a name="run_interval"></a><h3>run_interval</h3>
<p>The interval time between periodic program runs. If no specify value, command script runs only once.</p>
<h4>log_level option</h4>
<p>The <code>log_level</code> option allows the user to set different levels of logging for each plugin. The supported log levels are: <code>fatal</code>, <code>error</code>, <code>warn</code>, <code>info</code>, <code>debug</code>, and <code>trace</code>.</p>
<p>Please see the <a href="logging">logging article</a> for further details.</p>
<a name="real-world-use-case:-using-in_exec-to-scrape-hacker-news-top-page"></a><h2>Real World Use Case: using in_exec to scrape Hacker News Top Page</h2>
<p>If you already have a script that runs periodically (say, via <code>cron</code>) that you wish to store the output to multiple backend systems (HDFS, AWS, Elasticsearch, etc.), in_exec is a great choice.</p>
<p>The only requirement for the script is that it outputs TSV, JSON or MessagePack.</p>
<p>For example, the <a href="https://gist.github.com/kiyoto/1bd903ad1bdd6ac51fcc">following script</a> scrapes the front page of <a href="http://news.ycombinator.com">Hacker News</a> and scrapes information about each post:</p>
<iframe src="https://gist.github.com/kiyoto/1bd903ad1bdd6ac51fcc.pibb?scroll=true" style="width:640px;height:400px"></iframe>
<p>Suppose that script is called <code>hn.rb</code>. Then, you can run it every 5 minutes with the following configuration</p>
<pre class="CodeRay">&lt;source&gt;
  @type exec
  format json
  tag hackernews
  command ruby /path/to/hn.rb
  run_interval 5m # don't hit HN too frequently!
&lt;/source&gt;
&lt;match hackernews&gt;
  @type stdout
&lt;/match&gt;
</pre>
<p>And if you run Fluentd with it, you will see the following output (if you are impatient, ctrl-C to flush the stdout buffer)</p>
<pre class="CodeRay">2014-05-26 21:51:35 +0000 hackernews: {"time":1401141095,"rank":1,"title":"Rap Genius Co-Founder Moghadam Fired","points":128,"user_name":"obilgic","duration":"2 hours ago  ","num_comments":108}
2014-05-26 21:51:35 +0000 hackernews: {"time":1401141095,"rank":2,"title":"Whitewood Under Siege: Wooden Shipping Pallets","points":128,"user_name":"drjohnson","duration":"3 hours ago  ","num_comments":20}
2014-05-26 21:51:35 +0000 hackernews: {"time":1401141095,"rank":3,"title":"Organic Cat Litter Chief Suspect In Nuclear Waste Accident","points":55,"user_name":"timr","duration":"2 hours ago  ","num_comments":12}
2014-05-26 21:51:35 +0000 hackernews: {"time":1401141095,"rank":4,"title":"Do We Really Know What Makes Us Healthy? (2007)","points":27,"user_name":"gwern","duration":"1 hour ago  ","num_comments":9}
</pre>
<p>Of course, you can use Fluentd’s many output plugins to store the data into various backend systems like <a href="free-alternative-to-splunk-by-fluentd">Elasticsearch</a>, <a href="http-to-hdfs">HDFS</a>, <a href="apache-to-mongodb">MongoDB</a>, <a href="apache-to-s3">AWS</a>, etc.</p>
<div style="text-align:right">
  Last updated: 2016-07-26 23:53:19 UTC
  </div>
<hr size="1" style="margin-top: 10px; margin-bottom: 10px; color: rgba(0, 0, 0, .15);"/>
<div style="text-align:right">
Versions 
  
    
    | <a href="/v1.0/articles/in_exec">v1.0 (td-agent3)</a>
    
  

  

  
    
    | <b><i>v0.12</i> (td-agent2)<b>
</b></b>
</div>
<hr size="1" style="margin-top: 10px; margin-bottom: 10px; color: rgba(0, 0, 0, .15);"/>
<p>
    If this article is incorrect or outdated, or omits critical information, please <a href="https://github.com/fluent/fluentd-docs/issues?state=open">let us know</a>. <a href="http://www.fluentd.org/">Fluentd</a> is a  open source project under <a href="https://cncf.io/">Cloud Native Computing Foundation (CNCF)</a>. All components are available under the Apache 2 License.
  </p>
</article>