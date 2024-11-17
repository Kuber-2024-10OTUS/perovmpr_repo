# Выполнено ДЗ № 3 по теме "Сетевое взаимодействие Pod, сервисы"

- [x] Основное ДЗ
- [x] Задание со *

## В процессе сделано:

- Перенесены deployment и namespace из задания `kubernetes-controllers`
- У основного контейнера `webserver` была изменена `readinessProbe` на http настроенная для проверки ответа
  `/index.html`
- Создал объект service `my-service` типа `clusterIP`. Этот сервис обеспечивает доступ к Pod c label `app: myapp` по 80
  порту.
- Установил в minikube nginx ingress-контроллер.
- Создал объект ingress `my-ingress-root-path` для доступа к Pod по имени `homework.otus`.
- Выполнено задание со *. Создан объект ingress `my-ingress-homework-path` с настроенным rewrite правилом.
- Правило выполнят переадресацию при обращении по адресу http://homework.otus/homepage к подам по адресу ./index.html

## Как запустить проект:

- Для работы потребуется установить Ingress контроллер. Это можно сделать в `minikube` выполнив команду:

```shell
minikube addons enable ingress-dns
```

- Создать все объекты

```shell
cd kubernetes-networks
kubectl create -f namespace.yaml
kubectl create -f deployment.yaml
kubectl create -f service.yaml
kubectl create -f ingress.yaml
```

## Как проверить работоспособность:

- Проверить что все поды запустились

 ```shell
❯ kubectl get po
NAME                     READY   STATUS    RESTARTS   AGE
myapp-749d9d76d8-682z9   1/1     Running   0          17s
myapp-749d9d76d8-7rr4g   1/1     Running   0          17s
myapp-749d9d76d8-js6l5   1/1     Running   0          17s
```

- Подключиться к minikube командой `minikube ssh` и прописать в файле hosts ip для домена `homework.otus`.
- Проверим доступ к `homework.otus`

 ```shell
curl -s -o /dev/null -w "status code - %{http_code} \n" homework.otus. Ok.
status code - 200
``` 

- Проверим доступ к `homework.otus/index.html`

 ```shell
curl -s -o /dev/null -w "status code - %{http_code} \n" homework.otus/index.html. Ok.
status code - 200
```

- Проверим доступ к `homework.otus/homework`. Ok.

 ```shell
curl -s -o /dev/null -w "status code - %{http_code} \n" homework.otus/homework
status code - 200
```

- Проверим доступ к `homework.otus/homework/`. Ok.

 ```shell
curl -s -o /dev/null -w "status code - %{http_code} \n" homework.otus/homework/
status code - 200
```

- Проверим доступ к `homework.otus/homework/index.html`. Ok.

 ```shell
curl -s -o /dev/null -w "status code - %{http_code} \n" homework.otus/homework/index.html
status code - 200
``` 

- Проверим доступ к `homework.otus/other-address`. Ошибка, так как такой маршрут не настроен.

 ```shell
curl -s -o /dev/null -w "status code - %{http_code} \n" homework.otus/other-address
status code - 404
 - Проверим доступ к `homework.otus/homework/other-address.html`. Ошибка, так как такой такого файла нет на подах.
 ```shell
curl -s -o /dev/null -w "status code - %{http_code} \n" homework.otus/homework/other-address.html
status code - 404
```

## PR checklist:

- [x] Выставлен label с темой домашнего задания
