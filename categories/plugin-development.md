<section id="main">
<div id="page">
<div class="topic_content">
<article>
<div style="text-align:right">
<div style="text-align:right">
Versions 
  
    
    | <a href="/v1.0/articles/plugin-development">v1.0 (td-agent3)</a>
    
  

  

  
    
    | <b><i>v0.12</i> (td-agent2)<b>
</b></b>
</div>
</div>
<hr size="1" style="margin-top: 10px; margin-bottom: 10px; color: rgba(0, 0, 0, .15);"/>
<hgroup>
<h1>Writing plugins</h1>
</hgroup>
<a name="installing-custom-plugins"></a>
<section id="table-of-contents"><h3>Table of Contents</h3>
<ul id="toc">
<li class="toc-item"><a href="#installing-custom-plugins">Installing custom plugins</a></li>
<li class="toc-item"><a href="#overview">Overview</a></li>
<ul class="sub-toc">
<li class="sub-toc-item"><a href="#fluentd-version-and-plugin-api">Fluentd version and Plugin API</a></li>
<li class="sub-toc-item"><a href="#send-a-patch-or-fork?">Send a patch or fork?</a></li>
</ul>
<li class="toc-item"><a href="#plugin-versioning-policy">Plugin versioning policy</a></li>
<li class="toc-item"><a href="#writing-input-plugins">Writing Input Plugins</a></li>
<ul class="sub-toc">
<li class="sub-toc-item"><a href="#record-format">Record format</a></li>
</ul>
<li class="toc-item"><a href="#writing-buffered-output-plugins">Writing Buffered Output Plugins</a></li>
<li class="toc-item"><a href="#writing-time-sliced-output-plugins">Writing Time Sliced Output Plugins</a></li>
<li class="toc-item"><a href="#writing-non-buffered-output-plugins">Writing Non-buffered Output Plugins</a></li>
<li class="toc-item"><a href="#filter-plugins">Filter Plugins</a></li>
<ul class="sub-toc">
<li class="sub-toc-item"><a href="#filter_stream-method">filter_stream method</a></li>
</ul>
<li class="toc-item"><a href="#parser-plugins">Parser Plugins</a></li>
<ul class="sub-toc">
<li class="sub-toc-item"><a href="#parser-api">Parser API</a></li>
</ul>
<li class="toc-item"><a href="#text-formatter-plugins">Text Formatter Plugins</a></li>
<li class="toc-item"><a href="#error-stream">Error stream</a></li>
<ul class="sub-toc">
<li class="sub-toc-item"><a href="#api">API</a></li>
</ul>
<li class="toc-item"><a href="#config_param">config_param</a></li>
<ul class="sub-toc">
<li class="sub-toc-item"><a href="#access-parameter-value">Access parameter value</a></li>
<li class="sub-toc-item"><a href="#supported-types">Supported types</a></li>
<li class="sub-toc-item"><a href="#supported-options">Supported options</a></li>
</ul>
<li class="toc-item"><a href="#debugging-plugins">Debugging plugins</a></li>
<li class="toc-item"><a href="#writing-test-cases">Writing test cases</a></li>
<ul class="sub-toc">
<li class="sub-toc-item"><a href="#run-test">Run test</a></li>
</ul>
<li class="toc-item"><a href="#further-reading">Further Reading</a></li>
</ul>
</section>
<h2>Installing custom plugins</h2>
<p>To install a plugin, please put the ruby script in the <code>/etc/fluent/plugin</code> directory.</p>
<p>Alternatively, you can create a Ruby Gem package that includes a <code>lib/fluent/plugin/&lt;TYPE&gt;_&lt;NAME&gt;.rb</code> file. The <em>TYPE</em> is:</p>
<ul>
<li>
<code>in</code> for input plugins</li>
<li>
<code>out</code> for output plugins</li>
<li>
<code>filter</code> for filter plugins</li>
<li>
<code>buf</code> for buffer plugins</li>
<li>
<code>parser</code> for parser plugins</li>
<li>
<code>formatter</code> for formatter plugins</li>
</ul>
<p>For example, an email Output plugin would have the path: <code>lib/fluent/plugin/out_mail.rb</code>. The packaged gem can be distributed and installed using RubyGems. For further information, please see the <a href="http://www.fluentd.org/plugins">list of Fluentd plugins</a> for third-party plugins.</p>
<a name="overview"></a><h2>Overview</h2>
<p>The following slides can help the user understand how Fluentd works before they dive into writing their own plugins.</p>
<iframe allowfullscreen="" frameborder="0" height="356" marginheight="0" marginwidth="0" scrolling="no" src="//www.slideshare.net/slideshow/embed_code/39324320?startSlide=9" style="border:1px solid #CCC; border-width:1px; margin-bottom:5px; max-width: 100%;" width="427"> </iframe>
<p>(The slides are taken from <a href="//github.com/sonots">Naotoshi Seo’s</a> <a href="//rubykaigi.org/2014/presentation/S-NaotoshiSeo">RubyKaigi 2014 talk</a>.)</p>
<a name="fluentd-version-and-plugin-api"></a><h3>Fluentd version and Plugin API</h3>
<p>Fluentd now has two active versions, v0.12 and v1.0.
v0.12 is old stable and many people still use this version.
v1.0 is current stable version and this version has brand-new Plugin API.</p>
<p>The important point is plugin for v0.12 works with v0.12 and v1.0, but
new v1.0 API based Plugin doesn’t work with v0.12.</p>
<p>This document based on v0.12 Plugin API.</p>
<a name="send-a-patch-or-fork?"></a><h3>Send a patch or fork?</h3>
<p>If you have a problem with existing plugins or new feature idea, sending a patch is better.
If the plugin author is non-active, try to become new plugin maintainer first.
Forking a plugin and release alternative plugin, e.g. fluent-plugin-xxx-alt, is final approach.</p>
<a name="plugin-versioning-policy"></a><h2>Plugin versioning policy</h2>
<p>If you don’t have a your policy, following semantic versioning is better.</p>
<p><a href="http://semver.org/">Semantic Versioning 2.0.0 - Semantic Versioning</a></p>
<p>The important thing is if your plugin breaks the backward compatibiliy, update major version to avoid user troubles.
For example, new v0.14 API based plugin doesn’t work with fluentd v0.12. So if you release your existing plugin with new v0.14 API,
please update major version, <code>0.5.0</code> -&gt; <code>1.0.0</code>, <code>1.2.0</code> -&gt; <code>2.0.0</code>.</p>
<a name="writing-input-plugins"></a><h2>Writing Input Plugins</h2>
<p>Extend the <strong>Fluent::Input</strong> class and implement the following methods. In <code>initialize</code>, <code>configure</code> and <code>start</code>, <code>super</code> should be called to call Input plugin default behaviour.</p>
<pre class="CodeRay">require <span class="string"><span class="delimiter">'</span><span class="content">fluent/input</span><span class="delimiter">'</span></span>

