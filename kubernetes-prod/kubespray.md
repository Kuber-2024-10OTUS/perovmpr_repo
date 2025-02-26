[//]: # (sudo apt update)
[//]: # (sudo apt install software-properties-common)
[//]: # (sudo add-apt-repository --yes --update ppa:ansible/ansible)
[//]: # (sudo apt install ansible)

ssh-keygen -t rsa
- Скопировать сертификаты на виртуальную машину c ansible
```shell
scp ~/.ssh/ansible/id_rsa pier@158.160.0.1:/home/pier/.ssh/
```
- Скопировать сертификаты на виртуальные машины 
```shell
ssh-copy-id -i ~/.ssh/ansible/id_rsa.pub pier@158.160.72.2
ssh-copy-id -i ~/.ssh/ansible/id_rsa.pub pier@158.160.72.3
ssh-copy-id -i ~/.ssh/ansible/id_rsa.pub pier@158.160.72.4
ssh-copy-id -i ~/.ssh/ansible/id_rsa.pub pier@158.160.72.5
ssh-copy-id -i ~/.ssh/ansible/id_rsa.pub pier@158.160.72.6
```

git clone https://github.com/kubernetes-sigs/kubespray.git
cd kubespray

sudo apt install python3.12-venv
python3 -m venv .venv
source .venv/bin/activate

pip install -r requirements.txt

cp -r inventory/sample/ inventory/mycluster
```shell
sudo nano inventory/mycluster/inventory.ini
[kube_control_plane] 
master1 ansible_host=10.129.0.32
master2 ansible_host=10.129.0.24
master3 ansible_host=10.129.0.8

[etcd:children]
kube_control_plane

[calico-rr]

[kube_node]
worker1 ansible_host=10.129.0.17
worker2 ansible_host=10.129.0.10

[k8s-cluster:children]
kube_control_plane
kube_node
calico-rr
```
```shell
ansible-playbook -i inventory/mycluster/inventory.ini cluster.yml -b -v --become-user=root
```
```shell
root@master2:~# kubectl get nodes -o wide
NAME      STATUS   ROLES           AGE     VERSION   INTERNAL-IP   EXTERNAL-IP   OS-IMAGE             KERNEL-VERSION     CONTAINER-RUNTIME
master1   Ready    control-plane   8m28s   v1.32.0   10.129.0.32   <none>        Ubuntu 24.04.2 LTS   6.8.0-54-generic   containerd://2.0.2
master2   Ready    control-plane   8m15s   v1.32.0   10.129.0.24   <none>        Ubuntu 24.04.2 LTS   6.8.0-54-generic   containerd://2.0.2
master3   Ready    control-plane   8m12s   v1.32.0   10.129.0.8    <none>        Ubuntu 24.04.2 LTS   6.8.0-54-generic   containerd://2.0.2
worker1   Ready    <none>          7m36s   v1.32.0   10.129.0.17   <none>        Ubuntu 24.04.2 LTS   6.8.0-54-generic   containerd://2.0.2
worker2   Ready    <none>          7m35s   v1.32.0   10.129.0.10   <none>        Ubuntu 24.04.2 LTS   6.8.0-54-generic   containerd://2.0.2
```