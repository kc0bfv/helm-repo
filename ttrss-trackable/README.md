Helm chart for [Tiny Tiny RSS](https://tt-rss.org/) with HTTP Basic Auth in front of it.

# Secrets

Requires secrets objects `ttrss-database` and `ttrss-basic-auth`.  `ttrss-database` must have an `admin-pass` set to the desired admin password, and a `password` set to the desired database password (you never need to use the database password in practice, but it becomes the password for the postgres user `postgres`).  `ttrss-basic-auth` requires a `BASIC_AUTH_USER` and a `BASIC_AUTH_PASS` set to the username and password for HTTP Basic Auth.

Here's how you might create those secrets, if you're using sealed-secrets:

```
 export ADMIN_PASS=MakeSomethingNiceUpHere
 export DB_PASS=MakeSomethingNiceUpHere
 export BASIC_AUTH_USER=MakeSomethingNiceUpHere
 export BASIC_AUTH_PASS=MakeSomethingNiceUpHere

kubectl create secret generic ttrss-database -n ttrss --from-literal="admin-pass=${ADMIN_PASS}" --from-literal="password=${DB_PASS}" -o yaml --dry-run=client | kubeseal --format=yaml --cert=public_sealed_secret.pem > ttrss-database-sealed.yaml
kubectl create secret generic ttrss-basic-auth -n ttrss --from-literal=username="${BASIC_AUTH_USER}" --from-literal=password="${BASIC_AUTH_PASS}" --type="kubernetes.io/basic-auth" -o yaml --dry-run=client | kubeseal --format=yaml --cert=public_sealed_secret.pem > ttrss-basic-auth-sealed.yaml
```