<span class="keyword">module</span> <span class="class">Fluent</span>
  <span class="keyword">class</span> <span class="class">SomeInput</span> &lt; <span class="constant">Input</span>
    <span class="comment"># First, register the plugin. NAME is the name of this plugin</span>
    <span class="comment"># and identifies the plugin in the configuration file.</span>
    <span class="constant">Fluent</span>::<span class="constant">Plugin</span>.register_input(<span class="string"><span class="delimiter">'</span><span class="content">NAME</span><span class="delimiter">'</span></span>, <span class="predefined-constant">self</span>)

    <span class="comment"># config_param defines a parameter. You can refer a parameter via @port instance variable</span>
    <span class="comment"># :default means this parameter is optional</span>
    config_param <span class="symbol">:port</span>, <span class="symbol">:integer</span>, <span class="symbol">:default</span> =&gt; <span class="integer">8888</span>

    <span class="comment"># This method is called before starting.</span>
    <span class="comment"># 'conf' is a Hash that includes configuration parameters.</span>
    <span class="comment"># If the configuration is invalid, raise Fluent::ConfigError.</span>
    <span class="keyword">def</span> <span class="function">configure</span>(conf)
      <span class="keyword">super</span>

      <span class="comment"># You can also refer to raw parameter via conf[name].</span>
      <span class="instance-variable">@port</span> = conf[<span class="string"><span class="delimiter">'</span><span class="content">port</span><span class="delimiter">'</span></span>]
      ...
    <span class="keyword">end</span>

    <span class="comment"># This method is called when starting.</span>
    <span class="comment"># Open sockets or files and create a thread here.</span>
    <span class="keyword">def</span> <span class="function">start</span>
      <span class="keyword">super</span>
      ...
    <span class="keyword">end</span>

    <span class="comment"># This method is called when shutting down.</span>
    <span class="comment"># Shutdown the thread and close sockets or files here.</span>
    <span class="keyword">def</span> <span class="function">shutdown</span>
      <span class="keyword">super</span>
      ...
    <span class="keyword">end</span>
  <span class="keyword">end</span>
