# Выполнено ДЗ №7 Создание собственного CRD

 - [x] Основное ДЗ
 - [x] Задание со *
 - [x] Задание со **   

## В процессе сделано:
 - Создана и сконфигурирована CRD `MySQL`. Установлен оператор для него.
 - Создан и установлен собственный CRD `MySQL` и оператор для него.

## Как запустить проект:
### Установить CRD `MySQL` и оператор из основного ДЗ
 - Установить собственный CRD `MYSQL` и оператор. Устанавливаться только на k8s 1.28. Поэтому в yandex.cloud.
```shell
cd kubernetes-operators
# Установить CRD и оператор
kubectl apply -f sc.yaml -f serviceaccount.yaml -f rbac.yaml -f mysql.yaml -f crd.yaml -f deployment.yaml
```  

### Установить CRD `MySQL` и собственный оператор 
 - Соберём образ оператора и загрузим его в docker hub
```shell
cd operator
make docker-build docker-push IMG=perovmpr/mysql-operator:v1.0.0
make build-installer IMG=perovmpr/mysql-operator:v1.0.0
```
 - Установим CRD
```shell
k apply -f dist/install.yaml  
```
- Создадим CRD `MySQL`
```shell
cd kubernetes-operators
kubectl apply -f mysql_perovmpr_operator.yaml
```
 

## Как проверить работоспособность:

### Проверка CRD `MySQL` и оператор из основного ДЗ
 - Проверим на корректность установки и работу оператора
```shell
# Проверить оператор
❯ kubectl get deployments.apps mysql-operator
NAME             READY   UP-TO-DATE   AVAILABLE   AGE
mysql-operator   1/1     1            1           37s
# Проверить PV 
❯ kubectl get pv | grep mysql-pv
example-mysql-pv                           10Gi       RWO            Retain           Bound    default/example-mysql-pvc               standard       <unset>                          116s

# Проверить PVC 
❯ kubectl get pvc | grep mysql-pvc
example-mysql-pvc   Bound    example-mysql-pv   10Gi       RWO            standard       <unset>                 2m26s
# Проверить установленный mysql сервер 
❯ kubectl get deployments.apps example-mysql
NAME            READY   UP-TO-DATE   AVAILABLE   AGE
example-mysql   1/1     1            1           83s

#Проверить mysql 
❯ kubectl exec example-mysql-dfdd6878d-w529m -ti -- mysql -uroot -pexamplepass
mysql: [Warning] Using a password on the command line interface can be insecure.
Welcome to the MySQL monitor.  Commands end with ; or \g.
Your MySQL connection id is 68
Server version: 5.7.44 MySQL Community Server (GPL)

Copyright (c) 2000, 2023, Oracle and/or its affiliates.

Oracle is a registered trademark of Oracle Corporation and/or its
affiliates. Other names may be trademarks of their respective
owners.

Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.

mysql> exit
Bye
```
- Проверим корректное удаление CRD и его зависимостей. Все развёрнутые ресурсы удалены. 
```shell
# Удалить CRD
❯ kubectl delete mysqls.otus.homework/example-mysql
mysql.otus.homework "example-mysql" deleted
# Проверить удаление mysql сервера
❯  kubectl get deployments.apps example-mysql
Error from server (NotFound): deployments.apps "example-mysql" not found
# Проверить удаление pvc
❯ kubectl get pvc | grep mysql-pvc
No resources found in default namespace.
# Проверить удаление pv
❯ kubectl get pv | grep mysql-pv
```
- Удалим оператор.
```shell
❯ kubectl delete deployments.apps mysql-operator
deployment.apps "mysql-operator" deleted
❯ kubectl get deployments.apps mysql-operator
Error from server (NotFound): deployments.apps "mysql-operator" not found
```
### Проверка CRD `MySQL` и из дополнительного задания и собственного оператора
 - Проверим на корректность установки и работу оператора
```shell
❯ kubectl get po -n operator-system
NAME                                           READY   STATUS    RESTARTS   AGE
operator-controller-manager-7575f9f68f-8h7zg   1/1     Running   0          23s
```
 - Проверить установленный mysql сервер
```shell
# Проверить PV 
❯ kubectl get pv example-mysql-pv
NAME               CAPACITY   ACCESS MODES   RECLAIM POLICY   STATUS   CLAIM                   STORAGECLASS     REASON   AGE
example-mysql-pv   1Gi        RWO            Delete           Bound    default/example-mysql   yc-network-hdd            10h
# Проверить PVC 
❯ kubectl get pvc example-mysql
NAME            STATUS   VOLUME             CAPACITY   ACCESS MODES   STORAGECLASS     AGE
example-mysql   Bound    example-mysql-pv   1Gi        RWO            yc-network-hdd   11h
# Проверить установленный mysql сервер
❯ kubectl get deployments.apps example-mysql 
NAME            READY   UP-TO-DATE   AVAILABLE   AGE
example-mysql   0/1     1            0           10h
#Проверить mysql 
❯ kubectl exec  example-mysql-64f9cc486-ltfz8  -ti -- mysql -uroot -pexamplepass
mysql: [Warning] Using a password on the command line interface can be insecure.
Welcome to the MySQL monitor.  Commands end with ; or \g.
Your MySQL connection id is 2
Server version: 5.7.44 MySQL Community Server (GPL)

Copyright (c) 2000, 2023, Oracle and/or its affiliates.

Oracle is a registered trademark of Oracle Corporation and/or its
affiliates. Other names may be trademarks of their respective
owners.

Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.

mysql>
```
 - Проверим корректное удаление CRD и его зависимостей. Все развёрнутые ресурсы удалены. 
```shell
# Удалить CRD
❯ kubectl delete mysqls.otus.homework/example-mysql
mysql.otus.homework "example-mysql" deleted
# Проверить удаление mysql сервера
❯  kubectl get deployments.apps example-mysql
Error from server (NotFound): deployments.apps "example-mysql" not found
# Проверить удаление pvc
❯  kubectl get pvc example-mysql
Error from server (NotFound): persistentvolumeclaims "example-mysql" not found
# Проверить удаление pv
❯ kubectl get pv example-mysql-pv
Error from server (NotFound): persistentvolumes "example-mysql-pv" not found
```
## PR checklist:
 - [x] Выставлен label с темой домашнего задания
