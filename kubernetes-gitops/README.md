# Выполнено ДЗ №10 GitOps и инструменты поставки.

- [x] Основное ДЗ

## В процессе сделано:
 - Настроен managed Kubernetes cluster в Yandex cloud. 
 - Установлен ArcoCd c помощью Helm-чарта.
 - Создан и установлен project с именем `otus`.
 - Создано и установлено в кластер Application `kubernetes-networks`. 
 - Создано и установлено в кластер Application `kubernetes-templating`. 
 - Проверено, что все приложения запущены и компоненты ArgoCd и приложения запущены на разных нодах.

## Как запустить проект:
### Установка ArgoCd
```shell
❯ cd kubernetes-gitops
# Установка 
❯ helmfile sync
# Установка  project и application
kubectl apply -f otus-project.yaml -f templating-app.yaml -f networks-app.yaml
```
## Как проверить работоспособность:
### Проверка работы ArgoCd
 - Проверить что Helm-чарт установлен  
```shell
❯ helm list -n argocd
NAME    NAMESPACE       REVISION        UPDATED                                 STATUS          CHART           APP VERSION
argo    argocd          1               2025-01-19 10:20:56.072239977 +0300 MSK deployed        argo-cd-7.7.11  v2.13.2 
```
 - Проверить что все компоненты ArgoCd запущены 
```shell
❯ kubectl get po -n argocd -o=custom-columns=NAME:.metadata.name,STATUS:.status.phase,NODE:.spec.nodeName
NAME                                                     STATUS    NODE
argo-argocd-application-controller-0                     Running   cl1qgal4c83u8eher82i-eliq
argo-argocd-applicationset-controller-78975674d7-pt474   Running   cl1qgal4c83u8eher82i-eliq
argo-argocd-applicationset-controller-78975674d7-sr2zq   Running   cl1qgal4c83u8eher82i-eliq
argo-argocd-dex-server-6f9d4f99b9-dwrh9                  Running   cl1qgal4c83u8eher82i-eliq
argo-argocd-notifications-controller-bffc8b9db-5kq6s     Running   cl1qgal4c83u8eher82i-eliq
argo-argocd-repo-server-556bcfbbc4-j78hb                 Running   cl1qgal4c83u8eher82i-eliq
argo-argocd-repo-server-556bcfbbc4-z5mjq                 Running   cl1qgal4c83u8eher82i-eliq
argo-argocd-server-684fbbfdcb-4h69l                      Running   cl1qgal4c83u8eher82i-eliq
argo-argocd-server-684fbbfdcb-kwxdf                      Running   cl1qgal4c83u8eher82i-eliq
argo-redis-ha-haproxy-7b7dbbdfbd-9c95h                   Running   cl1qgal4c83u8eher82i-eliq
argo-redis-ha-haproxy-7b7dbbdfbd-m5kx4                   Running   cl1qgal4c83u8eher82i-eliq
argo-redis-ha-haproxy-7b7dbbdfbd-pfpgs                   Running   cl1qgal4c83u8eher82i-eliq
argo-redis-ha-server-0                                   Running   cl1qgal4c83u8eher82i-eliq
argo-redis-ha-server-1                                   Running   cl1qgal4c83u8eher82i-eliq
argo-redis-ha-server-2                                   Running   cl1qgal4c83u8eher82i-eliq
```
 - Запустить port-forward 8080:443
```shell
❯ kubectl port-forward service/argo-argocd-server -n argocd 8080:443
```
 - Получить пароль для пользователя admin
```shell
❯ kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d
```
 - Перейти по адрессу http://127.0.0.1:8080
 - Использовать пользователя admin и ренее полученный пароль выполнить вход на сайт. 
 - Проверить что приложение `kubernetes-networks` и `kubernetes-templating` установлены и работают.
```shell
❯ kubectl get po -n homework  -o=custom-columns=NAME:.metadata.name,STATUS:.status.phase,NODE:.spec.nodeName
NAME                     STATUS    NODE
myapp-7f9f4477f5-h472z   Running   cl1f6l2ttoq88i0ot0j3-epum
myapp-7f9f4477f5-jvv6h   Running   cl1f6l2ttoq88i0ot0j3-epum
myapp-7f9f4477f5-t2hn2   Running   cl1f6l2ttoq88i0ot0j3-epum

❯ kubectl get po -n homework-helm  -o=custom-columns=NAME:.metadata.name,STATUS:.status.phase,NODE:.spec.nodeName
NAME                              STATUS    NODE
my-app-redis-master-0             Running   cl1f6l2ttoq88i0ot0j3-epum
my-chart-my-app-8b557d9bc-4v62d   Running   cl1f6l2ttoq88i0ot0j3-epum
my-chart-my-app-8b557d9bc-9xrkt   Running   cl1f6l2ttoq88i0ot0j3-epum
my-chart-my-app-8b557d9bc-bzjmm   Running   cl1f6l2ttoq88i0ot0j3-epum
```
 - Как можно заметить компоненты ArgoCd и приложения установлены на разные ноды. Компоненты установлены ArgoCd
на ноду с именем `cl1qgal4c83u8eher82i-eliq`. Приложения установлены на ноду `cl1f6l2ttoq88i0ot0j3-epum`
## PR checklist:
 - [x] Выставлен label с темой домашнего задания
