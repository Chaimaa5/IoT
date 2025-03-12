#Creating a cluster // NameSpaces // Applying config

k3d cluster create Inception-Of-Things
kubectl create namespace argocd
kubectl create namespace dev
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
kubectl apply -f ../mscScr/argocd-app.yaml
kubectl apply -f ../mscScr/deployment.yaml
kubectl wait --for=condition=ready pod -l app.kubernetes.io/name=argocd-server -n argocd --timeout=180s

SECRET=$(kubectl get secret argocd-initial-admin-secret -n argocd -o jsonpath='{.data.password}' | base64 --decode)
echo "Keep the Secret : $SECRET"