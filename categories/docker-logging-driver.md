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
<h1>Docker Logging Driver and Fluentd</h1>
</hgroup>
<p>The following article describes how to implement an unified logging system for your <a href="http://www.docker.com">Docker</a> containers. Any production application requires to register certain events or problems during runtime.</p>
<p>The old fashion way is to write these messages to a log file, but that inherits certain problems specifically when we try to perform some analysis over the registers, or in the other side, if the application have multiple instances running, the escenario becomes even more complex.</p>
<p>On Docker v1.6, the concept of <b><a href="https://docs.docker.com/engine/admin/logging/overview/">logging drivers</a></b> was introduced, basically the Docker engine is aware about output interfaces that manage the application messages.</p>
<p><img alt="" src="http://www.fluentd.org/assets/img/recipes/fluentd_docker.png"/></p>
<p>For Docker v1.8, we have implemented a native <b><a href="https://docs.docker.com/engine/admin/logging/fluentd/">Fluentd Docker logging driver</a></b>, now you are able to have an unified and structured logging system with the simplicity and high performance <a href="http://fluentd.org">Fluentd</a>.</p>
<table class="note">
<td class="icon"></td>
<td class="content">Currently, fluentd logging driver doesn't support sub-second precision.</td>
</table>
<a name="getting-started"></a>
<section id="table-of-contents"><h3>Table of Contents</h3>
<ul id="toc">
<li class="toc-item"><a href="#getting-started">Getting Started</a></li>
<ul class="sub-toc">
<li class="sub-toc-item"><a href="#step-1:-create-the-fluentd-configuration-file">Step 1: Create the Fluentd configuration file</a></li>
<li class="sub-toc-item"><a href="#step-2:-start-fluentd">Step 2: Start Fluentd</a></li>
<li class="sub-toc-item"><a href="#step-3:-start-docker-container-with-fluentd-driver">Step 3: Start Docker container with Fluentd driver</a></li>
<li class="sub-toc-item"><a href="#step-4:-confirm">Step 4: Confirm</a></li>
<li class="sub-toc-item"><a href="#additional-step-1:-parse-log-message">Additional Step 1: Parse log message</a></li>
<li class="sub-toc-item"><a href="#additional-step-2:-concatenate-multiple-lines-log-messages">Additional Step 2: Concatenate multiple lines log messages</a></li>
</ul>
<li class="toc-item"><a href="#driver-options">Driver options</a></li>
<li class="toc-item"><a href="#development-environments">Development Environments</a></li>
<li class="toc-item"><a href="#production-environments">Production Environments</a></li>
</ul>
</section>
<h2>Getting Started</h2>
<p>Using the Docker logging mechanism with <a href="http://www.fluentd.org">Fluentd</a> is a straighforward step, to get started make sure you have the following prerequisites:</p>
<ul>
<li>A basic understanding of <a href="http://www.fluentd.org">Fluentd</a>
</li>
<li>A basic undersatnding of Docker</li>
<li>A basic understanding of <a href="https://docs.docker.com/engine/admin/logging/overview/">Docker logging drivers</a>
</li>
<li>Docker v1.8+</li>
</ul>
<table class="note">
<td class="icon"></td>
<td class="content">This article launches Fluentd as standard process, not a container. Prease refer <a href="docker-logging-efk-compose">Docker Logging via EFK (Elasticsearch + Fluentd + Kibana) Stack with Docker Compose</a> for fully containerized environment tutorial.</td>
</table>
<a name="step-1:-create-the-fluentd-configuration-file"></a><h3>Step 1: Create the Fluentd configuration file</h3>
<p>The first step is to prepare Fluentd to listen for the messsages that will receive from the Docker containers, for a demonstration purposes we will instruct Fluentd to write the messages to the standard output; In a later step you will find how to accomplish the same aggregating the logs into a MongoDB instance.</p>
<p>Create a simple file called in_docker.conf which contains the following entries:</p>
<pre class="CodeRay"><span class="tag">&lt;source&gt;</span>
  type forward
  port 24224
  bind 0.0.0.0
<span class="tag">&lt;/source&gt;</span>

<span class="tag">&lt;match</span> <span class="error">*</span><span class="attribute-name">.</span><span class="error">*</span><span class="tag">&gt;</span>
  type stdout
