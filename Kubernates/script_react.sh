#!/bin/bash                                                                                                                                                                                                                                   


# Déployer la configuration React
kubectl apply -f react-deployment.yaml
kubectl apply -f react-service.yaml



# Récupérer l'adresse IP externe du service React
kubectl get service

REACT_IP=$(kubectl get service react-app -o jsonpath='{.status.loadBalancer.ingress[0].ip}')
echo "Adresse IP externe du service React : $REACT_IP"

