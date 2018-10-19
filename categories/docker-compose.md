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
<h1>Docker Logging via EFK (Elasticsearch + Fluentd + Kibana) Stack with Docker Compose</h1>
</hgroup>
<p>This article explains how to collect <a href="https://www.docker.com/">Docker</a> logs to EFK (Elasticsearch + Fluentd + Kibana) stack. The example uses <a href="https://docs.docker.com/compose/">Docker Compose</a> for setting up multiple containers.</p>
<center>
<img src="/images/kibana5-screenshot.png" width="90%"/><br/>
</center>
<p><br/>
<br/></p>
<p><a href="https://www.elastic.co/products/elasticsearch">Elasticsearch</a> is an open source search engine known for its ease of use. <a href="https://www.elastic.co/products/kibana">Kibana</a> is an open source Web UI that makes Elasticsearch user friendly for marketers, engineers and data scientists alike.</p>
<p>By combining these three tools EFK (Elasticsearch + Fluentd + Kibana) we get a scalable, flexible, easy to use log collection and analytics pipeline. In this article, we will set up 4 containers, each includes:</p>
<ul>
<li><a href="https://hub.docker.com/_/httpd/">Apache HTTP Server</a></li>
<li><a href="https://hub.docker.com/r/fluent/fluentd/">Fluentd</a></li>
<li><a href="https://hub.docker.com/_/elasticsearch/">Elasticsearch</a></li>
<li><a href="https://hub.docker.com/_/kibana/">Kibana</a></li>
</ul>
<p>All of <code>httpd</code>’s logs will be ingested into Elasticsearch + Kibana, via Fluentd.</p>
<a name="prerequisites:-docker"></a>
<section id="table-of-contents"><h3>Table of Contents</h3>
<ul id="toc">
<li class="toc-item"><a href="#prerequisites:-docker">Prerequisites: Docker</a></li>
<li class="toc-item"><a href="#step-0:-prepare-docker-compose.yml">Step 0: prepare docker-compose.yml</a></li>
<li class="toc-item"><a href="#step-1:-prepare-fluentd-image-with-your-config-+-plugin">Step 1: Prepare Fluentd image with your Config + Plugin</a></li>
<li class="toc-item"><a href="#step-2:-start-containers">Step 2: Start Containers</a></li>
<li class="toc-item"><a href="#step-3:-generate-httpd-access-logs">Step 3: Generate httpd Access Logs</a></li>
<li class="toc-item"><a href="#step-4:-confirm-logs-from-kibana">Step 4: Confirm Logs from Kibana</a></li>
<li class="toc-item"><a href="#conclusion">Conclusion</a></li>
<li class="toc-item"><a href="#learn-more">Learn More</a></li>
</ul>
</section>
<h2>Prerequisites: Docker</h2>
<p>Please download and install Docker / Docker Compose. Well, that’s it :)</p>
<ul>
<li><a href="https://docs.docker.com/engine/installation/">Docker Installation</a></li>
</ul>
<a name="step-0:-prepare-docker-compose.yml"></a><h2>Step 0: prepare docker-compose.yml</h2>
<p>First, please prepare <code>docker-compose.yml</code> for <a href="https://docs.docker.com/compose/overview/">Docker Compose</a>. Docker Compose is a tool for defining and running multi-container Docker applications.</p>
<p>With the YAML file below, you can create and start all the services (in this case, Apache, Fluentd, Elasticsearch, Kibana) by one command.</p>
<pre class="CodeRay"><span class="key">version</span>: <span class="string"><span class="content">'2'</span></span>
<span class="key">services</span>:
  <span class="key">web</span>:
    <span class="key">image</span>: <span class="string"><span class="content">httpd</span></span>
    <span class="key">ports</span>:
      - <span class="string"><span class="delimiter">"</span><span class="content">80:80</span><span class="delimiter">"</span></span>
    <span class="key">links</span>:
      - <span class="string"><span class="content">fluentd</span></span>
    <span class="key">logging</span>:
      <span class="key">driver</span>: <span class="string"><span class="delimiter">"</span><span class="content">fluentd</span><span class="delimiter">"</span></span>
      <span class="key">options</span>:
        <span class="key">fluentd-address</span>: <span class="string"><span class="content">localhost:24224</span></span>
        <span class="key">tag</span>: <span class="string"><span class="content">httpd.access</span></span>

  <span class="key">fluentd</span>:
    <span class="key">build</span>: <span class="string"><span class="content">./fluentd</span></span>
    <span class="key">volumes</span>:
      - <span class="string"><span class="content">./fluentd/conf:/fluentd/etc</span></span>
    <span class="key">links</span>:
      - <span class="string"><span class="delimiter">"</span><span class="content">elasticsearch</span><span class="delimiter">"</span></span>
    <span class="key">ports</span>:
      - <span class="string"><span class="delimiter">"</span><span class="content">24224:24224</span><span class="delimiter">"</span></span>
      - <span class="string"><span class="delimiter">"</span><span class="content">24224:24224/udp</span><span class="delimiter">"</span></span>

  <span class="key">elasticsearch</span>:
    <span class="key">image</span>: <span class="string"><span class="content">elasticsearch</span></span>
    <span class="key">expose</span>:
      - <span class="string"><span class="content">9200</span></span>
    <span class="key">ports</span>:
      - <span class="string"><span class="delimiter">"</span><span class="content">9200:9200</span><span class="delimiter">"</span></span>

  <span class="key">kibana</span>:
    <span class="key">image</span>: <span class="string"><span class="content">kibana</span></span>
    <span class="key">links</span>:
      - <span class="string"><span class="delimiter">"</span><span class="content">elasticsearch</span><span class="delimiter">"</span></span>
    <span class="key">ports</span>:
      - <span class="string"><span class="delimiter">"</span><span class="content">5601:5601</span><span class="delimiter">"</span></span>
