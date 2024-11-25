# Выполнено ДЗ № 4 по теме "Volumes, StorageClass, PV, PVC"
- [x] Основное ДЗ
- [x] Задание со *

## В процессе сделано:
- Было создано постоянное хранилище файлов
- Был создан объект configMap. Он был в дальнейшем подключен к подам виде хранилища.
- В рамках задания со * был создан storageClass с provisioner: k8s.io/minikube-hostpath. Он был использован в PVC

## Как запустить проект:
- Для запуска проекта выполнить команду
```shell
cd kubernetes-volumes
kubectl apply -f namespace.yaml -f storageClass.yaml -f pvc.yaml -f deployment.yaml -f cm.yaml -f service.yaml -f ingress.yaml
```

## Как проверить работоспособность:
- Подключиться к minikube командой `minikube ssh` и прописать в файле /etc/hosts ip для домена `homework.otus`.
- Проверим доступ к `homework.otus`

 ```shell
docker@minikube:~$ curl -s  homework.otus/conf/file
<!doctype html>
  <html lang="en">
  <head>
    <meta charset="UTF-8">
    <meta name="viewport"
    content="width=device-width, user-scalable=no, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0">
    <meta http-equiv="X-UA-Compatible" content="ie=edge">
    <title>Document</title>
  </head>
  <body>
    <p> config/file </p>
  </body>
  </html>
docker@minikube:~$
``` 

## PR checklist:
- [x] Выставлен label с темой домашнего задания
