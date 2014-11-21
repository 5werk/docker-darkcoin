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
    /usr/local/bin/darkcoind "$@"
    exit $?
    ;;
  log)
    tail -f $HOME/.darkcoin/debug.log
    ;;
  getconfig)
    cat $HOME/.darkcoin/darkcoin.conf
    ;;
  *)
    echo "Unknown cmd $cmd"
    exit 1
esac
