# Common Helm Chart Releases
Release instructions for [http-service-chart](https://github.com/kscout/http-service-chart)
and [mongo-chart](https://github.com/kscout/http-service-chart).

# Table Of Contents
- [Overview](#overview)

# Overview
These Helm charts are used as submodules by many Git repositories.

When a new release occurs all these dependent Git repositories must update their
Git submodules.

The `update.sh` script:

- Clones all dependent Git repositories down
- Updates their common Helm chart submodules
- Submits a pull request with these changes
- Messages maintainers on Slack with PR links

The `SLACK_WEBHOOK` environment variable must be set to the Slack channel 
which PR links will be sent.

> It is recommended this is a channel only maintainers are present, to reduce CI
> bot like spam in general community channels. 

Then run:

```
% update.sh COMMON_HELM_CHART_NAME
```

Where `COMMON_HELM_CHART_NAME` is `http-service` or `mongo`.