<span class="tag">&lt;/match&gt;</span>
</pre>
<a name="step-2:-start-fluentd"></a><h3>Step 2: Start Fluentd</h3>
<p>With this simple command start an instance of Fluentd:</p>
<pre class="CodeRay"><span class="comment">$</span><span class="function"> fluentd -c in_docker.conf
</span></pre>
<p>If the service started you should see an output like this:</p>
<pre class="CodeRay"><span class="comment">$</span><span class="function"> fluentd -c in_docker.conf
</span><span class="string">2015-09-01 15:07:12 -0600 [info]: reading config file path="in_docker.conf"
</span><span class="string">2015-09-01 15:07:12 -0600 [info]: starting fluentd-0.12.15
</span><span class="string">2015-09-01 15:07:12 -0600 [info]: gem 'fluent-plugin-mongo' version '0.7.10'
</span><span class="string">2015-09-01 15:07:12 -0600 [info]: gem 'fluentd' version '0.12.15'
</span><span class="string">2015-09-01 15:07:12 -0600 [info]: adding match pattern="*.*" type="stdout"
</span><span class="string">2015-09-01 15:07:12 -0600 [info]: adding source type="forward"
</span><span class="string">2015-09-01 15:07:12 -0600 [info]: using configuration file: &lt;ROOT&gt;
</span><span class="string">  &lt;source&gt;
</span><span class="string">    @type forward
</span><span class="string">    port 24224
</span><span class="string">    bind 0.0.0.0
</span><span class="string">  &lt;/source&gt;
</span><span class="string">  &lt;match docker.*&gt;
</span><span class="string">    @type stdout
</span><span class="string">  &lt;/match&gt;
</span><span class="string">&lt;/ROOT&gt;
</span><span class="string">2015-09-01 15:07:12 -0600 [info]: listening fluent socket on 0.0.0.0:24224
</span></pre>
<a name="step-3:-start-docker-container-with-fluentd-driver"></a><h3>Step 3: Start Docker container with Fluentd driver</h3>
<p>By default, the Fluentd logging driver will try to find a local Fluentd instance  (step #2) listening for connections on the TCP port 24224, note that the container will not start if it cannot connect to the Fluentd instance.</p>
<p><img src="https://www.fluentd.org/assets/img/recipes/fluentd_docker_integrated.png" width='70%"'/></p>
<p>The following command will run a base Ubuntu container and print some messages to the standard output, note that we have launched the container specifying the Fluentd logging driver:</p>
<pre class="CodeRay"><span class="comment">$</span><span class="function"> docker run --log-driver=fluentd ubuntu echo "Hello Fluentd!"
</span><span class="string">Hello Fluentd!
</span></pre>
<a name="step-4:-confirm"></a><h3>Step 4: Confirm</h3>
<p>Now on the Fluentd output, you will see the incoming message from the container, e.g:</p>
<pre class="CodeRay"><span class="string">2015-09-01 15:10:40 -0600 docker.3fd8678d487e: {"source":"stdout","log":"Hello Fluentd!","container_id":"3fd8678d487e540c7a303e1613101e746c5012f3317434eda93f24351c1928f7","container_name":"/angry_kalam"}
</span></pre>
<p>At this point you will notice something interesting, the incoming messages have a timestamp, are tagged with the container_id and contains general information from the source container along the message, everything in JSON format.</p>
<a name="additional-step-1:-parse-log-message"></a><h3>Additional Step 1: Parse log message</h3>
<p>Application log is stored into <code>"log"</code> field in the record. You can parse this log by using <a href="http://docs.fluentd.org/articles/filter_parser">filter_parser</a> filter before send to destinations.</p>
<pre class="CodeRay"><span class="tag">&lt;filter</span> <span class="attribute-name">docker.</span><span class="error">*</span><span class="error">*</span><span class="tag">&gt;</span>
  @type parser
  format json # apache2, nginx, etc...
  key_name log
  reserve_data true
<span class="tag">&lt;/filter&gt;</span>
</pre>
<p>Original event:</p>
<pre class="CodeRay">2015-09-01 15:10:40 -0600 docker.3fd8678d487e: {"source":"stdout","log":"{\"key\":\"value\"}","container_id":"3fd8678d487e540c7a303e1613101e746c5012f3317434eda93f24351c1928f7","container_name":"/angry_kalam"}
</pre>
<p>Filtered event:</p>
<pre class="CodeRay">2015-09-01 15:10:40 -0600 docker.3fd8678d487e: {"source":"stdout","log":"{\"key\":\"value\"}","container_id":"3fd8678d487e540c7a303e1613101e746c5012f3317434eda93f24351c1928f7","container_name":"/angry_kalam","key":"value"}
</pre>
<a name="additional-step-2:-concatenate-multiple-lines-log-messages"></a><h3>Additional Step 2: Concatenate multiple lines log messages</h3>
<p>Application log is stored into <code>"log"</code> field in the records. You can concatenate these logs by using <a href="https://github.com/fluent-plugins-nursery/fluent-plugin-concat">fluent-plugin-concat</a> filter before send to destinations.</p>
<pre class="CodeRay">&lt;filter docker.**&gt;
  @type concat
  key log
  stream_identity_key container_id
  multiline_start_regexp /^-e:2:in `\/'/
  multiline_end_regexp /^-e:4:in/
&lt;/filter&gt;
</pre>
<p>Original events:</p>
<pre class="CodeRay">2016-04-13 14:45:55 +0900 docker.28cf38e21204: {"container_id":"28cf38e212042225f5f80a56fac08f34c8f0b235e738900c4e0abcf39253a702","container_name":"/romantic_dubinsky","source":"stdout","log":"-e:2:in `/'"}
2016-04-13 14:45:55 +0900 docker.28cf38e21204: {"source":"stdout","log":"-e:2:in `do_division_by_zero'","container_id":"28cf38e212042225f5f80a56fac08f34c8f0b235e738900c4e0abcf39253a702","container_name":"/romantic_dubinsky"}
2016-04-13 14:45:55 +0900 docker.28cf38e21204: {"source":"stdout","log":"-e:4:in `&lt;main&gt;'","container_id":"28cf38e212042225f5f80a56fac08f34c8f0b235e738900c4e0abcf39253a702","container_name":"/romantic_dubinsky"}
</pre>
<p>Filtered events:</p>
<pre class="CodeRay">2016-04-13 14:45:55 +0900 docker.28cf38e21204: {"container_id":"28cf38e212042225f5f80a56fac08f34c8f0b235e738900c4e0abcf39253a702","container_name":"/romantic_dubinsky","source":"stdout","log":"-e:2:in `/'\n-e:2:in `do_division_by_zero'\n-e:4:in `&lt;main&gt;'"}
</pre>
<p>If the logs are typical stacktraces, consider <a href="https://github.com/GoogleCloudPlatform/fluent-plugin-detect-exceptions">detect-exceptions plugin</a> instead.</p>
<a name="driver-options"></a><h2>Driver options</h2>
<p>The <a href="https://docs.docker.com/engine/admin/logging/fluentd/">Fluentd logging driver</a> support more options through the <em>–log-opt</em> Docker command line argument:</p>
<ul>
<li>fluentd-address</li>
<li>tag</li>
</ul>
<h4>fluentd-address</h4>
<p>Specify an optional address for Fluentd, it allows to set the host and TCP port, e.g:</p>
<pre class="CodeRay"><span class="comment">$</span><span class="function"> docker run --log-driver=fluentd --log-opt fluentd-address=192.168.2.4:24225 ubuntu echo "..."
</span></pre>
<h4>tag</h4>
<p><a href="https://docs.docker.com/engine/admin/logging/log_tags/">Tags</a> are a major requirement on Fluentd, they allows to identify the incoming data and take routing decisions. By default the Fluentd logging driver uses the container_id as a tag (64 character ID), you can change it value with the <em>tag</em> option as follows:</p>
<pre class="CodeRay"><span class="comment">$</span><span class="function"> docker run --log-driver=fluentd --log-opt tag=docker.my_new_tag ubuntu echo "..."
</span></pre>
<p>Additionally this option allows to specify some internal variables: {{"{{.ID"}}}}, {{"{{.FullID"}}}} or {{"{{.Name"}}}}. e.g:</p>
<pre class="CodeRay"><span class="comment">$</span><span class="function"> docker run --log-driver=fluentd --log-opt tag=docker.{{"{{.ID"}}}} ubuntu echo "..."
</span></pre>
<a name="development-environments"></a><h2>Development Environments</h2>
<p>In a more real-world use case, you would want to use something other than the Fluentd standard output to store Docker containers messages, such as Elasticsearch, MongoDB, HDFS, S3, Google Cloud Storage and so on.</p>
<p>This document describes how to set up multi-container logging environment via EFK (Elasticsearch, Fluentd, Kibana)  with Docker Compose.</p>
<ul>
<li><a href="docker-logging-efk-compose">Docker Logging via EFK (Elasticsearch + Fluentd + Kibana) Stack with Docker Compose</a></li>
</ul>
<a name="production-environments"></a><h2>Production Environments</h2>
<p>In production environment, you must use one of the container orchestration tools. Currently, Kubernetes has better integration with Fluentd, and we’re working on making better integrations with other tools as well.</p>
<ul>
<li><a href="https://kubernetes.io/docs/user-guide/logging/overview/">Kubernetes’s Logging Overview</a></li>
</ul>
<div style="text-align:right">
  Last updated: 2017-01-30 13:27:02 UTC
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