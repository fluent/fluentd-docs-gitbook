# td-agent v2 vs. td-agent v3 vs. td-agent 4

## Supported Platforms

[Treasure Data, Inc.](https://www.treasuredata.com) maintains stable packages
for Fluentd and canonical plugins as Treasure Agent (the package is called
`td-agent`). td-agent has v2, v3 and v4.

|  Platform       | v2 | v3 | v4(x86_64) | v4(Arm64) |
| ----------------| -- | -- | -- | -- |
| RedHat/CentOS 5 | &#10004; |    |    |    |
| RedHat/CentOS 6 | &#10004; | &#10004; |    |    |
| RedHat/CentOS 7 | &#10004; | &#10004; | &#10004; | &#10004; |
| RedHat/CentOS 8 |    | &#10004; | &#10004; | &#10004; |
| Amazon Linux 2  |    | &#10004; | &#10004; | &#10004; |
| Ubuntu Precise  | &#10004; |    |    |    |
| Ubuntu Trusty   | &#10004; | &#10004; |    |    |
| Ubuntu Xenial   | &#10004; | &#10004; | &#10004; |    |
| Ubuntu Bionic   | &#10004; | &#10004; | &#10004; | &#10004; |
| Ubuntu Focal    |    |    | &#10004; | &#10004; |
| Debian Jessie   | &#10004; | &#10004; |    |    |
| Debian Stretch  | &#10004; | &#10004; |    |    |
| Debian Buster   |    | &#10004; | &#10004; | &#10004; |
| MacOSX          | &#10004; | &#10004; |    |    |
| Windows         |    | &#10004; | &#10004; |    |

## Features

### td-agent v4

New stable. Major feature updates to td-agent v4 are as follows.

- Ruby 2.7
- Fluentd v1
- Arm64 support

See also [Changes from Treasure Agent 3](https://github.com/fluent-plugins-nursery/td-agent-builder#changes-from-treasure-agent-3)

### td-agent v3

Old stable.

- Ruby 2.4
- Fluentd v1
- Windows support
- Remove fluentd-ui from package

### td-agent v2

This is for v0.12 and old distribution users.
We don't recommend to use this version for new deployment.

## How to Install

* [Ubuntu/Debian](/install/install-by-deb.md)
* [RedHat/CentOS](/install/install-by-rpm.md)
* [Windows](/install/install-by-msi.md)
* [macOS](/install/install-by-dmg.md)
* [rubygems](/install/install-by-gem.md)

------------------------------------------------------------------------

If this article is incorrect or outdated, or omits critical information, please [let us know](https://github.com/fluent/fluentd-docs-gitbook/issues?state=open).
[Fluentd](http://www.fluentd.org/) is a open source project under [Cloud Native Computing Foundation (CNCF)](https://cncf.io/). All components are available under the Apache 2 License.