</pre>
<p><code>logging</code> section (check <a href="https://docs.docker.com/compose/compose-file/#/logging">Docker Compose documentation</a>) of <code>web</code> container specifies <a href="https://docs.docker.com/engine/admin/logging/fluentd/">Docker Fluentd Logging Driver</a> as a default container logging driver. All of the logs from <code>web</code> container will be automatically forwarded to host:port specified by <code>fluentd-address</code>.</p>
<a name="step-1:-prepare-fluentd-image-with-your-config-+-plugin"></a><h2>Step 1: Prepare Fluentd image with your Config + Plugin</h2>
<p>Then, please prepare <code>fluentd/Dockerfile</code> with the following content, to use Fluentd’s <a href="https://hub.docker.com/r/fluent/fluentd/">official Docker image</a> and additionally install Elasticsearch plugin.</p>
<pre class="CodeRay"># fluentd/Dockerfile
FROM fluent/fluentd:v0.12-debian
RUN ["gem", "install", "fluent-plugin-elasticsearch", "--no-rdoc", "--no-ri", "--version", "1.9.2"]
</pre>
<p>Then, please prepare Fluentd’s configuration file <code>fluentd/conf/fluent.conf</code>. <a href="in_forward">in_forward</a> plugin is used for receive logs from Docker logging driver, and out_elasticsearch is for forwarding logs to Elasticsearch.</p>
<pre class="CodeRay"># fluentd/conf/fluent.conf
<span class="tag">&lt;source&gt;</span>
  @type forward
  port 24224
  bind 0.0.0.0
<span class="tag">&lt;/source&gt;</span>
<span class="tag">&lt;match</span> <span class="error">*</span><span class="attribute-name">.</span><span class="error">*</span><span class="error">*</span><span class="tag">&gt;</span>
  @type copy
  <span class="tag">&lt;store&gt;</span>
    @type elasticsearch
    host elasticsearch
    port 9200
    logstash_format true
    logstash_prefix fluentd
    logstash_dateformat %Y%m%d
    include_tag_key true
    type_name access_log
    tag_key @log_name
    flush_interval 1s
  <span class="tag">&lt;/store&gt;</span>
  <span class="tag">&lt;store&gt;</span>
    @type stdout
  <span class="tag">&lt;/store&gt;</span>
