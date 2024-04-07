#!/bin/bash

# REDIS
kubectl apply -f redis-master-deployment.yaml
kubectl apply -f redis-slave-deployment.yaml
kubectl apply -f redis-services.yaml

# REDIS-EXPORTER
kubectl apply -f redis-exporter-deployment.yaml
kubectl apply -f redis-exporter-service.yaml

# NODE-JS
kubectl apply -f nodejs-deployment.yaml
kubectl apply -f nodejs-service.yaml

# PROMETHEUS
kubectl apply -f prometheus-deployment.yaml
kubectl apply -f prometheus-configmap.yaml
kubectl apply -f prometheus-service.yaml

# AUTOSCALING
kubectl apply -f Horizontal-Pod-Autoscaler.yaml
kubectl apply -f Vertical-Pod-Autoscaler.yaml

# GRAFANA
kubectl apply -f grafana-deployment.yaml
kubectl apply -f grafana-service.yaml

# REACT
# kubectl apply -f react-deployment.yaml
# kubectl apply -f react-service.yaml





check_service_ready() {
  local SERVICE_NAME=$1
    echo "teattttttttttt: $SERVICE_NAME"
  local NAMESPACE=${2:-default}
  local READY=0
  for i in {1..60}; do 
    local EXTERNAL_IP=$(kubectl get svc $SERVICE_NAME --namespace $NAMESPACE -o jsonpath='{.status.loadBalancer.ingress[0].ip}')
    if [[ -n "$EXTERNAL_IP" && "$EXTERNAL_IP" != "<pending>" ]]; then
      READY=1
      break
    else
      echo "En attente le service $SERVICE_NAME soit pres..."
      sleep 5
    fi
  done
  return $READY
}

# Ouvrir le tunnel Minikube
echo "Ouverture du tunnel Minikube..."
minikube tunnel & # Puede requerir contraseña
TUNNEL_PID=$!

# Attendre que le tunnel soit établi et que les services obtiennent une adresse IP externe
echo "Attente de l'établissement du tunnel Minikube et de l'obtention des adresses IP externes..."

sleep 30



attendre_ip_externe() {
    local nom_service=$1
    echo "En attente de l'adresse IP externe pour le service $nom_service..."
    while [ -z "$(kubectl get svc $nom_service -o jsonpath='{.status.loadBalancer.ingress[0].ip}')" ]; do
        echo "En attente de l'adresse IP externe pour $nom_service..."
        sleep 1
    done
    local ip_externe=$(kubectl get svc $nom_service -o jsonpath='{.status.loadBalancer.ingress[0].ip}')
    echo "Adresse IP externe pour $nom_service : $ip_externe"
}

# Récupérer les adresses IP externes pour les services nécessaires
attendre_ip_externe nodejs-app-service
attendre_ip_externe prometheus
attendre_ip_externe grafana



# Afficher les pods créés
echo "Pods créés :"
kubectl get pods

# Afficher les services créés
echo "Services créés :"
kubectl get services

# Afficher les HorizontalPodAutoscalers
echo "HorizontalPodAutoscalers :"
kubectl get hpa

# Afficher les VerticalPodAutoscalers
echo "VerticalPodAutoscalers :"
kubectl get vpa

# Tuer le processus du tunnel Minikube
kill $TUNNEL_PID

