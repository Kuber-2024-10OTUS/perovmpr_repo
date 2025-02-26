# Установка k8s
```shell

sudo chmod +x setup-k8s-1.31.sh
sudo ./setup-k8s-1.31.sh

sudo kubeadm init --pod-network-cidr=10.244.0.0/16 --kubernetes-version=1.31.0

mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config
  
  
```
scp ./setup-k8s-1.31.sh  pier@51.250.107.183:
- Добавление ноды
```shell
sudo chmod +x setup-k8s-1.31.sh
./setup-k8s-1.31.sh

sudo kubeadm token create
openssl x509 -pubkey -in /etc/kubernetes/pki/ca.crt | openssl rsa -pubin -outform der 2>/dev/null | openssl dgst -sha256 -hex | sed 's/^.* //'
sudo kubeadm join 10.129.0.8:6443  --token 3mp45h.fh0jlru7f19bxk85 --discovery-token-ca-cert-hash sha256:ccf1f0f6014b3cb69d2d34e37c9307b581964dd3067bcc6117fed00390c66e2f

# Или 
sudo kubeadm join 10.129.0.8:6443 --token tbni7y.xw8w4ny8n282raqd \
        --discovery-token-ca-cert-hash sha256:71d0183066ea7d5cbf3c6ac4b084c0ff2a0d899a34e2e94afb2a2bbe42ffef0b
``` 
 - Установить `Flannel`
```shell
kubectl apply -f https://github.com/flannel-io/flannel/releases/latest/download/kube-flannel.yml
```
# Проверка работы установленного кластера
```shell
pier@master1:~$  kubectl get nodes -o wide
NAME      STATUS   ROLES           AGE     VERSION   INTERNAL-IP   EXTERNAL-IP   OS-IMAGE             KERNEL-VERSION     CONTAINER-RUNTIME
master1   Ready    control-plane   27m     v1.31.6   10.129.0.8    <none>        Ubuntu 24.04.2 LTS   6.8.0-53-generic   containerd://1.7.25
worker1   Ready    <none>          19m     v1.31.6   10.129.0.12   <none>        Ubuntu 24.04.2 LTS   6.8.0-53-generic   containerd://1.7.25
worker2   Ready    <none>          4m40s   v1.31.6   10.129.0.9    <none>        Ubuntu 24.04.2 LTS   6.8.0-53-generic   containerd://1.7.25
worker3   Ready    <none>          2m53s   v1.31.6   10.129.0.30   <none>        Ubuntu 24.04.2 LTS   6.8.0-53-generic   containerd://1.7.25
```
# Обновление Кластера
```shell
K8S_VERSION=1.32
curl -fsSL https://pkgs.k8s.io/core:/stable:/v${K8S_VERSION}/deb/Release.key | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg
echo "deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v${K8S_VERSION}/deb/ /" | sudo tee /etc/apt/sources.list.d/kubernetes.list
sudo apt update
#sudo apt-get install -y kubelet=1.32.* kubeadm=1.32.* kubectl=1.32.*
#sudo apt-mark hold kubelet kubeadm kubectl
#sudo systemctl enable --now kubelet
sudo apt-mark unhold kubeadm && \
sudo apt-get update && sudo apt-get install -y kubeadm='1.32.0-*' && \
sudo apt-mark hold kubeadm
kubeadm version
kubeadm version: &version.Info{Major:"1", Minor:"32", GitVersion:"v1.32.0", GitCommit:"70d3cc986aa8221cd1dfb1121852688902d3bf53", GitTreeState:"clean", BuildDate:"2024-12-11T18:04:20Z", GoVersion:"go1.23.3", Compiler:"gc", Platform:"linux/amd64"}
```
 - Обновим control-plane ноду
