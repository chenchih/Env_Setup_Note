#!/bin/bash

# Define active profiles
export COMPOSE_PROFILES="nats,controller,cwmp,mqtt,stomp,ws,adapter,frontend"

# Script menu
show_menu() {
    echo "=========================================="
    echo "       Oktopus Docker Stack Manager       "
    echo "=========================================="
    echo "1) Check Stack Status (docker ps)"
    echo "2) Start / Rerun Stack (docker compose up)"
    echo "3) Stop Stack (docker compose down)"
    echo "4) View Container Logs"
    echo "5) Exit"
    echo "=========================================="
    read -p "Select an option [1-5]: " choice
    echo ""
}

while true; do
    show_menu
    case $choice in
        1)
            echo "--- Current Running Containers ---"
            sudo docker ps
            echo ""
            ;;
        2)
            echo "--- Starting / Rerunning Oktopus Stack ---"
            sudo -E COMPOSE_PROFILES="$COMPOSE_PROFILES" docker compose up -d
            echo ""
            echo "[OK] Command executed. Check status below:"
            sudo docker ps
            echo ""
            ;;
        3)
            echo "--- Stopping Oktopus Stack ---"
            sudo docker compose down
            echo ""
            echo "[OK] Stack stopped successfully."
            echo ""
            ;;
        4)
            read -p "Enter container name (or press Enter for all): " container_name
            if [ -z "$container_name" ]; then
                sudo docker compose logs --tail=100 -f
            else
                sudo docker logs --tail=100 -f "$container_name"
            fi
            echo ""
            ;;
        5)
            echo "Exiting..."
            exit 0
            ;;
        *)
            echo "Invalid option. Please try again."
            echo ""
            ;;
    esac
done