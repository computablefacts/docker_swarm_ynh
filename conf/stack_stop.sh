#!/bin/bash

# Name of the stack
STACK_NAME="__APP__"

# Get the list of services in the stack
SERVICES=$(/usr/bin/docker stack services --format '{{.Name}}' "$STACK_NAME")

# Check if the stack has any services
if [ -z "$SERVICES" ]; then
  echo "No services found for stack $STACK_NAME."
  exit 0
fi

# Scale each service down to 0 replicas
for SERVICE in $SERVICES; do
  # Get the IDs of the running containers for each service
  CONTAINERS=$(/usr/bin/docker ps --filter "label=com.docker.swarm.service.name=$SERVICE" --format '{{.ID}}')

  # Stop each container without removing it
  for CONTAINER in $CONTAINERS; do
    echo "Stopping container $CONTAINER for service $SERVICE..."
    /usr/bin/docker stop "$CONTAINER"
  done

  sleep 2
  
  echo "Stopping service $SERVICE..."
  /usr/bin/docker service scale "$SERVICE=0"
done

echo "All services in stack $STACK_NAME have been stopped."
