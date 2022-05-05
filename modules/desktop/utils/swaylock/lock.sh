#!/bin/sh
ARGS="--image @bg@"
if [ -z "$1" ]; then
    ARGS="--screenshots --effect-blur 10x10 --effect-vignette 0.8:0.9"
fi

@swaylock@ $ARGS \
    --effect-compose="100,100;40x40;center;@lock@" \