<span class="keyword">end</span>
</pre>
<p>To submit events, use the <code>router.emit(tag, time, record)</code> method, where <code>tag</code> is the String, <code>time</code> is the UNIX time integer and <code>record</code> is a Hash object.</p>
<pre class="CodeRay">tag = <span class="string"><span class="delimiter">"</span><span class="content">myapp.access</span><span class="delimiter">"</span></span>
time = <span class="constant">Engine</span>.now
record = {<span class="string"><span class="delimiter">"</span><span class="content">message</span><span class="delimiter">"</span></span>=&gt;<span class="string"><span class="delimiter">"</span><span class="content">body</span><span class="delimiter">"</span></span>}
router.emit(tag, time, record)
</pre>
<p>To submit multiple events in one call, use the <code>router.emit_stream(tag, es)</code> and <code>MultiEventStream</code> combo instead.</p>
<pre class="CodeRay">es = <span class="constant">MultiEventStream</span>.new
records.each { |record|
  es.add(time, record)
}
router.emit_stream(tag, es)
</pre>
<a name="record-format"></a><h3>Record format</h3>
<p>Fluentd plugins assume the record is a JSON so the key should be the String, not Symbol.
If you emit a symbol keyed record, it may cause a problem.</p>
<pre class="CodeRay">router.emit(tag, time, {<span class="string"><span class="delimiter">'</span><span class="content">foo</span><span class="delimiter">'</span></span> =&gt; <span class="string"><span class="delimiter">'</span><span class="content">bar</span><span class="delimiter">'</span></span>})  <span class="comment"># OK!</span>
router.emit(tag, time, {<span class="symbol">:foo</span> =&gt; <span class="string"><span class="delimiter">'</span><span class="content">bar</span><span class="delimiter">'</span></span>})   <span class="comment"># NG!</span>
</pre>
<a name="writing-buffered-output-plugins"></a><h2>Writing Buffered Output Plugins</h2>
<p>Extend the <strong>Fluent::BufferedOutput</strong> class and implement the following methods. In <code>initialize</code>, <code>configure</code> and <code>start</code>, <code>super</code> should be called to call BufferedOutput plugin default behaviour.</p>
<pre class="CodeRay">require <span class="string"><span class="delimiter">'</span><span class="content">fluent/output</span><span class="delimiter">'</span></span>

<span class="keyword">module</span> <span class="class">Fluent</span>
  <span class="keyword">class</span> <span class="class">SomeOutput</span> &lt; <span class="constant">BufferedOutput</span>
    <span class="comment"># First, register the plugin. NAME is the name of this plugin</span>
    <span class="comment"># and identifies the plugin in the configuration file.</span>
    <span class="constant">Fluent</span>::<span class="constant">Plugin</span>.register_output(<span class="string"><span class="delimiter">'</span><span class="content">NAME</span><span class="delimiter">'</span></span>, <span class="predefined-constant">self</span>)

    <span class="comment"># config_param defines a parameter. You can refer a parameter via @path instance variable</span>
    <span class="comment"># Without :default, a parameter is required.</span>
    config_param <span class="symbol">:path</span>, <span class="symbol">:string</span>

    <span class="comment"># This method is called before starting.</span>
    <span class="comment"># 'conf' is a Hash that includes configuration parameters.</span>
    <span class="comment"># If the configuration is invalid, raise Fluent::ConfigError.</span>
    <span class="keyword">def</span> <span class="function">configure</span>(conf)
      <span class="keyword">super</span>

      <span class="comment"># You can also refer raw parameter via conf[name].</span>
      <span class="instance-variable">@path</span> = conf[<span class="string"><span class="delimiter">'</span><span class="content">path</span><span class="delimiter">'</span></span>]
      ...
    <span class="keyword">end</span>

    <span class="comment"># This method is called when starting.</span>
    <span class="comment"># Open sockets or files here.</span>
    <span class="keyword">def</span> <span class="function">start</span>
      <span class="keyword">super</span>
      ...
    <span class="keyword">end</span>

    <span class="comment"># This method is called when shutting down.</span>
    <span class="comment"># Shutdown the thread and close sockets or files here.</span>
    <span class="keyword">def</span> <span class="function">shutdown</span>
      <span class="keyword">super</span>
      ...
    <span class="keyword">end</span>

    <span class="comment"># This method is called when an event reaches to Fluentd.</span>
    <span class="comment"># Convert the event to a raw string.</span>
    <span class="keyword">def</span> <span class="function">format</span>(tag, time, record)
      [tag, time, record].to_json + <span class="string"><span class="delimiter">"</span><span class="char">\n</span><span class="delimiter">"</span></span>
      <span class="comment">## Alternatively, use msgpack to serialize the object.</span>
      <span class="comment"># [tag, time, record].to_msgpack</span>
    <span class="keyword">end</span>

    <span class="comment"># This method is called every flush interval. Write the buffer chunk</span>
    <span class="comment"># to files or databases here.</span>
    <span class="comment"># 'chunk' is a buffer chunk that includes multiple formatted</span>
    <span class="comment"># events. You can use 'data = chunk.read' to get all events and</span>
    <span class="comment"># 'chunk.open {|io| ... }' to get IO objects.</span>
    <span class="comment">#</span>
    <span class="comment"># NOTE! This method is called by internal thread, not Fluentd's main thread. So IO wait doesn't affect other plugins.</span>
    <span class="keyword">def</span> <span class="function">write</span>(chunk)
      data = chunk.read
      print data
    <span class="keyword">end</span>

    <span class="comment">## Optionally, you can use chunk.msgpack_each to deserialize objects.</span>
    <span class="comment">#def write(chunk)</span>
    <span class="comment">#  chunk.msgpack_each {|(tag,time,record)|</span>
    <span class="comment">#  }</span>
    <span class="comment">#end</span>
  <span class="keyword">end</span>
