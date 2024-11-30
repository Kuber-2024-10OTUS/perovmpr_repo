# Выполнено ДЗ №

- [ ] Основное ДЗ
- [ ] Задание со *

## В процессе сделано:
- Пункт 1
- Пункт 2

## Как запустить проект:
- Например, запустить команду X в директории Y

## Как проверить работоспособность:
- Например, перейти по ссылке http://localhost:8080

## PR checklist:
- [ ] Выставлен label с темой домашнего задания
```shell
SA=/var/run/secrets/kubernetes.io/serviceaccount
TOKEN=$(cat ${SA}/token)
NAMESPACE=$(cat ${SA}/namespace)
CACERT=${SA}/ca.crt
KUBEAPI=https://kubernetes.default.svc
curl --cacert ${CACERT} --header "Authorization: Bearer ${TOKEN}" -X GET ${KUBEAPI}/metrics
```