```shell
#Обновить  kubeadm
K8S_VERSION=1.32
curl -fsSL https://pkgs.k8s.io/core:/stable:/v${K8S_VERSION}/deb/Release.key | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg
echo "deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v${K8S_VERSION}/deb/ /" | sudo tee /etc/apt/sources.list.d/kubernetes.list
sudo apt update
sudo apt-mark unhold kubeadm && \
sudo apt-get update && sudo apt-get install -y kubeadm='1.32.0-*' && \
sudo apt-mark hold kubeadm
kubeadm version
kubeadm version: &version.Info{Major:"1", Minor:"32", GitVersion:"v1.32.0", GitCommit:"70d3cc986aa8221cd1dfb1121852688902d3bf53", GitTreeState:"clean", BuildDate:"2024-12-11T18:04:20Z", GoVersion:"go1.23.3", Compiler:"gc", Platform:"linux/amd64"}

#Посмотреть последовательность действий для обновления 
sudo kubeadm upgrade plan


```
 - Обновить мастер ноды 1.32.0
```shell
sudo kubeadm upgrade apply v1.32.0
```
 - Обновить kubelet
```shell
sudo apt update
sudo apt-mark unhold kubelet kubeadm && \
sudo apt-get update && sudo apt-get install -y kubelet='1.32.2-*' kubeadm='1.32.2-*' && \
sudo apt-mark hold kubelet kubeadm
```

- Обновить ноду worker1
```shell
kubectl drain worker1 --ignore-daemonsets
K8S_VERSION=1.32
curl -fsSL https://pkgs.k8s.io/core:/stable:/v${K8S_VERSION}/deb/Release.key | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg
echo "deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v${K8S_VERSION}/deb/ /" | sudo tee /etc/apt/sources.list.d/kubernetes.list
sudo apt update
sudo apt-mark unhold kubelet kubeadm&& \
sudo apt-get update && sudo apt-get install -y kubelet='1.32.2-*' kubeadm='1.32.2-*' && \
sudo apt-mark hold kubelet kubeadm
kubectl uncordon worker1
```
- Обновить ноду worker2
```shell
kubectl drain worker2 --ignore-daemonsets
K8S_VERSION=1.32
curl -fsSL https://pkgs.k8s.io/core:/stable:/v${K8S_VERSION}/deb/Release.key | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg
echo "deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v${K8S_VERSION}/deb/ /" | sudo tee /etc/apt/sources.list.d/kubernetes.list
sudo apt update
sudo apt-mark unhold kubelet kubeadm&& \
sudo apt-get update && sudo apt-get install -y kubelet='1.32.2-*' kubeadm='1.32.2-*' && \
sudo apt-mark hold kubelet kubeadm
kubectl uncordon worker2
 ```
- Обновить ноду worker3
```shell
kubectl drain worker3 --ignore-daemonsets
K8S_VERSION=1.32
curl -fsSL https://pkgs.k8s.io/core:/stable:/v${K8S_VERSION}/deb/Release.key | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg
echo "deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v${K8S_VERSION}/deb/ /" | sudo tee /etc/apt/sources.list.d/kubernetes.list
sudo apt update
sudo apt-mark unhold kubelet kubeadm&& \
sudo apt-get update && sudo apt-get install -y kubelet='1.32.2-*' kubeadm='1.32.2-*' && \
sudo apt-mark hold kubelet kubeadm
kubectl uncordon worker3
```

- Обновить мастер ноды до 1.32.2
```shell
kubeadm upgrade apply v1.32.2
```
- Готово
```shell
pier@master1:~$ kubectl get nodes -o wide
NAME      STATUS   ROLES           AGE     VERSION   INTERNAL-IP   EXTERNAL-IP   OS-IMAGE             KERNEL-VERSION     CONTAINER-RUNTIME
master1   Ready    control-plane   6d10h   v1.32.2   10.129.0.8    <none>        Ubuntu 24.04.2 LTS   6.8.0-53-generic   containerd://1.7.25
worker1   Ready    <none>          6d10h   v1.32.2   10.129.0.12   <none>        Ubuntu 24.04.2 LTS   6.8.0-53-generic   containerd://1.7.25
worker2   Ready    <none>          6d9h    v1.32.2   10.129.0.9    <none>        Ubuntu 24.04.2 LTS   6.8.0-53-generic   containerd://1.7.25
worker3   Ready    <none>          6d9h    v1.32.2   10.129.0.30   <none>        Ubuntu 24.04.2 LTS   6.8.0-53-generic   containerd://1.7.25
```