<span class="keyword">end</span>
</pre>
<a name="writing-time-sliced-output-plugins"></a><h2>Writing Time Sliced Output Plugins</h2>
<p>Time Sliced Output plugins are extended versions of buffered output plugins. One example of a time sliced output is the <code>out_file</code> plugin.</p>
<p>Note that Time Sliced Output plugins use file buffer by default. Thus the <code>buffer_path</code> option is required.</p>
<p>To implement a Time Sliced Output plugin, extend the <strong>Fluent::TimeSlicedOutput</strong> class and implement the following methods.</p>
<pre class="CodeRay">require <span class="string"><span class="delimiter">'</span><span class="content">fluent/output</span><span class="delimiter">'</span></span>

<span class="keyword">module</span> <span class="class">Fluent</span>
  <span class="keyword">class</span> <span class="class">SomeOutput</span> &lt; <span class="constant">TimeSlicedOutput</span>
    <span class="comment"># configure(conf), start(), shutdown() and format(tag, time, record) are</span>
    <span class="comment"># the same as BufferedOutput.</span>
    ...

    <span class="comment"># You can use 'chunk.key' to get sliced time. The format of 'chunk.key'</span>
    <span class="comment"># can be configured by the 'time_format' option. The default format is %Y%m%d.</span>
    <span class="keyword">def</span> <span class="function">write</span>(chunk)
      day = chunk.key
      ...
    <span class="keyword">end</span>
  <span class="keyword">end</span>
<span class="keyword">end</span>
</pre>
<a name="writing-non-buffered-output-plugins"></a><h2>Writing Non-buffered Output Plugins</h2>
<p>Extend the <strong>Fluent::Output</strong> class and implement the following methods. <strong>Output</strong> plugin is often used for implementing filter like plugin. In <code>initialize</code>, <code>configure</code> and <code>start</code>, <code>super</code> should be called to call non-buffered Output plugin default behaviour.</p>
<pre class="CodeRay">require <span class="string"><span class="delimiter">'</span><span class="content">fluent/output</span><span class="delimiter">'</span></span>

<span class="keyword">module</span> <span class="class">Fluent</span>
  <span class="keyword">class</span> <span class="class">SomeOutput</span> &lt; <span class="constant">Output</span>
    <span class="comment"># First, register the plugin. NAME is the name of this plugin</span>
    <span class="comment"># and identifies the plugin in the configuration file.</span>
    <span class="constant">Fluent</span>::<span class="constant">Plugin</span>.register_output(<span class="string"><span class="delimiter">'</span><span class="content">NAME</span><span class="delimiter">'</span></span>, <span class="predefined-constant">self</span>)

    <span class="comment"># This method is called before starting.</span>
    <span class="keyword">def</span> <span class="function">configure</span>(conf)
      <span class="keyword">super</span>
      ...
    <span class="keyword">end</span>

    <span class="comment"># This method is called when starting.</span>
    <span class="keyword">def</span> <span class="function">start</span>
      <span class="keyword">super</span>
      ...
    <span class="keyword">end</span>

    <span class="comment"># This method is called when shutting down.</span>
    <span class="keyword">def</span> <span class="function">shutdown</span>
      <span class="keyword">super</span>
      ...
    <span class="keyword">end</span>

    <span class="comment"># This method is called when an event reaches Fluentd.</span>
    <span class="comment"># 'es' is a Fluent::EventStream object that includes multiple events.</span>
    <span class="comment"># You can use 'es.each {|time,record| ... }' to retrieve events.</span>
    <span class="comment"># 'chain' is an object that manages transactions. Call 'chain.next' at</span>
    <span class="comment"># appropriate points and rollback if it raises an exception.</span>
    <span class="comment">#</span>
    <span class="comment"># NOTE! This method is called by Fluentd's main thread so you should not write slow routine here. It causes Fluentd's performance degression.</span>
    <span class="keyword">def</span> <span class="function">emit</span>(tag, es, chain)
      chain.next
      es.each {|time,record|
        log.info <span class="string"><span class="delimiter">"</span><span class="content">OK!</span><span class="delimiter">"</span></span>
      }
    <span class="keyword">end</span>
  <span class="keyword">end</span>
<span class="keyword">end</span>
</pre>
<a name="filter-plugins"></a><h2>Filter Plugins</h2>
<p>This section shows how to write custom filters in addition to <a href="filter-plugin-overview">the core filter plugins</a>. The plugin files whose names start with “filter_” are registered as filter plugins.</p>
<p>Here is the implementation of the most basic filter that passes through all events as-is:</p>
<pre class="CodeRay">require <span class="string"><span class="delimiter">'</span><span class="content">fluent/filter</span><span class="delimiter">'</span></span>

