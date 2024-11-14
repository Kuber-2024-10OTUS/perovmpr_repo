# Выполнено ДЗ №2
 - [x] Основное ДЗ
 - [x] Задание со *

## В процессе сделано:
 - Создано пространство имён `homework`.
 - Создано развёртывание `myapp`.
 - Развёртывание `myapp` будет иметь 3 экземпляра приложения из ДЗ №1.
 - В развёртывании `myapp` использовалась стратегия RollingUpdate и параметром `maxUnavailable=1` для того чтобы во время обновления подов единовременно был недоступен только 1 под. 
 - Добавлена `readinessProbe` для проверки того, что Pod может корректно и может принимать входящий трафик.
 - Поды развёртывания `myapp` запускаются только на нодах с label `homework=true`. Для этого используется `nodeAffinity`. 

## Как запустить проект:
Создать развёртывание: 
```shell
cd kubernetes-controllers
kubectl apply -f ./namespace.yaml
kubectl apply -f ./deployment.yaml
```
Добавить метку ноде:
```shell
# Получить список доступных нод
❯ kubectl get node
NAME       STATUS   ROLES           AGE   VERSION
minikube   Ready    control-plane   37d   v1.31.0

# Добавить метку `homework=true` ноде `minikube`
❯ kubectl label nodes minikube homework=true
node/minikube labeled

# Проверить что метка добавлена
❯ kubectl get node --show-labels | grep homework=true
minikube   Ready    control-plane   37d   v1.31.0   beta.kubernetes.io/arch=amd64,beta.kubernetes.io/os=linux,homework=true,kubernetes.io/arch=amd64,kubernetes.io/hostname=minikube,kubernetes.io/os=linux,minikube.k8s.io/commit=210b148df93a80eb872ecbeb7e35281b3c582c61,minikube.k8s.io/name=minikube,minikube.k8s.io/primary=true,minikube.k8s.io/updated_at=2024_10_07T15_47_12_0700,minikube.k8s.io/version=v1.34.0,node-role.kubernetes.io/control-plane=,node.kubernetes.io/exclude-from-external-load-balancers=
```

## Как проверить работоспособность:

### Проверка, того что создано 3 пода
Выполнить команду:
```shell
❯ kubectl get po
NAME                     READY   STATUS    RESTARTS   AGE
myapp-5544cd8944-5rz6p   1/1     Running   0          17m
myapp-5544cd8944-h6x82   1/1     Running   0          17m
myapp-5544cd8944-hv582   1/1     Running   0          17m
```
### Поверка стратегии развёртывания:

Выполнить команду:
```shell
# Сменить версию контейнера init
❯ kubectl set image deployments.apps myapp init=busybox:1.36
deployment.apps/myapp image updated

# Проверить состояние объекта replicaSet. В процессе обновления не доступен 1 под.
❯ kubectl get rs
NAME               DESIRED   CURRENT   READY   AGE
myapp-74756ff544   2         2         0       4s
myapp-84ffdc796c   2         2         2       40s
```
### Проверка readinessProbe
```shell
# Удалим в произвольном в контейнере `webserver` произвольного пода файл  `/homework/index.html`
❯ kubectl exec myapp-74756ff544-ktllz -c webserver -ti -- rm /homework/index.html

# Получим параметр `ready` контейнера `webserver`. Контейнер не готов к работе.
❯ kubectl get pod myapp-74756ff544-ktllz -o custom-columns=NAMESPACE:metadata.namespace,POD:metadata.name,READY-true:status.containerStatuses\[0\].ready
NAMESPACE   POD                      READY-true
homework    myapp-74756ff544-ktllz   false

# Вернём файл на место 
❯ kubectl exec myapp-74756ff544-ktllz -c webserver -- curl https://examples.http-client.intellij.net/forms/post -o /homework/index.html
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100  1397  100  1397    0     0   7756      0 --:--:-- --:--:-- --:--:--  7761

# Проверим под. Под готов к работе.
❯ kubectl get pod myapp-74756ff544-ktllz -o custom-columns=NAMESPACE:metadata.namespace,POD:metadata.name,READY-true:status.containerStatuses\[0\].ready
NAMESPACE   POD                      READY-true
homework    myapp-74756ff544-ktllz   true
```
### Проверка привязки подов к ноде. 
```shell
# Удалим развёртывание
❯ kubectl delete namespaces homework
namespace "homework" deleted

# Удалим метку `homework=true` у ноды
❯ kubectl label nodes minikube homework-
node/minikube unlabeled

# Создадим развёртывание
❯ kubectl apply -f ./namespace.yaml
namespace/homework created

❯ kubectl apply -f ./deployment.yaml
deployment.apps/myapp created

# Проверим состояние развёртывания. 
❯ kubectl get po
NAME                     READY   STATUS    RESTARTS   AGE
myapp-74756ff544-6dxth   0/1     Pending   0          29s
myapp-74756ff544-75c62   0/1     Pending   0          29s
myapp-74756ff544-chwxc   0/1     Pending   0          29s

# Развёртывание не может быть запланировано. 
❯ kubectl events
LAST SEEN   TYPE      REASON              OBJECT                        MESSAGE
69s         Normal    SuccessfulCreate    ReplicaSet/myapp-74756ff544   Created pod: myapp-74756ff544-qzd25
69s         Normal    SuccessfulCreate    ReplicaSet/myapp-74756ff544   Created pod: myapp-74756ff544-6wqd6
69s         Normal    SuccessfulCreate    ReplicaSet/myapp-74756ff544   Created pod: myapp-74756ff544-kxvs8
69s         Normal    ScalingReplicaSet   Deployment/myapp              Scaled up replica set myapp-74756ff544 to 3
69s         Warning   FailedScheduling    Pod/myapp-74756ff544-qzd25    0/1 nodes are available: 1 node(s) didn't match Pod's node affinity/selector. preemption: 0/1 nodes are available: 1 Preemption is not helpful for scheduling.
68s         Warning   FailedScheduling    Pod/myapp-74756ff544-6wqd6    0/1 nodes are available: 1 node(s) didn't match Pod's node affinity/selector. preemption: 0/1 nodes are available: 1 Preemption is not helpful for scheduling.
68s         Warning   FailedScheduling    Pod/myapp-74756ff544-kxvs8    0/1 nodes are available: 1 node(s) didn't match Pod's node affinity/selector. preemption: 0/1 nodes are available: 1 Preemption is not helpful for scheduling.

# Добавим метку на ноду.
❯ kubectl label nodes minikube homework=true
node/minikube labeled

# Поды стартовали успешно. 
❯ kubectl get po
NAME                     READY   STATUS    RESTARTS   AGE
myapp-74756ff544-6wqd6   1/1     Running   0          3m32s
myapp-74756ff544-kxvs8   1/1     Running   0          3m32s
myapp-74756ff544-qzd25   1/1     Running   0          3m32s
```

## PR checklist:
 - [x] Выставлен label с темой домашнего задания
