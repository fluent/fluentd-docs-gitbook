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
<h1>Kubernetes Logging with Fluentd</h1>
</hgroup>
<p><img alt="" src="/images/fluentd_kubernetes.png"/></p>
<p><a href="http://kubernetes.io">Kubernetes</a> provides two logging end-points for applications and cluster logs: Stackdriver Logging for use with Google Cloud Platform and Elasticsearch. Behind the scenes there is a logging agent that take cares of log collection, parsing and distribution: <a href="http://www.fluentd.org">Fluentd</a>.</p>
<p>The following document focus on how to deploy Fluentd in Kubernetes and extend the possibilities to have different destinations for your logs.</p>
<a name="getting-started"></a>
<section id="table-of-contents"><h3>Table of Contents</h3>
<ul id="toc">
<li class="toc-item"><a href="#getting-started">Getting Started</a></li>
<li class="toc-item"><a href="#fluentd-daemonset">Fluentd DaemonSet</a></li>
<ul class="sub-toc">
<li class="sub-toc-item"><a href="#get-fluentd-daemonset-sources">Get Fluentd DaemonSet sources</a></li>
<li class="sub-toc-item"><a href="#daemonset-content">DaemonSet Content</a></li>
</ul>
<li class="toc-item"><a href="#logging-to-elasticsearch">Logging to Elasticsearch</a></li>
<ul class="sub-toc">
<li class="sub-toc-item"><a href="#requirements">Requirements</a></li>
</ul>
</ul>
</section>
<h2>Getting Started</h2>
<p>The following document assumes that you have a Kubernetes cluster running or at least a local (single) node that can be used for testing purposes.</p>
<p>Before to get started, make sure you understand or have a basic idea about the following concepts from Kubernetes:</p>
<ul>
<li>
<a href="https://kubernetes.io/docs/admin/node/">Node</a>
<blockquote><p>A node is a worker machine in Kubernetes, previously known as a minion. A node may be a VM or physical machine, depending on the cluster. Each node has the services necessary to run pods and is managed by the master components…</p></blockquote>
</li>
<li>
<a href="https://kubernetes.io/docs/user-guide/pods/">Pod</a>
<blockquote><p>A pod (as in a pod of whales or pea pod) is a group of one or more containers (such as Docker containers), the shared storage for those containers, and options about how to run the containers. Pods are always co-located and co-scheduled, and run in a shared context…</p></blockquote>
</li>
<li>
<a href="https://kubernetes.io/docs/admin/daemons/">DaemonSet</a>
<blockquote><p>A DaemonSet ensures that all (or some) nodes run a copy of a pod. As nodes are added to the cluster, pods are added to them. As nodes are removed from the cluster, those pods are garbage collected. Deleting a DaemonSet will clean up the pods it created…</p></blockquote>
</li>
</ul>
<p>Since applications runs in Pods and multiple Pods might exists across multiple nodes, we need a specific Fluentd-Pod that takes care of log collection on each node: <a href="fluentd_daemonset.md">Fluentd DaemonSet</a>.</p>
<a name="fluentd-daemonset"></a><h2>Fluentd DaemonSet</h2>
<p>For <a href="https://kubernetes.io">Kubernetes</a>, a <a href="https://kubernetes.io/docs/admin/daemons/">DaemonSet</a> ensures that all (or some) nodes run a copy of a <em>pod</em>. In order to solve log collection we are going to implement a Fluentd DaemonSet.</p>
<p>Fluentd is flexible enough and have the proper plugins to distribute logs to different third party applications like databases or cloud services, so the principal question is to know: <em>where the logs will be stored ?</em>. Once we got that question answered, we can move forward configuring our DaemonSet.</p>
<p>The below steps will focus on sending the logs to a Elasticsearch Pod.</p>
<a name="get-fluentd-daemonset-sources"></a><h3>Get Fluentd DaemonSet sources</h3>
<p>We have created a Fluentd DaemonSet that have the proper rules and container image ready to get started:</p>
<ul>
<li><a href="https://github.com/fluent/fluentd-kubernetes-daemonset">https://github.com/fluent/fluentd-kubernetes-daemonset</a></li>
</ul>
<p>Please grab a copy of the repository from the command line using GIT:</p>
<pre class="CodeRay"><span class="comment">$</span><span class="function"> git clone https://github.com/fluent/fluentd-kubernetes-daemonset
</span></pre>
<a name="daemonset-content"></a><h3>DaemonSet Content</h3>
<p>The cloned repository contains the several configurations that allow to deploy Fluentd as a DaemonSet, the Docker container image distributed on the repository also comes pre-configured so Fluentd can gather all logs from the Kubernetes node environment and also it appends the proper metadata to the logs.</p>
<p>This repository has several presets for alpine/debian with popular outputs.</p>
<ul>
<li><a href="https://github.com/fluent/fluentd-kubernetes-daemonset/tree/master/docker-image/v0.12">DaemonSet preset settings</a></li>
</ul>
<a name="logging-to-elasticsearch"></a><h2>Logging to Elasticsearch</h2>
<a name="requirements"></a><h3>Requirements</h3>
<p>From the fluentd-kubernetes-daemonset/ directory, find the Yaml configuration file:</p>
<ul>
<li><a href="https://github.com/fluent/fluentd-kubernetes-daemonset/blob/master/fluentd-daemonset-elasticsearch.yaml">fluentd-daemonset-elasticsearch.yaml</a></li>
</ul>
<p>As an example let’s see a part of  the file content:</p>
<pre class="CodeRay">apiVersion: extensions/v1beta1
kind: DaemonSet
metadata:
  name: fluentd
  namespace: kube-system
  ...
spec:
    ...
    spec:
      containers:
      - name: fluentd
        image: quay.io/fluent/fluentd-kubernetes-daemonset
        env:
          - name:  FLUENT_ELASTICSEARCH_HOST
            value: "elasticsearch-logging"
          - name:  FLUENT_ELASTICSEARCH_PORT
            value: "9200"
        ...
</pre>
<p>The Yaml file have two relevant environment variables that are used by Fluentd when the container starts:</p>
<table>
<thead>
<tr>
<th> Environment Variable           </th>
<th> Description </th>
<th> Default              </th>
</tr>
</thead>
<tbody>
<tr>
<td> FLUENT_ELASTICSEARCH_HOST    </td>
<td> Specify the host name or IP address.</td>
<td>elasticsearch-logging </td>
</tr>
<tr>
<td> FLUENT_ELASTICSEARCH_PORT    </td>
<td> Elasticsearch TCP port             </td>
<td> 9200                 </td>
</tr>
</tbody>
</table>
<p>Any relevant change needs to be done to the Yaml file before to deploy it. Using the default values assumes that at least an Elasticsearch Pod <strong>elasticsearch-logging</strong> exists in the cluster.</p>
<div style="text-align:right">
  Last updated: 2017-02-13 20:29:22 UTC
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