# td-agent v2 vs. td-agent v3

## Supported Platforms

[Treasure Data, Inc.](https://www.treasuredata.com) maintains stable packages
for Fluentd and canonical plugins as Treasure Agent (the package is called
`td-agent`). td-agent has v2 and v3. td-agent v2 is for the production and v3 is
the new stable version for working with Ruby 2.4 and fluentd v1 series.


|  Platform         | v2 | v3 |
| ----------------- | -- | -- |
| RedHat/CentOS 5   | OK |    |
| RedHat/CentOS 6/7 | OK | OK |
| Ubuntu Precise    | OK |    |
| Ubuntu Trusty     | OK | OK |
| Ubuntu Xenial     | OK | OK |
| Ubuntu Bionic     | OK | OK |
| Debian Wheezy     | OK |    |
| Debian Jessie     | OK | OK |
| Debian Stretch    | OK | OK |
| MacOSX            | OK | OK |
| Windows           |    | OK |

## Features

Following are the major feature updates to `td-agent` v3:

- Ruby 2.4
- Fluentd v1
- Updated for the core libraries, msgpack, Cool.io, etc.
- Windows support
- Drop older distributions and non-popular plugins
- Remove fluentd-ui. This will be released as separated td-agent-ui package

## td-agent v3 is now a stable version

Fluentd v1 is the new stable version.

## How to Install?

* [Ubuntu/Debian](/install/install-by-deb.md)
* [RedHat/CentOS](/install/install-by-rpm.md)
* [Windows](/install/install-by-msi.md)
* [macOS](/install/install-by-dmg.md)
* [RubyGems](/install/install-by-gem.md)

------------------------------------------------------------------------

If this article is incorrect or outdated, or omits critical information, please [let us know](https://github.com/fluent/fluentd-docs-gitbook/issues?state=open).
[Fluentd](http://www.fluentd.org/) is an open-source project under [Cloud Native Computing Foundation (CNCF)](https://cncf.io/). All components are available under the Apache 2 License.
