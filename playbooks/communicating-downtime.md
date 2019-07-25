# Communicating Downtime
How to inform users that KScout service quality is degraded.

0. Clone down [status page repository](https://github.com/kscout/status-page):
   ```
   git clone git@github.com:kscout/status-page.git
   ```
1. Open terminal in status page repository directory
2. Create new incident:
   ```
   make new
   ```
3. Preview status page with incident:
   ```
   make dev
   ```
4. Generate static status page with new incident:
   ```
   make build
   ```
5. Commit and push incident:
   ```
   git add . --all
   git commit -m "added incident ..."
   git push origin master
   ```
