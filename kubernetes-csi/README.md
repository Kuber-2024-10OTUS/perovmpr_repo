
# Выполнено ДЗ №12 Установка и использование CSI драйвера

- [x] Основное ДЗ

## В процессе сделано:
- Установлен и сконфигурирован CSI driver для Yandex Object Storage.
- Запустил и использовал полезную нагрузку, использующую для хранения бакет в Yandex Object Storage.
## Как запустить проект:
- Установить csi драйвер конфигурацию для него в secret.yaml и storageClass
```shell
kubectl create -f secret.yaml && \
kubectl create -f https://raw.githubusercontent.com/yandex-cloud/k8s-csi-s3/refs/heads/master/deploy/kubernetes/provisioner.yaml && \
kubectl create -f https://raw.githubusercontent.com/yandex-cloud/k8s-csi-s3/refs/heads/master/deploy/kubernetes/driver.yaml && \
kubectl create -f https://raw.githubusercontent.com/yandex-cloud/k8s-csi-s3/refs/heads/master/deploy/kubernetes/csi-s3.yaml && \
kubectl create -f storageclass.yaml
```
 - Установить полезную нагрузку.
```shell
kubectl apply -f pvc.yaml -f deployment.yaml
```

## Как проверить работоспособность:
- Проверить что поды создают файлы в /data
```shell
 kubectl exec -ti example-csi-6b64d676cc-59lmg -- ls -la /data
total 14
drwxrwxrwx    2 root     root          4096 Feb  2 18:32 .
drwxr-xr-x    1 root     root          4096 Feb  2 18:32 ..
-rw-rw-rw-    1 root     root            61 Feb  2 18:32 file_1738521137.txt
-rw-rw-rw-    1 root     root            61 Feb  2 18:32 file_1738521138.txt
-rw-rw-rw-    1 root     root            61 Feb  2 18:32 file_1738521142.txt
-rw-rw-rw-    1 root     root            61 Feb  2 18:32 file_1738521143.txt
-rw-rw-rw-    1 root     root            61 Feb  2 18:32 file_1738521147.txt
-rw-rw-rw-    1 root     root            61 Feb  2 18:32 file_1738521148.txt
-rw-rw-rw-    1 root     root            61 Feb  2 18:32 file_1738521152.txt
```

## PR checklist:
- [ ] Выставлен label с темой домашнего задания

