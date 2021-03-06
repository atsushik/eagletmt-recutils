#!/bin/bash
REDIS_HOST=localhost
DB=1
QUEUE=jobs
TIMEOUT=0 # never
PT_DIR=/home/pt

while [ ! -r /tmp/stop-encode.txt ]
do
  FNAME="$(redis-cli -h $REDIS_HOST -n $DB --raw BLPOP $QUEUE $TIMEOUT | tail -1)"
  if [ x"$FNAME" = x"" ]; then
    # redis disconnected?
    sleep 10
  else
    echo "$FNAME"
    ./enc.rb "$PT_DIR/$FNAME".ts
  fi
done
