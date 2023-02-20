#!/bin/bash

set -e

host="$1"
shift
cmd="$@"

until mysql -h "$host" -u boss -ppassword -e 'SELECT 1' > /dev/null 2>&1; do
  >&2 echo "MySQL is unavailable - sleeping"
  sleep 1
done

>&2 echo "MySQL is up - executing command"
exec $cmd
