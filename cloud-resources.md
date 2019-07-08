# Cloud Resources
Description of cloud resources.

# Table Of Contents
- [kscout.io Domain](#kscoutio-domain)
  - [Managing DNS Records](#managing-dns-records)
    - [Edit Existing DNS Records](#edit-existing-dns-records)
	- [Create New DNS Records](#create-new-dns-records)
- [Permanent OpenShift 3.1 Cluster](#permanent-openshift-31-cluster)
- [Temporary OpenShift 4.1 Development Clusters](#temporary-openshift-41-development-clusters)

# kscout.io Domain
The DNS zone for kscout.io is managed via Cloudflare.  

## Managing DNS Records
This guide assumes you know DNS basics.  

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

# Temporary OpenShift 4.1 Development Clusters
Temporary 48 hour OpenShift 4.1 clusters are used for prototyping and usage of 
OpenShift 4.1 exclusive features.
