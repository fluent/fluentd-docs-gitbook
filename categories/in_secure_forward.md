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
<h1>Secure Forward Input Plugin</h1>
</hgroup>
<p>The <code>in_secure_forward</code> input plugin accepts messages via <strong>SSL with authentication</strong> (cf. <a href="out_secure_forward">out_secure_forward</a>).</p>
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
<li class="sub-toc-item"><a href="#check-username/password-from-clients">Check username/password from Clients</a></li>
<li class="sub-toc-item"><a href="#deny-unknown-source-ip/hosts">Deny Unknown Source IP/hosts</a></li>
<li class="sub-toc-item"><a href="#secure-sender-receiver-setup">Secure Sender-Receiver Setup</a></li>
</ul>
<li class="toc-item"><a href="#parameters">Parameters</a></li>
<ul class="sub-toc">
<li class="sub-toc-item"><a href="#@type">@type</a></li>
<li class="sub-toc-item"><a href="#port-(integer)">port (integer)</a></li>
<li class="sub-toc-item"><a href="#bind-(string)">bind (string)</a></li>
<li class="sub-toc-item"><a href="#secure-(bool)">secure (bool)</a></li>
<li class="sub-toc-item"><a href="#self_hostname-(string)">self_hostname (string)</a></li>
<li class="sub-toc-item"><a href="#shared_key-(string)">shared_key (string)</a></li>
<li class="sub-toc-item"><a href="#allow_keepalive-(bool)">allow_keepalive (bool)</a></li>
<li class="sub-toc-item"><a href="#allow_anonymous_source-(bool)">allow_anonymous_source (bool)</a></li>
<li class="sub-toc-item"><a href="#authentication-(bool)">authentication (bool)</a></li>
<li class="sub-toc-item"><a href="#ca_cert_path-(string)">ca_cert_path (string)</a></li>
<li class="sub-toc-item"><a href="#ca_private_key_path-(string)">ca_private_key_path (string)</a></li>
<li class="sub-toc-item"><a href="#ca_private_key_passphrase-(string)">ca_private_key_passphrase (string)</a></li>
<li class="sub-toc-item"><a href="#read_length-(size)">read_length (size)</a></li>
<li class="sub-toc-item"><a href="#read_interval_msec-(integer)">read_interval_msec (integer)</a></li>
<li class="sub-toc-item"><a href="#socket_interval_msec-(integer)">socket_interval_msec (integer)</a></li>
</ul>
<li class="toc-item"><a href="#further-reading">Further Reading</a></li>
</ul>
</section>
<h2>Installation</h2>
<p><code>in_secure_forward</code> is <strong>not</strong> included in either <code>td-agent</code> package or <code>fluentd</code> gem. In order to install it, please refer to the <a href="plugin-management">Plugin Management</a> article.</p>
<a name="example-configurations"></a><h2>Example Configurations</h2>
<p>This section provides some example configurations for <code>in_secure_forward</code>.</p>
<a name="minimalist-configuration"></a><h3>Minimalist Configuration</h3>
<p>At first, generate private CA file by <code>secure-forward-ca-generate</code>, then copy that file to output plugin side by safe way (scp, or anyway else).</p>
<pre class="CodeRay">&lt;source&gt;
  @type secure_forward
  shared_key      secret_string
  self_hostname   server.fqdn.local  # This fqdn is used as CN (Common Name) of certificates
  secure true
  ca_cert_path        /path/to/certificate/ca_cert.pem
  ca_private_key_path /path/to/certificate/ca_key.pem
  ca_private_key_passphrase passphrase_for_private_CA_secret_key
&lt;/source&gt;
</pre>
<a name="check-username/password-from-clients"></a><h3>Check username/password from Clients</h3>
<pre class="CodeRay">&lt;source&gt;
  @type secure_forward
  shared_key         secret_string
  self_hostname      server.fqdn.local
  secure true
  ca_cert_path        /path/to/certificate/ca_cert.pem
  ca_private_key_path /path/to/certificate/ca_key.pem
  ca_private_key_passphrase passphrase_for_private_CA_secret_key
  authentication     yes # Deny clients without valid username/password
  &lt;user&gt;
    username tagomoris
    password foobar012
  &lt;/user&gt;
  &lt;user&gt;
    username frsyuki
    password yakiniku
  &lt;/user&gt;
&lt;/source&gt;
</pre>
<a name="deny-unknown-source-ip/hosts"></a><h3>Deny Unknown Source IP/hosts</h3>
<pre class="CodeRay">&lt;source&gt;
  @type secure_forward
  shared_key         secret_string
  self_hostname      server.fqdn.local
  secure true
  ca_cert_path        /path/to/certificate/ca_cert.pem
  ca_private_key_path /path/to/certificate/ca_key.pem
  ca_private_key_passphrase passphrase_for_private_CA_secret_key
  allow_anonymous_source no  # Allow to accept from nodes of &lt;client&gt;
  &lt;client&gt;
    host 192.168.10.30
    # network address (ex: 192.168.10.0/24) NOT Supported now
  &lt;/client&gt;
  &lt;client&gt;
    host your.host.fqdn.local
    # wildcard (ex: *.host.fqdn.local) NOT Supported now
  &lt;/client&gt;
