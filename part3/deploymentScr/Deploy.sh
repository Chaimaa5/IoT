#Creating a cluster // NameSpaces // Applying config

k3d cluster create Inception-Of-Things
kubectl create namespace argocd
kubectl create namespace dev
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
kubectl apply -f https://github.com/4vr3L/oouazahr-IoT/blob/master/oouazahr-app/k3d-manifests/argocd-app.yaml
kubectl apply -f https://github.com/4vr3L/oouazahr-IoT/blob/master/oouazahr-app/k3d-manifests/deployment.yaml
SECRET=$(kubectl get secret argocd-initial-admin-secret -n argocd -o jsonpath='{.data.password}' | base64 --decode)
echo "Keep the Secret : $SECRET"