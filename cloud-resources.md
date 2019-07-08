# Cloud Resources
Description of cloud resources.

# Table Of Contents
- [kscout.io Domain](#kscoutio-domain)
  - [Managing DNS Records](#managing-dns-records)
    - [Edit Existing DNS Records](#edit-existing-dns-records)
	- [Create New DNS Records](#create-new-dns-records)
- [Permanent OpenShift 3.1 Cluster](#permanent-openshift-31-cluster)
  - [Permanent Cluster DNS Records](#permanent-cluster-dns-records)
- [Temporary OpenShift 4.1 Development Clusters](#temporary-openshift-41-development-clusters)
  - [Create A Development Cluster](#create-a-development-cluster)
  - [Temporary Development Cluster DNS Records](#temporary-development-cluster-dns-records)

# kscout.io Domain
The DNS zone for kscout.io is managed via Cloudflare.  

## Managing DNS Records
This guide assumes you know DNS basics.  

If you need to manage DNS records which point to the permanent OpenShift 3.1
cluster see the [Permanent Cluster DNS Records documentation](#permanent-cluster-dns-records).

If you need to manage DNS records which point to the temporary OpenShift 4.1 
development cluster see the [Temporary Development Cluster DNS Records documentation](#temporary-development-cluster-dns-records).

First go to the DNS dashboard page:

1. Log onto [dash.cloudflare.com](https://dash.cloudflare.com)
2. Select the kscout.io domain
3. Navigate to the "DNS" tab in the top menu

### Edit Existing DNS Records

1. Find the record's row
2. Click on the value
3. Edit
4. Hit enter

### Create New DNS Records

1. Direct your attention to the data entry boxes above the table of entries.
   They are arranged like so:
   ```
   | Type | Name | Value | TTL | Cloudflare Enabled? | Add Record Button |
   ```
2. Enter you record's type, name, and value
3. Keep TTL set to "Automatic TTL"
4. Ensure Cloudflare is enabled for the record, an orange cloud should display
   if Cloudflare is enabled. If disabled a gray cloud will be displayed. Click
   on this gray cloud to enable Cloudflare.
5. Hit the "Add Record" button

# Permanent OpenShift 3.1 Cluster
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

## Create A Development Cluster
Development clusters are managed by the [Auto Cluster tool](https://github.com/kscout/auto-cluster).  

The tool is currently running on the  [Permanent OpenShift 3.1 Cluster](#permanent-openshift-31-cluster).  
This ensures that a development cluster is always running.  

You should never have to create a development cluster manually.

## Temporary Development Cluster DNS Records
**Please be aware that services hosted on this cluster may go down unexpectedly,
host all core user facing services on the [Permanent OpenShift 3.1 Cluster](#permanent-openshift-31-cluster).**

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