<span class="keyword">module</span> <span class="class">Fluent</span>
  <span class="keyword">class</span> <span class="class">PassThruFilter</span> &lt; <span class="constant">Filter</span>
    <span class="comment"># Register this filter as "passthru"</span>
    <span class="constant">Fluent</span>::<span class="constant">Plugin</span>.register_filter(<span class="string"><span class="delimiter">'</span><span class="content">passthru</span><span class="delimiter">'</span></span>, <span class="predefined-constant">self</span>)

    <span class="comment"># config_param works like other plugins</span>

    <span class="keyword">def</span> <span class="function">configure</span>(conf)
      <span class="keyword">super</span>
      <span class="comment"># do the usual configuration here</span>
    <span class="keyword">end</span>

    <span class="keyword">def</span> <span class="function">start</span>
      <span class="keyword">super</span>
      <span class="comment"># This is the first method to be called when it starts running</span>
      <span class="comment"># Use it to allocate resources, etc.</span>
    <span class="keyword">end</span>

    <span class="keyword">def</span> <span class="function">shutdown</span>
      <span class="keyword">super</span>
      <span class="comment"># This method is called when Fluentd is shutting down.</span>
      <span class="comment"># Use it to free up resources, etc.</span>
    <span class="keyword">end</span>

    <span class="keyword">def</span> <span class="function">filter</span>(tag, time, record)
      <span class="comment"># This method implements the filtering logic for individual filters</span>
      <span class="comment"># It is internal to this class and called by filter_stream unless</span>
      <span class="comment"># the user overrides filter_stream.</span>
      <span class="comment">#</span>
      <span class="comment"># Since our example is a pass-thru filter, it does nothing and just</span>
      <span class="comment"># returns the record as-is.</span>
      <span class="comment"># If returns nil, that records are ignored.</span>
      record
    <span class="keyword">end</span>
  <span class="keyword">end</span>
<span class="keyword">end</span>
</pre>
<p>In <code>initialize</code>, <code>configure</code>, <code>start</code> and <code>shutdown</code>, <code>super</code> should be called to call Filter plugin default behaviour.</p>
<p>See <a href="/articles/plugin-development#writing-input-plugins">Writing Input plugins</a> section for the details of <code>tag</code>, <code>time</code> and <code>record</code>.</p>
<a name="filter_stream-method"></a><h3>filter_stream method</h3>
<p>Almost plugins could be implemented by overriding <code>filter</code> method. But if you want to mutate the event stream itself, you can override <code>filter_stream</code> method.</p>
<p>Here is the default implementation of <code>filter_stream</code>.</p>
<pre class="CodeRay"><span class="keyword">def</span> <span class="function">filter_stream</span>(tag, es)
  new_es = <span class="constant">MultiEventStream</span>.new
  es.each { |time, record|
    <span class="keyword">begin</span>
      filtered_record = filter(tag, time, record)
      new_es.add(time, filtered_record) <span class="keyword">if</span> filtered_record
    <span class="keyword">rescue</span> =&gt; e
      router.emit_error_event(tag, time, record, e)
    <span class="keyword">end</span>
  }
  new_es
<span class="keyword">end</span>
</pre>
<p><code>filter_stream</code> should return <a href="https://github.com/fluent/fluentd/blob/master/lib/fluent/event.rb">EventStream</a> object.</p>
<a name="parser-plugins"></a><h2>Parser Plugins</h2>
<p>Fluentd supports <a href="parser-plugin-overview">pluggable, customizable formats for input plugins</a>. The plugin files whose names start with “parser_” are registered as Parser Plugins.</p>
<p>Here is an example of a custom parser that parses the following newline-delimited log format:</p>
<pre class="CodeRay">&lt;timestamp&gt;&lt;SPACE&gt;key1=value1&lt;DELIMITER&gt;key2=value2&lt;DELIMITER&gt;key3=value...
</pre>
<p>e.g., something like this</p>
<pre class="CodeRay">2014-04-01T00:00:00 name=jake age=100 action=debugging
</pre>
<p>While it is not hard to write a regular expression to match this format, it is tricky to extract and save key names.</p>
<p>Here is the code to parse this custom format (let’s call it <code>time_key_value</code>). It takes one optional parameter called <code>delimiter</code>, which is the delimiter for key-value pairs. It also takes <code>time_format</code> to parse the time string. In <code>initialize</code>, <code>configure</code> and <code>start</code>, <code>super</code> should be called to call Parser plugin default behaviour.</p>
<pre class="CodeRay">require <span class="string"><span class="delimiter">'</span><span class="content">fluent/parser</span><span class="delimiter">'</span></span>

