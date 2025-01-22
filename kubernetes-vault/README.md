# Установить crd `external-secrets`
```shell
cd kubernetes-vault
kubectl apply -f https://raw.githubusercontent.com/external-secrets/external-secrets/v0.13.0/deploy/crds/bundle.yaml
helmfile sync
```

ROOT_TOKEN=root key
kubectl -n vault exec vault-0 -- sh -c "vault operator init -key-shares=1 -key-threshold=1"
kubectl -n vault exec vault-0 -- sh -c "vault operator unseal $ROOT_TOKEN"
kubectl -n vault exec vault-0 -- sh -c "vault login $ROOT_TOKEN"
kubectl -n vault exec vault-0 -- sh -c "vault secrets enable -path=otus/ -version=1 kv"
kubectl -n vault exec vault-0 -- sh -c "vault kv put otus/cred username='otus' password='asajkjkahs'"
kubectl apply -f rbac.yaml

vault auth enable kubernetes

TOKEN=$(kubectl create token vault-auth --duration 525600m)
kubectl -n vault exec vault-0 -- vault login $ROOT_TOKEN
kubectl -n vault exec vault-0 -- sh -c 'echo token_reviewer_jwt="$TOKEN"'
kubectl -n vault exec vault-0 -- sh -c 'vault write auth/kubernetes/config \
token_reviewer_jwt="$TOKEN" \
kubernetes_host=https://${KUBERNETES_PORT_443_TCP_ADDR}:${KUBERNETES_PORT_443_TCP_PORT} \
kubernetes_ca_cert=@/var/run/secrets/kubernetes.io/serviceaccount/ca.crt'
- Cоздание политики
```shell
POLICY=$(cat otus-policy.hcl)
kubectl -n vault exec vault-0 -- sh -c "echo '$POLICY' > ~/otus-policy.hcl"
kubectl -n vault exec vault-0 -- sh -c "vault policy write otus-policy ~/otus-policy.hcl"
```
 - Cоздание роли
```shell
kubectl -n vault exec vault-0 -- vault write auth/kubernetes/role/otus \
bound_service_account_names=vault-auth \
bound_service_account_namespaces=vault \
policies=otus-policy \
ttl=1h
```
