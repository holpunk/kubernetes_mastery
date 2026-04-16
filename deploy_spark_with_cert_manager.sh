#!/bin/bash

set -euo pipefail

echo "--- Deploying Spark with Cert-Manager ---"

# --- Configuration ---
SPARK_HELM_CHART_PATH="./infrastructure/helm_charts/spark"
SPARK_RELEASE_NAME="my-spark"
SPARK_NAMESPACE="spark" # You might want to create a dedicated namespace
SPARK_HOSTNAME="spark.example.com" # IMPORTANT: Change this to your actual desired hostname
CERT_MANAGER_ISSUER_NAME="selfsigned-issuer" # Matches the default in values.yaml

# --- 1. Install cert-manager (if not already installed) ---
echo "Checking for cert-manager installation..."
if ! kubectl get namespace cert-manager &> /dev/null; then
    echo "cert-manager namespace not found. Installing cert-manager..."
    kubectl apply -f https://github.com/cert-manager/cert-manager/releases/download/v1.13.1/cert-manager.yaml
    echo "Waiting for cert-manager to be ready..."
    kubectl wait --for=condition=available deployment --timeout=300s -n cert-manager --all
    echo "cert-manager installed successfully."
else
    echo "cert-manager namespace already exists. Skipping installation."
fi

# --- 2. Create Spark Namespace (if not already created) ---
echo "Creating Spark namespace '$SPARK_NAMESPACE' if it doesn't exist..."
kubectl create namespace "$SPARK_NAMESPACE" --dry-run=client -o yaml | kubectl apply -f -
echo "Spark namespace '$SPARK_NAMESPACE' ensured."

# --- 3. Create a ClusterIssuer for cert-manager ---
# For demonstration, we'll use a SelfSignedIssuer.
# For production, you'd typically use a Let's Encrypt ClusterIssuer.
echo "Creating SelfSigned ClusterIssuer '$CERT_MANAGER_ISSUER_NAME'..."
cat <<EOF | kubectl apply -f -
apiVersion: cert-manager.io/v1
kind: ClusterIssuer
metadata:
  name: ${CERT_MANAGER_ISSUER_NAME}
spec:
  selfSigned: {}
EOF
echo "SelfSigned ClusterIssuer '$CERT_MANAGER_ISSUER_NAME' created."

# --- 4. Install/Upgrade Spark Helm Chart ---
echo "Installing/Upgrading Spark Helm chart '$SPARK_RELEASE_NAME' in namespace '$SPARK_NAMESPACE'..."
helm upgrade --install "${SPARK_RELEASE_NAME}" "${SPARK_HELM_CHART_PATH}" \
  --namespace "${SPARK_NAMESPACE}" \
  --set ingress.enabled=true \
  --set "ingress.hosts[0].host=${SPARK_HOSTNAME}" \
  --set "ingress.tls[0].hosts[0]=${SPARK_HOSTNAME}" \
  --set "ingress.annotations.cert-manager\.io/cluster-issuer=${CERT_MANAGER_ISSUER_NAME}" \
  --set certManager.issuer="${CERT_MANAGER_ISSUER_NAME}" \
  --wait # Wait for the deployment to be ready
echo "Spark Helm chart deployed successfully."

echo "--- Deployment Complete ---"
echo "You can now access Spark UI at https://${SPARK_HOSTNAME}"
echo "Remember to update your /etc/hosts file or DNS to point ${SPARK_HOSTNAME} to your Ingress controller's IP."
echo "Example /etc/hosts entry (replace <INGRESS_IP> with your Ingress controller's external IP):"
echo "  <INGRESS_IP> ${SPARK_HOSTNAME}"
echo "You can get the Ingress IP by running: kubectl get svc -n ingress-nginx" # Adjust namespace if using a different ingress controller
