#!/bin/bash

# Name of the stack
STACK_NAME="__APP__"

# Start the stack
/usr/bin/docker stack up --compose-file stack.yaml --detach=false --prune "$STACK_NAME"
