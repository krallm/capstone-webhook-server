capstone-webhook-server
=======================

A tiny server that listens for GitHub push events (on a certain branch)
and restarts the rails server when updated.

After running this server, the rails server should be manually started
as this server does not try to restart the rails server until a push
event is received.

```sh
# Optional: Manage gems with rvm
rvm use 2.1.5
rvm gemset create cws
rvm use 2.1.5@cws

# Install gems
bundle

# Copy the example files
cp config.sh.example config.sh
cp secret.sh.example secret.sh

# Modify the config.sh and secret.sh files as needed

# After modifying the files, start
./start
```
