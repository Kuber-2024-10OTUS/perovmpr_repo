#!/bin/bash

# Проверяем, запущен ли скрипт с правами root
if [ "$EUID" -ne 0 ]; then
  echo "Пожалуйста, запустите этот скрипт с правами root."
  exit 1
fi

# Определяем версию Kubernetes из параметра или используем значение по умолчанию
K8S_VERSION="${1:-1.31}"

# Обновляем систему
echo "Обновление системы..."
apt update && apt upgrade -y

# Устанавливаем необходимые пакеты
echo "Установка необходимых пакетов..."
apt install -y apt-transport-https ca-certificates curl gpg

# Добавляем репозиторий Docker
echo "Добавление репозитория Docker..."
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null

# Обновляем список пакетов после добавления репозитория Docker
apt update

# Устанавливаем Docker
echo "Установка Docker..."
apt install -y containerd.io
mkdir -p /etc/containerd
containerd config default |
tee /etc/containerd/config.toml
sudo sed -i 's/SystemdCgroup = false/SystemdCgroup = true/g' /etc/containerd/config.toml
systemctl restart containerd

# Настройка systemd для работы с containerd
cat <<EOF | tee /etc/modules-load.d/k8s.conf
overlay
br_netfilter
EOF
modprobe overlay
modprobe br_netfilter

# Настройка sysctl параметров для кластера Kubernetes
cat <<EOF | tee /etc/sysctl.d/k8s.conf
net.ipv4.ip_forward = 1
EOF

sysctl --system

# Отключаем swap
echo "Отключение swap..."
swapoff -a
sed -i '/ swap / s/^\(.*\)$/#\1/g' /etc/fstab

# Добавляем репозиторий Kubernetes
echo "Добавление репозитория Kubernetes..."
mkdir -p -m 755 /etc/apt/keyrings
curl -fsSL https://pkgs.k8s.io/core:/stable:/v${K8S_VERSION}/deb/Release.key | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg
echo "deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v${K8S_VERSION}/deb/ /" | sudo tee /etc/apt/sources.list.d/kubernetes.list

# Обновляем список пакетов после добавления репозитория Kubernetes
apt update

# Устанавливаем Kubernetes указанной версии
echo "Установка Kubernetes версии ${K8S_VERSION}..."

apt install -y kubelet kubeadm kubectl

# Заблокируем обновление до более новых версий
apt-mark hold kubelet kubeadm kubectl

systemctl enable --now kubelet
# Выводим сообщение о завершении
echo "Настройка завершена! Теперь вы можете инициализировать кластер с помощью kubeadm init."