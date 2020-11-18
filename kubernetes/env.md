# Managing environment variables
Using Kubernetes's envFrom and secretRef to provide the variables needed.

https://gist.github.com/troyharvey/4506472732157221e04c6b15e3b3f094

> When secrets are provided with this method the app itself has to be set up to read the variables from the environment so the container will auto detect what kubernetes is providing

# Encrypting secrets provided in env-secrets.yml for example for GHA
https://docs.github.com/en/free-pro-team@latest/actions/reference/encrypted-secrets





# Extras
- dj-database-url
- https://github.com/kintohub/patroni
- manage.py migrate can easily get confused if you run two copies of it in parallel
- Migrate app at runtime in Dockerfile as long as you only run one replica of your app 
