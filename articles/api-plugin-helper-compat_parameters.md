# Compat Parameters Plugin Helper API

`compat_parameters` helper convert parameters from v0.12 style to v1.0
style.

Here is the code example with `compat_parameters` helper:

``` {.CodeRay}
require 'fluent/plugin/output'

module Fluent::Plugin
  class ExampleOutput < Output
    Fluent::Plugin.register_output('example', self)

    # 1. load compat_parameters helper
    helpers :compat_parameters

    # omit start, shutdown and other plugin API

    def configure(conf)
      compat_parameters_convert(conf, :buffer, :inject, default_chunk_key: "time")
      super
      ...
    end
  end
end
```


## Methods

[]{#compat_parameters_convert(conf,-*types,-**kwargs)}

### compat\_parameters\_convert(conf, \*types, \*\*kwargs)

-   `conf`: `Fluent::Configuration` instance
-   `types`: Following 5 types are supported
    -   `:buffer`
    -   `:inject`
    -   `:extract`
    -   `:parser`
    -   `:formatter`
-   `kwargs`:
    -   `default_chunk_key`: Set default chunk key. For more details,
        see [Buffer section configurations](/articles/buffer-section.md)

The important point is you can't mix v1.0 and v0.12 styles in one plugin
directive. If you mix v1.0 and v0.12 styles, v1.0 style is used and
v0.12 style is ignored. Here is an example:

``` {.CodeRay}
<match pattern>
  @type foo
  # This flush_interval is ignored because <buffer> exist. Conversion doesn't happen.
  flush_interval 30s
  # This <buffer> parameters are used
  <buffer>
    @type file
    path /path/to/buffer
    retry_max_times 10
    queue_limit_length 256
  </buffer>
</match>
```

#### buffer

  old (v0.12)                      new (v1)                         note
  -------------------------------- -------------------------------- -------------------------------
  buffer\_type                     \@type                           
  buffer\_path                     path                             
  num\_threads                     flush\_thread\_count             
  flush\_interval                  flush\_interval                  
  try\_flush\_interval             flush\_thread\_interval          
  queued\_chunk\_flush\_interval   flush\_thread\_burst\_interval   
  disable\_retry\_limit            retry\_forever                   
  retry\_limit                     retry\_max\_times                
  max\_retry\_wait                 retry\_max\_interval             
  buffer\_chunk\_limit             chunk\_limit\_size               
  buffer\_queue\_limit             queue\_limit\_length             
  buffer\_queue\_full\_action      overflow\_action                 
  flush\_at\_shutdown              flush\_at\_shutdown              
  time\_slice\_format              timekey                          also set chunk\_key to 'time'
  time\_slice\_wait                timekey\_wait                    
  timezone                         timekey\_zone                    
  localtime                        timekey\_use\_utc                exclusive with utc
  utc                              timekey\_use\_utc                exclusive with localtime

This converts following flat configuration:

``` {.CodeRay}
buffer_type file
buffer_path /path/to/buffer
retry_limit 10
flush_interval 30s
buffer_queue_limit 256
```

into:

``` {.CodeRay}
<buffer>
  @type file
  path /path/to/buffer
  retry_max_times 10
  flush_interval 30s
  queue_limit_length 256
</buffer>
```

For more details, see [Buffer section configuration](/articles/buffer-section.md)

#### inject

  old (v0.12)          new (v1)       note
  -------------------- -------------- --------------------------
  include\_time\_key   time\_key      if true, set time\_key
  time\_key            time\_key      
  time\_format         time\_format   
  timezone             timezone       
  include\_tag\_key    tag\_key       if true, set tag\_key
  tag\_key             tag\_key       
  localtime            localtime      exclusive with utc
  utc                  localtime      exclusive with localtime

This converts following flat configuration:

``` {.CodeRay}
include_time_key
time_key event_time
utc
```

into:

``` {.CodeRay}
<inject>
  time_key event_time
  localtime false
</inject>
```

For more details, see [Inject Plugin Helper
API](/articles/api-plugin-helper-inject.md)

#### extract

  old (v0.12)    new (v1)       note
  -------------- -------------- --------------------------
  time\_key      time\_key      
  time\_format   time\_format   
  timezone       timezone       
  tag\_key       tag\_key       
  localtime      localtime      exclusive with utc
  utc            localtime      exclusive with localtime

This converts following flat configuration:

``` {.CodeRay}
include_time_key
time_key event_time
utc
```

into:

``` {.CodeRay}
<extract>
  time_key event_time
  localtime false
</extract>
```

For more details, see [Extract Plugin Helper
API](/articles/api-plugin-helper-extract.md)

#### parser

  old (v0.12)               new (v1)                note                       plugin
  ------------------------- ----------------------- -------------------------- -----------------------------------------
  format                    \@type                                             
  types                     types                   converted to JSON format   
  types\_delimiter          types                                              
  types\_label\_delimiter   types                                              
  keys                      keys                                               CSVParser, TSVParser (old ValuesParser)
  time\_key                 time\_key                                          
  time\_format              time\_format                                       
  localtime                 localtime               exclusive with utc         
  utc                       localtime               exclusive with localtime   
  delimiter                 delimiter                                          
  keep\_time\_key           keep\_time\_key                                    
  null\_empty\_string       null\_empty\_string                                
  null\_value\_pattern      null\_value\_pattern                               
  json\_parser              json\_parser                                       JSONParser
  label\_delimiter          label\_delimiter                                   LabeledTSVParser
  format\_firstline         format\_firstline                                  MultilineParser
  message\_key              message\_key                                       NoneParser
  with\_priority            with\_priority                                     SyslogParser
  message\_format           message\_format                                    SyslogParser
  rfc5424\_time\_format     rfc5424\_time\_format                              SyslogParser

This converts following configuration:

``` {.CodeRay}
format /^(?<log_time>[^ ]*) (?<message>)+*/
time_key log_time
time_format %Y%m%d%H%M%S
keep_time_key
```

into:

``` {.CodeRay}
<parse>
  @type regexp
  pattern /^(?<log_time>[^ ]*) (?<message>)+*/
  time_key log_time
  time_format %Y%m%d%H%M%S
  keep_time_key
</parse>
```

For more details, see [Parser Plugin Overview](/articles/parser-plugin-overview.md)
and [Writing Parser Plugins](/articles/api-plugin-parser.md).

#### formatter

  old (v0.12)        new (v1)           note                       plugin
  ------------------ ------------------ -------------------------- ----------------------
  format             \@type                                        
  delimiter          delimiter                                     
  force\_quotes      force\_quotes                                 CsvFormatter
  keys               keys                                          TSVFormatter
  fields             fields                                        CsvFormatter
  json\_parser       json\_parser                                  JSONFormatter
  label\_delimiter   label\_delimiter                              LabeledTSVFormatter
  output\_time       output\_time                                  OutFileFormatter
  output\_tag        output\_tag                                   OutFileFormatter
  localtime          localtime          exclusive with utc         OutFileFormatter
  utc                utc                exclusive with localtime   OutFileFormatter
  timezone           timezone                                      OutFileFormatter
  message\_key       message\_key                                  SingleValueFormatter
  add\_newline       add\_newline                                  SingleValueFormatter
  output\_type       output\_type                                  StdoutFormatter

This converts following configuration:

``` {.CodeRay}
format json
```

into:

``` {.CodeRay}
<format>
  @type json
</format>
```

For more details, see [Formatter Plugin
Overview](/articles/formatter-plugin-overview.md) and [Writing Formatter
Plugins](/articles/api-plugin-formatter.md).

[]{#compat_parameters-used-plugins}

compat\_parameters used plugins
-------------------------------

-   [Parser filter](/articles/filter_parser.md)
-   [Exec input](/articles/in_exec.md)
-   [HTTP input](/articles/in_http.md)
-   [Syslog input](/articles/in_syslog.md)
-   [Tail input](/articles/in_tail.md)
-   [TCP input](/articles/in_tcp.md)
-   [UDP input](/articles/in_udp.md)
-   [Exec output](/articles/out_exec.md)
-   [Exec filter output](/articles/out_exec_filter.md)
-   [File output](/articles/out_file.md)
-   [Forward output](/articles/out_forward.md)
-   [Stdout output](/articles/out_stdout.md)
-   [Stream output](/articles/out_stream.md)


------------------------------------------------------------------------

If this article is incorrect or outdated, or omits critical information,
please [let us know](https://github.com/fluent/fluentd-docs/issues?state=open).
[Fluentd](http://www.fluentd.org/) is a open source project under [Cloud
Native Computing Foundation (CNCF)](https://cncf.io/). All components
are available under the Apache 2 License.