<span class="keyword">module</span> <span class="class">Fluent</span>
  <span class="keyword">class</span> <span class="class">TextParser</span>
    <span class="keyword">class</span> <span class="class">TimeKeyValueParser</span> &lt; <span class="constant">Parser</span>
      <span class="comment"># Register this parser as "time_key_value"</span>
      <span class="constant">Plugin</span>.register_parser(<span class="string"><span class="delimiter">"</span><span class="content">time_key_value</span><span class="delimiter">"</span></span>, <span class="predefined-constant">self</span>)

      config_param <span class="symbol">:delimiter</span>, <span class="symbol">:string</span>, <span class="symbol">:default</span> =&gt; <span class="string"><span class="delimiter">"</span><span class="content"> </span><span class="delimiter">"</span></span> <span class="comment"># delimiter is configurable with " " as default</span>
      config_param <span class="symbol">:time_format</span>, <span class="symbol">:string</span>, <span class="symbol">:default</span> =&gt; <span class="predefined-constant">nil</span> <span class="comment"># time_format is configurable</span>

      <span class="comment"># This method is called after config_params have read configuration parameters</span>
      <span class="keyword">def</span> <span class="function">configure</span>(conf)
        <span class="keyword">super</span>

        <span class="keyword">if</span> <span class="instance-variable">@delimiter</span>.length != <span class="integer">1</span>
          raise <span class="constant">ConfigError</span>, <span class="string"><span class="delimiter">"</span><span class="content">delimiter must be a single character. </span><span class="inline"><span class="inline-delimiter">#{</span><span class="instance-variable">@delimiter</span><span class="inline-delimiter">}</span></span><span class="content"> is not.</span><span class="delimiter">"</span></span>
        <span class="keyword">end</span>

        <span class="comment"># TimeParser class is already given. It takes a single argument as the time format</span>
        <span class="comment"># to parse the time string with.</span>
        <span class="instance-variable">@time_parser</span> = <span class="constant">TimeParser</span>.new(<span class="instance-variable">@time_format</span>)
      <span class="keyword">end</span>

      <span class="comment"># This is the main method. The input "text" is the unit of data to be parsed.</span>
      <span class="comment"># If this is the in_tail plugin, it would be a line. If this is for in_syslog,</span>
      <span class="comment"># it is a single syslog message.</span>
      <span class="keyword">def</span> <span class="function">parse</span>(text)
        time, key_values = text.split(<span class="string"><span class="delimiter">"</span><span class="content"> </span><span class="delimiter">"</span></span>, <span class="integer">2</span>)
        time = <span class="instance-variable">@time_parser</span>.parse(time)
        record = {}
        key_values.split(<span class="instance-variable">@delimiter</span>).each { |kv|
          k, v = kv.split(<span class="string"><span class="delimiter">"</span><span class="content">=</span><span class="delimiter">"</span></span>, <span class="integer">2</span>)
          record[k] = v
        }
        <span class="keyword">yield</span> time, record
      <span class="keyword">end</span>
    <span class="keyword">end</span>
  <span class="keyword">end</span>
<span class="keyword">end</span>
</pre>
<p>Then, save this code in <code>parser_time_key_value.rb</code> in a loadable plugin path. Then, if in_tail is configured as</p>
<pre class="CodeRay"># Other lines...
&lt;source&gt;
  @type tail
  path /path/to/input/file
  format time_key_value
&lt;/source&gt;
</pre>
<p>Then, the log line like <code>2014-01-01T00:00:00 k=v a=b</code> is parsed as <code>2013-01-01 00:00:00 +0000 test: {"k":"v","a":"b"}</code>.</p>
<a name="parser-api"></a><h3>Parser API</h3>
<p>Current <code>Parser#parse</code> API is called with block. We will remove <code>Parser#parse</code> with return value API since v0.14 or later.</p>
<pre class="CodeRay"><span class="comment"># OK</span>
parser.parse(text) { |time, record| ... }
<span class="comment"># NG. This API will be removed</span>
time, record = parser.parse(text) <span class="comment"># or parser.call(text)</span>
</pre>
<a name="text-formatter-plugins"></a><h2>Text Formatter Plugins</h2>
<p>Fluentd supports <a href="formatter-plugin-overview">pluggable, customizable formats for output plugins</a>. The plugin files whose names start with “formatter_” are registered as Formatter Plugins.</p>
<p>Here is an example of a custom formatter that outputs events as CSVs. It takes a required parameter called “csv_fields” and outputs the fields. It assumes that the values of the fields are already valid CSV fields. In <code>initialize</code>, <code>configure</code> and <code>start</code>, <code>super</code> should be called to call Formatter plugin default behaviour.</p>
<pre class="CodeRay">require <span class="string"><span class="delimiter">'</span><span class="content">fluent/formatter</span><span class="delimiter">'</span></span>

