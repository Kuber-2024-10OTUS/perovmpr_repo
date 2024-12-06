# Выполнено ДЗ № 6 по теме "Шаблонизация манифестов приложения, использование Helm. Установка community Helm charts"

- [x] Основное ДЗ
- [x] Задание со *

## В процессе сделано:
- Создан helm chart my-chart на основе предыдущего задания. 
- Создан `helmfile.yaml` для установки `kafka` в двух средах `dev` и `prod`. 

## Как запустить проект:
### Установка chart `my-chart`.
```shell
cd kubernetes-templating
❯ helm install my-app ./my-chart --set=replicaCount=3 -n homehork --create-namespace
NAME: my-app
LAST DEPLOYED: Fri Dec  6 09:48:20 2024
NAMESPACE: homehork
STATUS: deployed
REVISION: 1
TEST SUITE: None
NOTES:
Для доступа выполните запрос по адресу:
  http://homework.otus
```
- Например, перейти по ссылке http://homework.otus

### Установка kafka из helmfile.
## Как проверить работоспособность:
```shell
cd kubernetes-templating
# Установка приложения в prod
❯ helmfile apply -l name=prod
# пропуск вывода
Substituted images detected:
  - docker.io/bitnami/kafka:3.5.2

Listing releases matching ^prod$
prod    prod            1               2024-12-06 09:53:55.89707832 +0300 MSK  deployed        kafka-30.1.8    3.8.1      


UPDATED RELEASES:
NAME   NAMESPACE   CHART           VERSION   DURATION
prod   prod        bitnami/kafka   30.1.8          0s

# Установка приложения в dev
❯ helmfile apply -l name=dev
# пропуск вывода

Substituted images detected:
- docker.io/bitnami/kafka:latest

Listing releases matching ^dev$
dev     dev             1               2024-12-06 09:55:38.209660202 +0300 MSK deployed        kafka-30.1.8    3.8.1


UPDATED RELEASES:
NAME   NAMESPACE   CHART           VERSION   DURATION
dev    dev         bitnami/kafka   30.1.8          0s
```


## PR checklist:
- [x] Выставлен label с темой домашнего задания
