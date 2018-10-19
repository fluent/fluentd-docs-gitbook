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
<h1>Installing Fluentd with Docker</h1>
</hgroup>
<p>This article explains how to use <a href="https://hub.docker.com/r/fluent/fluentd/">Fluentd’s official Docker image</a>, maintained by <a href="http://www.treasuredata.com/">Treasure Data, Inc</a>.</p>
<ul>
<li><a href="https://hub.docker.com/r/fluent/fluentd/">Fluentd’s official Docker image</a></li>
<li><a href="https://github.com/fluent/fluentd-docker-image">Fluentd’s official Docker image (Source)</a></li>
</ul>
<a name="step-0:-install-docker"></a>
<section id="table-of-contents"><h3>Table of Contents</h3>
<ul id="toc">
<li class="toc-item"><a href="#step-0:-install-docker">Step 0: Install Docker</a></li>
<li class="toc-item"><a href="#step-1:-pull-fluentd%E2%80%99s-docker-image">Step 1: Pull Fluentd’s Docker image</a></li>
<li class="toc-item"><a href="#step-2:-launch-fluentd-container">Step 2: Launch Fluentd Container</a></li>
<li class="toc-item"><a href="#step3:-post-sample-logs-via-http">Step3: Post Sample Logs via HTTP</a></li>
<li class="toc-item"><a href="#next-steps">Next Steps</a></li>
</ul>
</section>
<h2>Step 0: Install Docker</h2>
<p>Please download and install <a href="https://www.docker.com/">Docker</a> from here.</p>
<ul>
<li><a href="https://docs.docker.com/engine/installation/">Docker Installation</a></li>
</ul>
<a name="step-1:-pull-fluentd%E2%80%99s-docker-image"></a><h2>Step 1: Pull Fluentd’s Docker image</h2>
<p>Then, please download Fluentd v0.12’s image by <code>docker pull</code> command.</p>
<pre class="CodeRay"><span class="comment">$</span><span class="function"> docker pull fluent/fluentd:v0.12-debian
</span></pre>
<table class="note">
<td class="icon"></td>
<td class="content">Debian and Alpine Linux version is available for Fluentd image. Debian version is recommended officially since it has jemalloc support, however Alpine image is smaller.</td>
</table>
<a name="step-2:-launch-fluentd-container"></a><h2>Step 2: Launch Fluentd Container</h2>
<p>To make the test simple, create the example config below at <code>/tmp/fluentd.conf</code>. This example accepts records from http, and output to stdout.</p>
<pre class="CodeRay"><span class="string"># /tmp/fluentd.conf
</span><span class="string">&lt;source&gt;
</span><span class="string">  @type http
</span><span class="string">  port 9880
</span><span class="string">  bind 0.0.0.0
</span><span class="string">&lt;/source&gt;
</span><span class="string">&lt;match **&gt;
</span><span class="string">  @type stdout
</span><span class="string">&lt;/match&gt;
</span></pre>
<p>Finally, you can run Fluentd with <code>docker run</code> command.</p>
<pre class="CodeRay"><span class="comment">$</span><span class="function"> docker run -d \
</span><span class="function">  -p 9880:9880 -v /tmp:/fluentd/etc -e FLUENTD_CONF=fluentd.conf \
</span><span class="function">  fluent/fluentd
</span><span class="string">2017-01-30 11:52:23 +0000 [info]: reading config file path="/fluentd/etc/fluentd.conf"
</span><span class="string">2017-01-30 11:52:23 +0000 [info]: starting fluentd-0.12.31
</span><span class="string">2017-01-30 11:52:23 +0000 [info]: gem 'fluentd' version '0.12.31'
</span><span class="string">2017-01-30 11:52:23 +0000 [info]: adding match pattern="**" type="stdout"
</span><span class="string">2017-01-30 11:52:23 +0000 [info]: adding source type="http"
</span><span class="string">2017-01-30 11:52:23 +0000 [info]: using configuration file: &lt;ROOT&gt;
</span><span class="string">  &lt;source&gt;
</span><span class="string">    @type http
</span><span class="string">    port 9880
</span><span class="string">    bind 0.0.0.0
</span><span class="string">  &lt;/source&gt;
</span><span class="string">  &lt;match **&gt;
</span><span class="string">    @type stdout
</span><span class="string">  &lt;/match&gt;
</span><span class="string">&lt;/ROOT&gt;
</span></pre>
<a name="step3:-post-sample-logs-via-http"></a><h2>Step3: Post Sample Logs via HTTP</h2>
<p>Let’s post sample logs via HTTP and confirm it’s working. <code>curl</code> command is always your friend.</p>
<pre class="CodeRay"><span class="comment">$</span><span class="function"> curl -X POST -d 'json={"json":"message"}' http://localhost:9880/sample.test
</span></pre>
<p>Use <code>docker ps</code> command to retrieve container ID, and use <code>docker logs</code> command to check the specific container’s log.</p>
<pre class="CodeRay">$ docker ps
CONTAINER ID        IMAGE               COMMAND                  CREATED             STATUS              PORTS                                         NAMES
b495e527850c        fluent/fluentd      "/bin/sh -c 'exec ..."   2 hours ago         Up 2 hours          5140/tcp, 24224/tcp, 0.0.0.0:9880-&gt;9880/tcp   awesome_mcnulty
$ docker logs b495e527850c | tail -n 1
2017-01-30 14:04:37 +0000 sample.test: {"json":"message"}
</pre>
<a name="next-steps"></a><h2>Next Steps</h2>
<p>Now you know how to use Fluentd via Docker. Here’re a couple of Docker related documentations for Fluentd.</p>
<ul>
<li><a href="https://hub.docker.com/r/fluent/fluentd/">Fluentd’s official Docker image</a></li>
<li><a href="https://github.com/fluent/fluentd-docker-image">Fluentd’s official Docker image (Source)</a></li>
<li><a href="docker-logging">Docker Logging Driver and Fluentd</a></li>
<li><a href="docker-logging-efk-compose">Docker Logging via EFK (Elasticsearch + Fluentd + Kibana) Stack with Docker Compose</a></li>
</ul>
<p>Also, please see the following tutorials to learn how to collect your data from various data sources.</p>
<ul>
<li>Basic Configuration

<ul>
<li><a href="config-file">Config File</a></li>
</ul>
</li>
<li>Application Logs

<ul>
<li>
<a href="ruby">Ruby</a>, <a href="java">Java</a>, <a href="python">Python</a>, <a href="php">PHP</a>, <a href="perl">Perl</a>, <a href="nodejs">Node.js</a>, <a href="scala">Scala</a>
</li>
</ul>
</li>
<li>Examples

<ul>
<li><a href="apache-to-s3">Store Apache Log into Amazon S3</a></li>
<li><a href="apache-to-mongodb">Store Apache Log into MongoDB</a></li>
<li><a href="http-to-hdfs">Data Collection into HDFS</a></li>
</ul>
</li>
</ul>
<div style="text-align:right">
  Last updated: 2017-02-10 20:45:52 UTC
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