# Deployments
Deployment details.

# Table Of Contents
- [Patterns](#patterns)
  - [Deployment Environments](#deployment-environments)
  - [Kubernetes Resource Labels](#kubernetes-resource-labels)
  - [Common Helm Charts](#common-helm-charts)
  - [Docker Tags](#docker-tags)

# Patterns
All applications deployed for KScout follow certain patterns.

## Deployment Environments
Deployment environments group applications based on their stability.  

KScout applications can be deployed to either `prod` (production) or `staging`.

Users are served traffic from production applications (ex., kscout.io).

## Kubernetes Resource Labels
All Kubernetes resources have the following 3 labels:

- `app` (String): Name of larger project / service, ex: serverless-registry-api,
  chat-bot-api, site
- `env` (String): Deployment environment, ex: prod or staging
- `component` (String): Name of specific component within service, ex: proxy,
  app, mongo
  
This pattern allows applications to be defined by the `app` and `env` labels.

## Common Helm Charts
Services which are deployed always consist of a single pod which serves HTTP 
requests. Occasionally a service may require a MongoDB instance.  

The [HTTP Service Chart](https://github.com/kscout/http-service-chart) and
[Mongo Chart](https://github.com/kscout/mongo-chart) implement both these 
deployment types.  

By using shared charts improvements made to one deployment are shared across 
all applications.

## Docker Tags
Docker images are tagged based on their 
[deployment environment](#deployment-environments).  

Tags follow the format:

```
ENV-latest
```

Where `ENV` is the deployment environment, ex., `prod-latest` 
or `staging-latest`.
