# Kubernetes

![Fluentd + Kubernetes](../.gitbook/assets/fluentd_kubernetes.png)

[Kubernetes](http://kubernetes.io) provides two logging endpoints for applications and cluster logs:

1. Stackdriver Logging for use with Google Cloud Platform; and,
2. Elasticsearch.

Behind the scenes, there is a logging agent that takes care of the log collection, parsing and distribution: [Fluentd](http://www.fluentd.org).

This document focuses on how to deploy Fluentd in Kubernetes and extend the possibilities to have different destinations for your logs.

## Getting Started

This document assumes that you have a Kubernetes cluster running or at least a local \(single\) node that can be used for testing purposes.

Before getting started, make sure you understand or have a basic idea about the following concepts from Kubernetes:

* [Node](https://kubernetes.io/docs/concepts/architecture/nodes/)

  > A node is a worker machine in Kubernetes, previously known as a minion. A node may be a VM or physical machine, depending on the cluster. Each node has the services necessary to run pods and is managed by the master components...

* [Pod](https://kubernetes.io/docs/concepts/workloads/pods/)

  > A pod \(as in a pod of whales or pea pod\) is a group of one or more containers \(such as Docker containers\), the shared storage for those containers, and options about how to run the containers. Pods are always co-located and co-scheduled, and run in a shared context...

* [DaemonSet](https://kubernetes.io/docs/concepts/workloads/controllers/daemonset/)

  > A DaemonSet ensures that all \(or some\) nodes run a copy of a pod. As nodes are added to the cluster, pods are added to them. As nodes are removed from the cluster, those pods are garbage collected. Deleting a DaemonSet will clean up the pods it created...

Since applications runs in Pods and multiple Pods might exists across multiple nodes, we need a specific Fluentd-Pod that takes care of log collection on each node: Fluentd DaemonSet.

## Fluentd DaemonSet

For [Kubernetes](https://kubernetes.io), a [DaemonSet](https://kubernetes.io/docs/concepts/workloads/controllers/daemonset/) ensures that all \(or some\) nodes run a copy of a _pod_. To solve log collection, we are going to implement a Fluentd DaemonSet.

Fluentd is flexible enough and has the proper plugins to distribute logs to different third-party applications like databases or cloud services, so the principal question is _Where will the logs be stored?_. Once we got that question answered, we can move forward configuring our DaemonSet.

The following steps will focus on sending the logs to an Elasticsearch Pod:

### Get Fluentd DaemonSet sources

We have created a Fluentd DaemonSet that have the proper rules and container image ready to get started:

* [https://github.com/fluent/fluentd-kubernetes-daemonset](https://github.com/fluent/fluentd-kubernetes-daemonset)

Please grab a copy of the repository from the command line using GIT:

```text
$ git clone https://github.com/fluent/fluentd-kubernetes-daemonset
```

### DaemonSet Content

The cloned repository contains several configurations that allow to deploy Fluentd as a DaemonSet. The Docker container image distributed on the repository also comes pre-configured so that Fluentd can gather all the logs from the Kubernetes node's environment and append the proper metadata to the logs.

This repository has several presets for Alpine/Debian with popular outputs:

* [DaemonSet preset settings](https://github.com/fluent/fluentd-kubernetes-daemonset/tree/master/docker-image/v1.14)

## Logging to Elasticsearch

### Requirements

From the `fluentd-kubernetes-daemonset/` directory, find the YAML configuration file:

* [`fluentd-daemonset-elasticsearch.yaml`](https://github.com/fluent/fluentd-kubernetes-daemonset/blob/master/fluentd-daemonset-elasticsearch.yaml)

As an example, let's see a part of this file:

```text
apiVersion: apps/v1
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
          - name:  FLUENT_ELASTICSEARCH_SSL_VERIFY
            value: "true"
          - name:  FLUENT_ELASTICSEARCH_SSL_VERSION
            value: "TLSv1_2"
        ...
```

This YAML file contains two relevant environment variables that are used by Fluentd when the container starts:

| Environment Variable | Description | Default |
| :--- | :--- | :---: |
| `FLUENT_ELASTICSEARCH_HOST` | Specify the host name or IP address. | `elasticsearch-logging` |
| `FLUENT_ELASTICSEARCH_PORT` | Elasticsearch TCP port | 9200 |
| `FLUENT_ELASTICSEARCH_SSL_VERIFY` | Whether verify SSL certificates or not. | `true` |
| `FLUENT_ELASTICSEARCH_SSL_VERSION` | Specify the version of TLS. | `TLSv1_2` |

Any relevant change needs to be done in the YAML file before deployment. The defaults assume that at least one Elasticsearch Pod **elasticsearch-logging** exists in the cluster.

If this article is incorrect or outdated, or omits critical information, please [let us know](https://github.com/fluent/fluentd-docs-gitbook/issues?state=open). [Fluentd](http://www.fluentd.org/) is an open-source project under [Cloud Native Computing Foundation \(CNCF\)](https://cncf.io/). All components are available under the Apache 2 License.

