# Installation

Fluentd can be installed in several ways. This article gives an overview of them and explains which one to choose.

Before installing Fluentd, please follow the [Pre-installation Guide](before-install.md) to configure your OS properly.

## Installation Methods

| Method | Platforms | Maintained by |
| :--- | :--- | :--- |
| [`fluent-package`](#fluent-package) | Red Hat Linux, Amazon Linux, Debian, Ubuntu and Windows | [Fluentd Project](https://www.fluentd.org/) |
| [`calyptia-fluentd`](#calyptia-fluentd) | Red Hat Linux, Amazon Linux, Debian, Ubuntu, macOS and Windows | [Chronosphere](https://chronosphere.io) |
| [Docker image](#docker-image) | Any platform which runs Docker | [Fluentd Project](https://www.fluentd.org/) |
| [Ruby gem](#ruby-gem) | Any platform which runs Ruby | [Fluentd Project](https://www.fluentd.org/) |
| [Source](#source) | Any platform which runs Ruby | [Fluentd Project](https://www.fluentd.org/) |

### `fluent-package`

`fluent-package` \(formerly known as `td-agent`\) is the stable distribution of Fluentd. It contains Ruby, Fluentd, a set of commonly used plugins and the scripts to run Fluentd as a service, so you do not need to set up Ruby by yourself. It is shipped in two flavors, the normal release version and the LTS \(Long Term Support\) version. See [Scheduled support lifecycle announcement about Fluent Package v6](https://www.fluentd.org/blog/fluent-package-v6-scheduled-lifecycle) about the difference between them.

* [RPM Package \(Red Hat Linux\)](install-fluent-package/install-by-rpm-fluent-package.md)
* [DEB Package \(Debian/Ubuntu\)](install-fluent-package/install-by-deb-fluent-package.md)
* [.msi Installer \(Windows\)](install-fluent-package/install-by-msi-fluent-package.md)

`fluent-package` for macOS is not shipped yet. See [.dmg Package \(macOS\)](install-fluent-package/install-by-dmg-fluent-package.md) for the status.

### `calyptia-fluentd`

`calyptia-fluentd` is an alternative stable distribution of Fluentd, which is maintained by [Chronosphere](https://chronosphere.io) after its acquisition of Calyptia. Like `fluent-package`, it contains Ruby and a set of commonly used plugins. Check the guide for your platform for the supported OS versions.

* [RPM Package \(Red Hat Linux\)](install-calyptia-fluentd/install-by-rpm-calyptia-fluentd.md)
* [DEB Package \(Debian/Ubuntu\)](install-calyptia-fluentd/install-by-deb-calyptia-fluentd.md)
* [.dmg Package \(macOS\)](install-calyptia-fluentd/install-by-dmg-calyptia-fluentd.md)
* [.msi Installer \(Windows\)](install-calyptia-fluentd/install-by-msi-calyptia-fluentd.md)

### Docker Image

The official [Fluentd Docker image](https://hub.docker.com/r/fluent/fluentd/) runs Fluentd in a container. On Kubernetes, the [Fluentd DaemonSet](https://github.com/fluent/fluentd-kubernetes-daemonset) runs Fluentd on each node to collect the logs of the node and its pods.

* [Docker Image](../container-deployment/install-by-docker.md)
* [Kubernetes](../container-deployment/kubernetes.md)

### Ruby Gem

Fluentd is also published as the [`fluentd`](https://rubygems.org/gems/fluentd) gem. You have to prepare Ruby, and install the plugins you need by yourself.

* [Install by Ruby Gem](install-by-gem.md)

### Source

You can build and install Fluentd from [its git repository](https://github.com/fluent/fluentd). This is useful for developers.

* [Install from Source](install-from-source.md)

## Which Method Should I Choose?

* To run Fluentd on a Linux or Windows server, use `fluent-package`. Choose the LTS version if you prefer stability to new features.
* To run Fluentd in containers or on Kubernetes, use the Docker image or the Fluentd DaemonSet.
* To run Fluentd on macOS, use the Docker image or the Ruby gem, because `fluent-package` for macOS is not shipped yet. `calyptia-fluentd` also provides a .dmg package.
* To run Fluentd on a Ruby installation which you manage by yourself, use the Ruby gem.
* To develop Fluentd itself or to try a change which is not released yet, install from source.

{% hint style='info' %}
If you need a lightweight log forwarder for edge devices or containers, consider [Fluent Bit](https://fluentbit.io/) as well. It uses less CPU and memory than Fluentd, but has fewer features. See [High Availability Config](../deployment/high-availability.md) for a typical setup of forwarders and aggregators.
{% endhint %}

{% hint style='danger' %}
`td-agent` and `fluent-package` v5 have reached End of Life \(EOL\). Do not install them for a new deployment. Their installation guides are kept under "Obsolete Installation" for existing users.
{% endhint %}

## After Installation

See [Post Installation Guide](post-installation-guide.md) for the next steps, such as where the configuration file is and how to install plugins.
