# [WIP] Downtime Alert Procedure
What to do if a downtime alert is triggered.

1. [Reproduce alert](#reproduce-alert)
2. [Find root cause](#find-root-cause)
3. WIP

# Reproduce alert
Verify that the alert is correct.  
Go to the web page which the alert mentions.  

Experience first hand what a user is experiencing.  
This can provide insight into what type of issue is causing the alert:

- If you reach a browser error page (ex., "We're having trouble finding that 
  site") the issue is most likely not Kubernetes related, potentially 
  DNS related
- If you reach a Cloudflare error page (ex., "Origin DNS error") the problem
  is most likely DNS related. This signifies that user traffic is not able to 
  reach the cluster
- If you reach an OpenShift error page (ex., "Application is not available" or
  mentions "Routes" and "pods") the issue is most likely on the Kubernetes side.
  This signifies that user traffic is reaching the cluster but is not able to be
  routed the last mile to the correct pod

If you cannot reproduce the alert follow the rest of the steps in this playbook 
just in case.

# Find root cause
There are 8 failure points which can cause downtime. In the order that the user 
interacts with them: DNS -> OpenShift Route -> Kubernetes Service -> Kubernetes 
Pod -> Proxy Container -> Proxy Process -> App Container -> App Process

## DNS
DNS configuration errors prevent user traffic from reaching the 
Kubernetes cluster.  

- Ensure that the DNS entry for the downed service is correct. Reference the
  [Managing DNS Records
  documentation](about/cloud-resources.md#managing-dns-records).
- Use `dig +short SUBDOMAIN.kscout.io` to check DNS records
- Mock requests to DNS record values:
  ```
  curl -H 'Host: SUBDOMAIN.kscout.io' DNS_RECORD_VALUE
  ```
  Where `DNS_RECORD_VALUE` is the value of a DNS record.
  This can be useful to check that traffic is being routed to the 
  correct location.

## OpenShift Route
OpenShift Route resources direct incoming traffic to a service. Traffic is 
directed based on the `Host` header.    

A broken route will prevent external network traffic from being directed to the 
correct internal service.

- Ensure a route exists for the effected subdomain:
  ```
  oc get routes | grep SUBDOMAIN.kscout.io
  ```
- Ensure route is pointing towards correct service:
  ```
  oc describe routes ROUTE_NAME
  ```
  Check the `Service` and `Endpoint Port` fields of the output and ensure they
  have correct values.
  
## Kubernetes Service
Kubernetes services direct internal traffic to one of many pods. Similar to a 
load balancer.  

A broken service will prevent user traffic from reaching pods.

- Ensure the service specified by route exists:
  ```
  oc describe svc SERVICE_NAME
  ```
- Ensure the service is correct, use output from command above:
  Check that pods exists with the selector specified by the `Selector` field.  
  Check the service is targetting the correct port specified by the 
  `TargetPort` field.
  
## Kubernetes Pod
Kubernetes pods are a grouping around the containers / processes which run 
the application.  

A broken pod leaves user traffic with no destination.

- Check pod status:
  ```
  oc get pods -l SELECTOR_FIELD_FROM_SERVICE
  ```
  Any pods who's statuses' are not `Running` or with non-100% ready counts 
  should be considered suspects for further investigation.
- Determine which container in the pod is causing issues:
  ```
  oc describe pod SUSPECT_POD_NAME
  ```
  Check for any containers who's `Ready` field is not `True`
- Check for failing health and / or readiness checks, use the output from the 
  last command above:
  Check the `Events` field to see if there are any messages about 
  failing checks.
  
## Proxy Container
The proxy container is a Caddy server which acts as a reverse proxy for the 
app container.  

A broken proxy container will prevent user traffic from reaching the 
app process.


## Proxy Process
## App Container
## App Process