&lt;/source&gt;
</pre>
<p>You can use the username/password check and client check together:</p>
<pre class="CodeRay">&lt;source&gt;
  @type secure_forward
  shared_key         secret_string
  self_hostname      server.fqdn.local
  secure true
  ca_cert_path        /path/to/certificate/ca_cert.pem
  ca_private_key_path /path/to/certificate/ca_key.pem
  ca_private_key_passphrase passphrase_for_private_CA_secret_key
  allow_anonymous_source no  # Allow to accept from nodes of &lt;client&gt;
  authentication         yes # Deny clients without valid username/password
  &lt;user&gt;
    username tagomoris
    password foobar012
  &lt;/user&gt;
  &lt;user&gt;
    username frsyuki
    password sukiyaki
  &lt;/user&gt;
  &lt;user&gt;
    username repeatedly
    password sushi
  &lt;/user
  &lt;client&gt;
    host 192.168.10.30      # allow all users to connect from 192.168.10.30
  &lt;/client&gt;
  &lt;client&gt;
    host  192.168.10.31
    users tagomoris,frsyuki # deny repeatedly from 192.168.10.31
  &lt;/client&gt;
  &lt;client&gt;
    host 192.168.10.32
    shared_key less_secret_string # limited shared_key for 192.168.10.32
    users      repeatedly         # and repeatedly only
  &lt;/client&gt;
&lt;/source&gt;
</pre>
<a name="secure-sender-receiver-setup"></a><h3>Secure Sender-Receiver Setup</h3>
<p>Please refer to the <strong>Secure Sender-Receiver Setup</strong> <a href="out_secure_forward#Secure-Sender-Receiver-Setup">sample documentation</a>.</p>
<a name="parameters"></a><h2>Parameters</h2>
<a name="@type"></a><h3>@type</h3>
<p>This parameter is required. Its value must be <code>secure_forward</code>.</p>
<a name="port-(integer)"></a><h3>port (integer)</h3>
<p>The default value is 24284.</p>
<a name="bind-(string)"></a><h3>bind (string)</h3>
<p>The default value is 0.0.0.0.</p>
<a name="secure-(bool)"></a><h3>secure (bool)</h3>
<p>Indicate published connection is secure or not. Specify <code>yes</code> (or <code>true</code>) if secure encryption needed.</p>
<a name="self_hostname-(string)"></a><h3>self_hostname (string)</h3>
<p>Default value of the auto-generated certificate common name (CN).</p>
<a name="shared_key-(string)"></a><h3>shared_key (string)</h3>
<p>Shared key between nodes.</p>
<a name="allow_keepalive-(bool)"></a><h3>allow_keepalive (bool)</h3>
<p>Accept keepalive connection. The default value is <code>true</code>.</p>
<a name="allow_anonymous_source-(bool)"></a><h3>allow_anonymous_source (bool)</h3>
<p>Accept connections from unknown hosts.</p>
<a name="authentication-(bool)"></a><h3>authentication (bool)</h3>
<p>Require password authentication. The default value is <code>false</code>.</p>
<a name="ca_cert_path-(string)"></a><h3>ca_cert_path (string)</h3>
<p>The path to the private CA certificate file, which is required to use private CA. (One of this parameter or <code>cert_path</code> is required for <code>secure yes</code> configuration.)</p>
<a name="ca_private_key_path-(string)"></a><h3>ca_private_key_path (string)</h3>
<p>The path to the private key for private CA certificate key file.</p>
<a name="ca_private_key_passphrase-(string)"></a><h3>ca_private_key_passphrase (string)</h3>
<p>The passphrase string for private key file, specified by <code>ca_private_key_path</code>.</p>
<a name="read_length-(size)"></a><h3>read_length (size)</h3>
<p>The number of bytes read per nonblocking read. The default value is 8MB=8<em>1024</em>1024 bytes.</p>
<a name="read_interval_msec-(integer)"></a><h3>read_interval_msec (integer)</h3>
<p>The interval between the non-blocking reads, in milliseconds. The default value is 50.</p>
<a name="socket_interval_msec-(integer)"></a><h3>socket_interval_msec (integer)</h3>
<p>The interval between SSL reconnects in milliseconds. The default value is 200.</p>
<h4>log_level option</h4>
<p>The <code>log_level</code> option allows the user to set different levels of logging for each plugin. The supported log levels are: <code>fatal</code>, <code>error</code>, <code>warn</code>, <code>info</code>, <code>debug</code>, and <code>trace</code>.</p>
<p>Please see the <a href="logging">logging article</a> for further details.</p>
<a name="further-reading"></a><h2>Further Reading</h2>
<ul>
<li><a href="https://github.com/tagomoris/fluent-plugin-secure-forward">fluent-plugin-secure-forward repository</a></li>
</ul>
<div style="text-align:right">
  Last updated: 2015-12-01 21:20:32 UTC
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