# Cloud Resources
Description of cloud resources.

# Table Of Contents
- [kscout.io Domain](#kscoutio-domain)
- [Status Page](#status-page)
- [Permanent OpenShift 3 Cluster](#permanent-openshift-3-cluster)
  - [Permanent Cluster DNS Records](#permanent-cluster-dns-records)
- [Temporary OpenShift 4.1 Development Clusters](#temporary-openshift-41-development-clusters)
  - [Temporary Development Cluster DNS Records](#temporary-development-cluster-dns-records)
- [Slack Apps](#slack-apps)
  - [Ops Bot](#ops-bot)

# kscout.io Domain
The DNS zone for kscout.io is managed via Cloudflare.  

# Status Page
A status page is hosted at status.kscout.io.  

This is a static site hosted by GitHub pages.

# Permanent OpenShift 3 Cluster
The Red Hat development cluster is used to host user facing services
on kscout.io.  

## Permanent Cluster DNS Records
The permanent cluster can receive external traffic and direct it 
to applications.  

To do this these applications must have a `Route` resource.  
DNS entries will direct traffic to this `Route` resource.

DNS entries should have the value:

```
devtools-dev.ext.devshift.net
```

# Temporary OpenShift 4.1 Development Clusters
Temporary 48 hour OpenShift 4.1 clusters are used for prototyping and usage of 
OpenShift 4.1 exclusive features.

## Temporary Development Cluster DNS Records
**Please be aware that services hosted on this cluster may go down unexpectedly,
host all core user facing services on the [Permanent OpenShift 3 Cluster](#permanent-openshift-3-cluster).**

The temporary cluster can receive external traffic and direct it 
to applications.  

To do this these applications must have a `Route` resource.  
DNS entries will direct traffic to this `Route` resource.

DNS entries which point to this cluster must be of type `CNAME`. Their values 
must follow the format:

```
<route host>.<route namespace>.apps.<cluster name>.devcluster.openshift.com
```

- `<route host>` is the `spec.host` field of your `Route` resource
- `<route namespace>` is the `metadata.namespace` field of your 
  `Route` resource
- `<cluster name>` is the name of the temporary development cluster, find this
  the Slack channel

# Slack Apps
## Ops Bot
The "KScout Ops Bot" app is used by devops related infrastructure to post 
messages to the #kscout-develop Slack channel. 

## KScout bot

The "scoutbot" app acts as a client for the chatbot api of Kacout Platform. Users can learn about serverless, search 
and deploy apps using this bot. The bot answers only when mentioned(@scoutbot) on any channel of CoreOS workspace.

