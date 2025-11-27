#!/bin/bash
set -euo pipefail

NAMESPACE="devops-challenge"
POD=$(kubectl -n $NAMESPACE get pods -l app=devops-challenge -o jsonpath='{.items[0].metadata.name}')

echo "=== System Check Report ==="
echo

echo "1. UID inside the container (should not be 0):"
kubectl -n $NAMESPACE exec $POD -- id -u
echo

echo "2. Process listening on port 80 inside container:"
kubectl -n $NAMESPACE exec $POD -- sh -c "ss -ltnp || netstat -tulpn || true"
echo

echo "3. Testing application endpoint via port-forward:"

# Start port-forward in background, output logs for debug
kubectl -n $NAMESPACE port-forward svc/devops-challenge 8080:80 >/tmp/port-forward.log 2>&1 &
PF=$!

# Wait until port 8080 responds
for i in {1..15}; do
    if curl -s http://localhost:8080/ >/dev/null 2>&1; then
        break
    fi
    sleep 1
done

# Curl the endpoint
curl -s http://localhost:8080/
echo

# Stop port-forward
kill $PF
echo "=== End of System Check ==="

