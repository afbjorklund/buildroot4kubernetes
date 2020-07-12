#!/bin/sh
# replaces k3s binary
case $1 in
  server|agent)
    CMD=k3s-$1
    ;;
  kubectl|crictl|ctr)
    CMD=$1
    ;;
  *)
    exit 1
    ;;
esac
shift
exec $CMD "$@"
