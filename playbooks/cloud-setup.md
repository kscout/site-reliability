# Cloud Setup
First time setup instructions for cloud resources.

# Table Of Contents
- [Managing DNS Records](#managing-dns-records)
  - [Edit Existing DNS Records](#edit-existing-dns-records)
  - [Create New DNS Records](#create-new-dns-records)
- [Setup Permanent OpenShift 3 Cluster](#setup-permanent-openshift-3-cluster)
- [Create A Temporary Openshift 4.1 Development Cluster](#create-a-temporary-openshift-41-development-cluster)

# Managing DNS Records
If you need to manage DNS records which point to the permanent OpenShift 3
cluster see the [Permanent Cluster DNS Records documentation](../about/cloud-resources.md#permanent-cluster-dns-records).

If you need to manage DNS records which point to the temporary OpenShift 4.1 
development cluster see the [Temporary Development Cluster DNS Records documentation](../about/cloud-resources.md#temporary-development-cluster-dns-records).

First go to the DNS dashboard page:

1. Log onto [dash.cloudflare.com](https://dash.cloudflare.com)
2. Select the kscout.io domain
3. Navigate to the "DNS" tab in the top menu

## Edit Existing DNS Records

1. Find the record's row
2. Click on the value
3. Edit
4. Hit enter

## Create New DNS Records

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

# Setup Permanent Openshift 3 Cluster
The following steps were completed to setup the permanent cluster:

1. Create `kscout` project, use for following steps
2. Add members of KScout GitHub organization to the project
3. Deploy the website: [instructions](https://github.com/kscout/kscout.io#deployment)
4. Deploy the serverless registry API: [instructions](https://github.com/kscout/serverless-registry-api#deployment)
5. Deploy the chat bot API: [instructions](https://github.com/kscout/chat-bot-api#deployment)
6. Deploy the Slack chat bot API: [instructions](https://github.com/kscout/slack-chat-bot-api#deployment)
7. Deploy cluster observability stack: [instructions](https://github.com/kscout/cluster-observability/#deploy)

Finally ensure that kscout.io is pointing to the permanent cluster for the 
following subdomains:

- www
- api
- bot-api
- slack-bot-api

# Create A Temporary OpenShift 4.1 Development Cluster
Development clusters are managed by the [Auto Cluster tool](https://github.com/kscout/auto-cluster).  

The tool is currently running on the  [Permanent OpenShift 3 Cluster](../about/cloud-resources.md#permanent-openshift-3-cluster).  
This ensures that a development cluster is always running.  

You should never have to create a development cluster manually.