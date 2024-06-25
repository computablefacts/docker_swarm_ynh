#!/bin/bash

# Name of the stack
STACK_NAME="__APP__"

# Démarrer docker stack up en arrière-plan
/usr/bin/docker stack up --compose-file stack.yaml --detach=false --prune "$STACK_NAME" &

# Définir la limite de temps en secondes (300 secondes = 5 minutes)
TIMEOUT=300
INTERVAL=5
elapsed_time=0

# Boucle de vérification toutes les INTERVAL secondes
while [ $elapsed_time -lt $TIMEOUT ]; do
    # Vérifier si la commande docker stack up est toujours en cours d'exécution
    if ! pgrep -f "docker stack up" >/dev/null; then
        echo "La commande docker stack up s'est terminée normalement."
        exit 0  # Code de sortie 0 pour indiquer un succès à systemd
    fi

    # Attendre INTERVAL secondes
    sleep $INTERVAL
    elapsed_time=$((elapsed_time + INTERVAL))
done

# Si la commande continue de s'exécuter après TIMEOUT secondes, la tuer
if pgrep -f "docker stack up" >/dev/null; then
    echo "La commande docker stack up continue de s'exécuter après $TIMEOUT secondes. Forçage de l'arrêt."
    pkill -f "docker stack up"
    exit 1  # Code de sortie 1 pour indiquer une erreur à systemd
fi
