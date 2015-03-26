#!/bin/sh

PRE=' [on_push.sh]'

# Get variables from the git-ignored config file
source ./config.sh
[ "$?" != "0" ] && echo "$PRE error sourcing config.sh" 1>&2 && exit 1

# Rails development server doesn't create a PID file that I know of, get
# the process id by checking the port
PID=$(lsof -Pi | grep "TCP \*:$PORT" | tr -s [:space:] " " | cut -d " " -f 2)
[ -z "$PID" ] && echo "$PRE couldn't find rails process id, assuming not running"

# If we have a PID, try to kill it
if [ ! -z "$PID" ]; then
  # Kill the rails server from PID
  echo "$PRE killing rails server process on port $PORT"
  kill -TERM "$PID" > /dev/null 2>&1
  [ "$?" != "0" ] && echo "$PRE couldn't kill the server, wrong pid?" 1>&2 && exit 1
fi

# Pull
cd $HOME/git/Capstone2015
echo "$PRE pulling from $REMOTE:$BRANCH"
git pull "$REMOTE" "$BRANCH"

# Try to migrate the db and restart the server
echo "$PRE migrating the database"
rake db:migrate
echo "$PRE starting server"
rails s -b 0.0.0.0 -d -p $PORT

exit 0
