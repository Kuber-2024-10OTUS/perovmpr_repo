# Выполнено ДЗ №11 Хранилище секретов для приложения. Vault.

- [x] Основное ДЗ

## В процессе сделано:

- Установил кластер `hashicorp vault` в HA режиме и сконфигурировал его.
- Установил `External Secret Operator` и настроил для получения секретов.

## Как запустить проект:

- Установить crd external-secrets, кластер consul и vault.

```shell
cd kubernetes-vault
kubectl apply -f https://raw.githubusercontent.com/external-secrets/external-secrets/v0.13.0/deploy/crds/bundle.yaml
helmfile sync
```

- Создать пользователя и дать ему права.

```shell
kubectl apply -f rbac.yaml
```

- Получить токен сервисного аккаунта vault-auth.
```shell
TOKEN=$(kubectl create token vault-auth --duration 525600m)
```
- Инициализировать кластер vault. Записать и сохранить результат. 
```shell
kubectl -n vault exec vault-0 -- sh -c "vault operator init -key-shares=1 -key-threshold=1"

ROOT_TOKEN=Initial Root Token
UNSEAL_TOKEN=Unseal key
```
- Распечатать кластер.
```shell
kubectl -n vault exec vault-0 -- sh -c 'vault operator unseal $UNSEAL_TOKEN'
kubectl -n vault exec vault-1 -- sh -c 'vault operator unseal $UNSEAL_TOKEN'
kubectl -n vault exec vault-2 -- sh -c 'vault operator unseal $UNSEAL_TOKEN'

```
- Включить и настроить kv секретов otus.
```shell
kubectl -n vault exec vault-0 -- sh -c "vault login $ROOT_TOKEN"
kubectl -n vault exec vault-0 -- sh -c "vault secrets enable -path=otus/ -version=1 kv"
kubectl -n vault exec vault-0 -- sh -c "vault kv put otus/cred username='otus' password='asajkjkahs'"
```
- Включить и настроить аутентификацию kubernetes.
```shell
vault auth enable kubernetes

kubectl -n vault exec vault-0 -- vault login $ROOT_TOKEN
kubectl -n vault exec vault-0 -- sh -c 'vault write auth/kubernetes/config \
token_reviewer_jwt="$TOKEN" \
kubernetes_host=https://${KUBERNETES_PORT_443_TCP_ADDR}:${KUBERNETES_PORT_443_TCP_PORT} \
kubernetes_ca_cert=@/var/run/secrets/kubernetes.io/serviceaccount/ca.crt'
```
- Создание политики.

```shell
POLICY=$(cat otus-policy.hcl)
kubectl -n vault exec vault-0 -- sh -c "echo '$POLICY' > ~/otus-policy.hcl"
kubectl -n vault exec vault-0 -- sh -c "vault policy write otus-policy ~/otus-policy.hcl"
```
- Создание роли.

```shell
kubectl -n vault exec vault-0 -- vault write auth/kubernetes/role/otus \
bound_service_account_names=vault-auth \
bound_service_account_namespaces=vault \
policies=otus-policy \
ttl=1h
```
- Установить SecretStore и ExternalSecret.
```shell
kubectl apply -f secret-store.yaml -f external-secret.yaml
```

## Как проверить работоспособность:

- Проверить и наличие секрета `vault-otus-secret`
```shell
❯ kubectl -n vault get secrets vault-otus-secret
NAME                TYPE     DATA   AGE
vault-otus-secret   Opaque   2      53m
```
- Получить секреты
```shell
❯ kubectl -n vault get secret vault-otus-secret -o jsonpath='{.data.username}' | base64 --decode
otus%
❯ kubectl -n vault get secret vault-otus-secret -o jsonpath='{.data.password}' | base64 --decode
asajkjkahs%
```
## PR checklist:

- [x] Выставлен label с темой домашнего задания
