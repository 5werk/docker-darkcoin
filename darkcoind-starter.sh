#!/bin/bash

cmd=$1
shift

case $cmd in
  shell)
    sh -c "$*"
    exit $?
    ;;
  login)
    bash -l
    exit $?
    ;;
  darkcoind)
    darkcoind "$@"
    exit $?
    ;;
  log)
    tail -f /darkcoin/debug.log
    ;;
  getconfig)
    cat /darkcoin/darkcoin.conf
    ;;
  *)
    echo "Unknown cmd $cmd"
    exit 1
esac