<span class="tag">&lt;/match&gt;</span>
</pre>
<a name="step-2:-start-containers"></a><h2>Step 2: Start Containers</h2>
<p>Let’s start all of the containers, with just one command.</p>
<pre class="CodeRay"><span class="comment">$</span><span class="function"> docker-compose up
</span></pre>
<p>You can check to see if 4 containers are running by <code>docker ps</code> command.</p>
<pre class="CodeRay"><span class="comment">$</span><span class="function"> docker ps
</span><span class="string">CONTAINER ID        IMAGE                      COMMAND                  CREATED             STATUS              PORTS                                                          NAMES
</span><span class="string">2d28323d77a3        httpd                      "httpd-foreground"       About an hour ago   Up 43 seconds       0.0.0.0:80-&gt;80/tcp                                             dockercomposeefk_web_1
</span><span class="string">a1b15a7210f6        dockercomposeefk_fluentd   "/bin/sh -c 'exec ..."   About an hour ago   Up 45 seconds       5140/tcp, 0.0.0.0:24224-&gt;24224/tcp, 0.0.0.0:24224-&gt;24224/udp   dockercomposeefk_fluentd_1
</span><span class="string">01e43b191cc1        kibana                     "/docker-entrypoin..."   About an hour ago   Up 45 seconds       0.0.0.0:5601-&gt;5601/tcp                                         dockercomposeefk_kibana_1
</span><span class="string">b7b439415898        elasticsearch              "/docker-entrypoin..."   About an hour ago   Up 50 seconds       0.0.0.0:9200-&gt;9200/tcp, 9300/tcp                               dockercomposeefk_elasticsearch_1
</span></pre>
<a name="step-3:-generate-httpd-access-logs"></a><h2>Step 3: Generate httpd Access Logs</h2>
<p>Let’s access to <code>httpd</code> to generate some access logs. <code>curl</code> command is always your friend.</p>
<pre class="CodeRay"><span class="comment">$</span><span class="function"> repeat 10 curl http://localhost:80/
</span><span class="string">&lt;html&gt;&lt;body&gt;&lt;h1&gt;It works!&lt;/h1&gt;&lt;/body&gt;&lt;/html&gt;
</span><span class="string">&lt;html&gt;&lt;body&gt;&lt;h1&gt;It works!&lt;/h1&gt;&lt;/body&gt;&lt;/html&gt;
</span><span class="string">&lt;html&gt;&lt;body&gt;&lt;h1&gt;It works!&lt;/h1&gt;&lt;/body&gt;&lt;/html&gt;
</span><span class="string">&lt;html&gt;&lt;body&gt;&lt;h1&gt;It works!&lt;/h1&gt;&lt;/body&gt;&lt;/html&gt;
</span><span class="string">&lt;html&gt;&lt;body&gt;&lt;h1&gt;It works!&lt;/h1&gt;&lt;/body&gt;&lt;/html&gt;
</span><span class="string">&lt;html&gt;&lt;body&gt;&lt;h1&gt;It works!&lt;/h1&gt;&lt;/body&gt;&lt;/html&gt;
</span><span class="string">&lt;html&gt;&lt;body&gt;&lt;h1&gt;It works!&lt;/h1&gt;&lt;/body&gt;&lt;/html&gt;
</span><span class="string">&lt;html&gt;&lt;body&gt;&lt;h1&gt;It works!&lt;/h1&gt;&lt;/body&gt;&lt;/html&gt;
</span><span class="string">&lt;html&gt;&lt;body&gt;&lt;h1&gt;It works!&lt;/h1&gt;&lt;/body&gt;&lt;/html&gt;
</span><span class="string">&lt;html&gt;&lt;body&gt;&lt;h1&gt;It works!&lt;/h1&gt;&lt;/body&gt;&lt;/html&gt;
</span></pre>
<a name="step-4:-confirm-logs-from-kibana"></a><h2>Step 4: Confirm Logs from Kibana</h2>
<p>Please go to <code>http://localhost:5601/</code> with your browser. Then, you need to set up the index name pattern for Kibana. Please specify <code>fluentd-*</code> to <code>Index name or pattern</code> and press <code>Create</code> button.</p>
<center>
<img src="/images/efk-kibana-1.png" width="100%"/><br/>
</center>
<p><br/>
<br/></p>
<p>Then, go to <code>Discover</code> tab to seek for the logs. As you can see, logs are properly collected into Elasticsearch + Kibana, via Fluentd.</p>
<center>
<img src="/images/efk-kibana-2.png" width="100%"/><br/>
</center>
<p><br/>
<br/></p>
<a name="conclusion"></a><h2>Conclusion</h2>
<p>This article explains how to collect logs from Apache to EFK (Elasticsearch + Fluentd + Kibana). The example code is available in this repository.</p>
<ul>
<li><a href="https://github.com/kzk/docker-compose-efk">https://github.com/kzk/docker-compose-efk</a></li>
</ul>
<a name="learn-more"></a><h2>Learn More</h2>
<ul>
<li><a href="architecture">Fluentd Architecture</a></li>
<li><a href="quickstart">Fluentd Get Started</a></li>
<li><a href="http://www.fluentd.org/download">Downloading Fluentd</a></li>
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