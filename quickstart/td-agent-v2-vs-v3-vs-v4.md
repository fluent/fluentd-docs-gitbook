# td-agent v2 vs v3 vs v4

## Supported Platforms

[ClearCode, Inc.](https://www.clear-code.com) maintains stable packages for Fluentd and canonical plugins as Treasure Agent \(the package is called `td-agent`\). `td-agent` has v2, v3 and v4. [Calyptia, Inc.](https://calyptia.com/) maintains stable packages as Calyptia-fluentd as another option. Supported OS is the same as td-agent v4 currently.

| Platform | v2 | v3 | v4\(x86\_64\) | v4\(Arm64\) |
| :--- | :---: | :---: | :---: | :---: |
| RedHat/CentOS 5 | ✔ |  |  |  |
| RedHat/CentOS 6 | ✔ | ✔ |  |  |
| RedHat/CentOS 7 | ✔ | ✔ | ✔ | ✔ |
| RedHat/CentOS 8 |  | ✔ | ✔ | ✔ |
| Amazon Linux 2 |  | ✔ | ✔ | ✔ |
| Ubuntu Precise | ✔ |  |  |  |
| Ubuntu Trusty | ✔ | ✔ |  |  |
| Ubuntu Xenial | ✔ | ✔ | ✔ |  |
| Ubuntu Bionic | ✔ | ✔ | ✔ | ✔ |
| Ubuntu Focal |  |  | ✔ | ✔ |
| Debian Jessie | ✔ | ✔ |  |  |
| Debian Stretch | ✔ | ✔ |  |  |
| Debian Buster |  | ✔ | ✔ | ✔ |
| macOS | ✔ | ✔ |  |  |
| Windows |  | ✔ | ✔ |  |

## Features

### `td-agent` v4

New stable. Major feature updates to `td-agent` v4 are as follows:

* Ruby 2.7
* Fluentd v1
* Arm64 Support

See also [Changes from Treasure Agent 3](https://github.com/fluent-plugins-nursery/td-agent-builder#changes-from-treasure-agent-3).

### `td-agent` v3

Old stable.

* Ruby 2.4
* Fluentd v1
* Windows Support
* Remove `fluentd-ui` from the package

### `td-agent` v2

This is for v0.12 and old distribution users. We don't recommend this version for new deployments.

## How to Install

* [Ubuntu/Debian](../installation/install-by-deb.md)
* [RedHat/CentOS](../installation/install-by-rpm.md)
* [Windows](../installation/install-by-msi.md)
* [macOS](../installation/install-by-dmg.md)
* [RubyGems](../installation/install-by-gem.md)

If this article is incorrect or outdated, or omits critical information, please [let us know](https://github.com/fluent/fluentd-docs-gitbook/issues?state=open). [Fluentd](http://www.fluentd.org/) is an open-source project under [Cloud Native Computing Foundation \(CNCF\)](https://cncf.io/). All components are available under under [the Apache License 2.0.](https://www.apache.org/licenses/LICENSE-2.0)

