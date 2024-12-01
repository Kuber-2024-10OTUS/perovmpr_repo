# Выполнено ДЗ №4 по теме "Настройка сервисных аккаунтов и ограничение прав для них"

- [x] Основное ДЗ
- [x] Задание со *

## В процессе сделано:
- Перенесены deployment и namespace из задания `kubernetes-networks`.
- Создан манифест `rbac-monitoring.yaml` в котором описывается service account `monitoring` и его права и привязки прав
для возможности получения /metrics кластера.
- Изменён манифест `deployment.yaml` так чтобы поды запускались от service account `monitoring`.
- Создан манифест `rbac-cd.yaml` в котором описывается service account `cd` и даётся ему роль admin в рамках namespace.
- Был создан файл kubeconfig, который не приложен в репозиторий, но процесс его получения описан в разделе "Как проверить работоспособность".
- Так же описан процесс получения token для service account cd.
- В манифест `deployment.yaml` добавлен дополнительный init container `metrics` который скачивает /metrics кластера и сохраняет их в /init/metrics.html. 

## Как запустить проект:
- Создать все объекты

```shell
cd kubernetes-security
kubectl create -f namespace.yaml
kubectl create -f cm.yaml
kubectl create -f storageClass.yaml
kubectl create -f pwc.yaml
kubectl create -f rbac-cd.yaml
kubectl create -f rbac-monitoring.yaml
kubectl create -f deployment.yaml
kubectl create -f service.yaml
kubectl create -f ingress.yaml
```

## Как проверить работоспособность:
### Проверим kubeconfig для service account `cd`
```shell
#Получить токен для service account cd c временем жизни 1 день
TOKEN=$(kubectl create token cd --duration 1440m)
# Создаем нового пользователя
kubectl config --kubeconfig=cd set-credentials cd --token=${TOKEN}
# Создаем нового кластера
kubectl config --kubeconfig=cd set-cluster minikube --server=https://127.0.0.1:64667  --insecure-skip-tls-verify

# Создаем новый контекст
kubectl config --kubeconfig=cd set-context cd --cluster=minikube --user=cd --namespace=homework

# Устанавливаем текущий контекст
kubectl --kubeconfig=cd config use-context cd
# Проверим под кем выполнен вход. Определён как service account cd
❯ kubectl --kubeconfig=cd auth whoami
ATTRIBUTE                                           VALUE
Username                                            system:serviceaccount:homework:cd
UID                                                 b88b0a13-7033-4d54-84d3-9d859a40da38
Groups                                              [system:serviceaccounts system:serviceaccounts:homework system:authenticated]
Extra: authentication.kubernetes.io/credential-id   [JTI=527476db-af47-4dc5-9e2f-aa0c89e04bbb]
# Получим все поды namesapce=homework
❯ kubectl --kubeconfig=cd get po
NAME                     READY   STATUS    RESTARTS   AGE
myapp-74b4877d67-gkmxp   1/1     Running   0          6m48s
myapp-74b4877d67-k7nvf   1/1     Running   0          6m48s
myapp-74b4877d67-xqbql   1/1     Running   0          6m48s
# Попробуем получить доступ к другим namespace. Получаем ошибку.
❯ kubectl --kubeconfig=cd get po -A
Error from server (Forbidden): pods is forbidden: User "system:serviceaccount:homework:cd" cannot list resource "pods" in API group "" at the cluster scope
``` 
### Проверим что по http://homework.otus/metrics.html мы получаем метрики кластера. 
 ```shell
❯ curl -s -o /dev/null -w "status code - %{http_code} \n" homework.otus/metrics.html
status code - 200
``` 

## PR checklist:
- [x] Выставлен label с темой домашнего задания