<span class="keyword">module</span> <span class="class">Fluent</span>
  <span class="keyword">module</span> <span class="class">TextFormatter</span>
    <span class="keyword">class</span> <span class="class">MyCSVFormatter</span> &lt; <span class="constant">Formatter</span>
      <span class="comment"># Register MyCSVFormatter as "my_csv".</span>
      <span class="constant">Plugin</span>.register_formatter(<span class="string"><span class="delimiter">"</span><span class="content">my_csv</span><span class="delimiter">"</span></span>, <span class="predefined-constant">self</span>)

      include <span class="constant">HandleTagAndTimeMixin</span> <span class="comment"># If you wish to use tag_key, time_key, etc.          </span>
      config_param <span class="symbol">:csv_fields</span>, <span class="symbol">:array</span>, <span class="key">value_type</span>: <span class="symbol">:string</span>

      <span class="comment"># This method does further processing. Configuration parameters can be</span>
      <span class="comment"># accessed either via "conf" hash or member variables.</span>
      <span class="keyword">def</span> <span class="function">configure</span>(conf)
        <span class="keyword">super</span>
      <span class="keyword">end</span>

      <span class="comment"># This is the method that formats the data output.</span>
      <span class="keyword">def</span> <span class="function">format</span>(tag, time, record)
        values = []

        <span class="comment"># Look up each required field and collect them from the record</span>
        <span class="instance-variable">@csv_fields</span>.each <span class="keyword">do</span> |field|
          v = record[field]
          <span class="keyword">if</span> <span class="keyword">not</span> v
            <span class="global-variable">$log</span>.error <span class="string"><span class="delimiter">"</span><span class="inline"><span class="inline-delimiter">#{</span>field<span class="inline-delimiter">}</span></span><span class="content"> is missing.</span><span class="delimiter">"</span></span>
          <span class="keyword">end</span>
          values &lt;&lt; v
        <span class="keyword">end</span>

        <span class="comment"># Output by joining the fields with a comma</span>
        values.join(<span class="string"><span class="delimiter">"</span><span class="content">,</span><span class="delimiter">"</span></span>)
      <span class="keyword">end</span>
    <span class="keyword">end</span>        
  <span class="keyword">end</span>
<span class="keyword">end</span>
</pre>
<p>Then, save this code in <code>formatter_my_csv.rb</code> in a loadable plugin path. Then, if out_file is configured as</p>
<pre class="CodeRay"># Other lines...
&lt;match test&gt;
  @type file
  path /path/to/output/file
  format my_csv
  csv_fields k1,k2
&lt;/match&gt;
</pre>
<p>and if the record <code>{"k1": 100, "k2": 200}</code> is matched, the output file should look like <code>100,200</code></p>
<a name="error-stream"></a><h2>Error stream</h2>
<p><code>router</code> has <code>emit_error_event</code> API to rescue invalid events.
Emitted events via <code>emit_error_event</code> are routed to <code>@ERROR</code> label.</p>
<p>There are several use cases:</p>
<ul>
<li>Rescue invalid event which hard to apply filter routine, e.g. don’t have geoip target field.</li>
<li>Rescue invalid event which hard to serialize in the output, e.g. can’t convert a record into BSON.</li>
</ul>
<a name="api"></a><h3>API</h3>
<pre class="CodeRay"> :::text
 router.emit_error_event(tag, time, record, error)
</pre>
<ul>
<li>tag: String: recommend to use incoming event tag</li>
<li>time: Integer: recommend to use incoming event time</li>
<li>record: Hash: recommend to use incoming event record</li>
<li>error: Exception: use a raised exception</li>
</ul>
<a name="config_param"></a><h2>config_param</h2>
<p><code>config_param</code> helper defines plugin parameter. You don’t need to parse parameters manually.
<code>config_param</code> syntax is <code>config_param :name, :type, options</code>. Here is simple example:</p>
<pre class="CodeRay">config_param :param1, :string
config_param :param2, :integer, default: 10
</pre>
<p>In this example, <code>param1</code> is required string parameter. If a user doesn’t specify <code>param1</code>, fluentd raises an <code>ConfigError</code>.<br/>
On the other hand, <code>param2</code> is optional integer parameter. If a user doesn’t specify <code>param2</code>, fluentd set <code>10</code> to <code>param2</code> automatically.
If a user sets “5” to <code>param2</code> parameter, fluentd converts it into integer type automatically.</p>
<a name="access-parameter-value"></a><h3>Access parameter value</h3>
<p><code>config_param</code> sets parsed result to <code>:name</code> instance variable after <code>configure</code> call. See example below:</p>
<pre class="CodeRay">config_param :param, :string

def configure(conf)
  super # This super is needed to parse conf by config_param

  p @param # You can access parsed result via instance variable. :param is used for variable name
end
</pre>
<a name="supported-types"></a><h3>Supported types</h3>
<p>Fluentd supports following built-in types for plugin parameter:</p>
<pre class="CodeRay"># hello, /path/to/file, etc
config_param :str_param, :string
# -1, 100, 100000, etc
config_param :int_param, :integer
# 0.1, 999.9, etc
config_param :float_param, :float
# true: yes / true, false: no / false
config_param :bool_param, :bool
# json object: {"k":"v"}, {"k", 10}
config_param :hash_param, :hash
# json array: [1, 10], ["foo", "bar"]
config_param :array_param, :array, value_type: :integer
# integer with size unit: 1k, 2m, 3g, 4t
config_param :size_param, :size
# integer with time unit: 1s, 2m, 3h, 4d
config_param :time_param, :time
# fixed list with `list` option: [:text, :gzip]
config_param :enum_param, :enum, list: [:tcp, :udp]
</pre>
<a name="supported-options"></a><h3>Supported options</h3>
<ul>
<li>
<code>default</code>: Specified parameter becomes optional. <code>type</code> value or <code>nil</code> are available: <code>default: 10</code>, <code>default: nil</code>.</li>
<li>
<code>secret</code>: Specified parameter is masked when dump a configuration, e.g. start logs, in_monitor_agent result: <code>secret: true</code>
</li>
<li>
<code>deprecated</code>: Specified parameter is showed in warning log. Need deprecated message for value: <code>deprecated: "Use xxx instead"</code>
</li>
<li>
<code>obsoleted</code>: Specified parameter is showed in error log with configuration error. Need obsoleted message for value: <code>obsoleted: "Use xxx instead"</code>
</li>
</ul>
<p>These options can be combined.</p>
<pre class="CodeRay">config_param :param, :array, default: [1, 2], secret: true, deprecated: "Use new_param instead"
</pre>
<a name="debugging-plugins"></a><h2>Debugging plugins</h2>
<p>Run <code>fluentd</code> with the <code>-vv</code> option to show debug messages:</p>
<pre class="CodeRay"><span class="comment">$</span><span class="function"> fluentd -vv
</span></pre>
<p>The <strong>stdout</strong> and <strong>copy</strong> output plugins are useful for debugging. The <strong>stdout</strong> output plugin dumps matched events to the console. It can be used as follows:</p>
<pre class="CodeRay"># You want to debug this plugin.
&lt;source&gt;
  @type your_custom_input_plugin
&lt;/source&gt;

# Dump all events to stdout.
&lt;match **&gt;
  @type stdout
&lt;/match&gt;
</pre>
<p>The <strong>copy</strong> output plugin copies matched events to multiple output plugins. You can use it in conjunction with the stdout plugin:</p>
<pre class="CodeRay">&lt;source&gt;
  @type forward
&lt;/source&gt;

# Use the forward Input plugin and the fluent-cat command to feed events:
#  $ echo '{"event":"message"}' | fluent-cat test.tag
&lt;match test.tag&gt;
  @type copy

  # Dump the matched events.
  &lt;store&gt;
    @type stdout
  &lt;/store&gt;

  # Feed the dumped events to your plugin.
  &lt;store&gt;
    @type your_custom_output_plugin
  &lt;/store&gt;
&lt;/match&gt;
</pre>
<p>You can use <strong>stdout</strong> filter instead of <strong>copy</strong> and <strong>stdout</strong> combination. The result is same as above but more simpler.</p>
<pre class="CodeRay">&lt;source&gt;
  @type forward
&lt;/source&gt;

&lt;filter&gt;
  @type stdout
&lt;/filter&gt;

&lt;match test.tag&gt;
  @type your_custom_output_plugin
&lt;/match&gt;
</pre>
<a name="writing-test-cases"></a><h2>Writing test cases</h2>
<p>Fluentd provides unit test frameworks for plugins:</p>
<pre class="CodeRay">Fluent::Test::InputTestDriver
  Test driver for input plugins.

Fluent::Test::BufferedOutputTestDriver
  Test driver for buffered output plugins.

Fluent::Test::OutputTestDriver
  Test driver for non-buffered output plugins.
</pre>
<p>Please see Fluentd’s source code for details.</p>
<a name="run-test"></a><h3>Run test</h3>
<p>Fluentd test follows standard gem way and uses test-unit library. Use rake command.</p>
<pre class="CodeRay">$ bundle install --path vendor/bundle # Install related libraries.
$ bundle exec rake test
</pre>
<p>If you want to run only one file, use <code>TEST</code> environment variable:</p>
<pre class="CodeRay">$ bundle exec rake test TEST=test/plugin/test_out_foo.rb
</pre>
<a name="further-reading"></a><h2>Further Reading</h2>
<ul>
<li><a href="http://www.slideshare.net/repeatedly/dive-into-fluentd-plugin-v012">Slides: Dive into Fluentd Plugin</a></li>
</ul>
<div style="text-align:right">
  Last updated: 2017-03-02 23:21:14 UTC
  </div>
<hr size="1" style="margin-top: 10px; margin-bottom: 10px; color: rgba(0, 0, 0, .15);"/>
<div style="text-align:right">
Versions 
  
    
    | <a href="/v1.0/articles/plugin-development">v1.0 (td-agent3)</a>
    
  

  

  
    
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