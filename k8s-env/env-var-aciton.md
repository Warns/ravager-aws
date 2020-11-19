# Using environment variables within Kubernetes cluster

## Managing env vars for GitHub Actions
Include the following in the workflow just before invoking Kubernetes deployment.yml

```
- name: Create k8s secret to use env    
  uses: azure/k8s-create-secret@v1
  with:
    namespace: default
    secret-type: generic
    arguments:
      --from-literal=SECRET_KEY=${{ secrets.DJANGO_SECRET_KEY }}
      --from-literal=ALLOWED_HOSTS=${{ secrets.DJANGO_ALLOWED_HOSTS }}
      --from-literal=DATABASE_HOST=${{ secrets.POSTGRES_DATABASE_HOST }}
      --from-literal=DATABASE_USER=${{ secrets.POSTGRES_DATABASE_USER }}
      --from-literal=DATABASE_NAME=${{ secrets.POSTGRES_DATABASE_NAME }}
      --from-literal=DATABASE_PASSWORD=${{ secrets.POSTGRES_DATABASE_PASSWORD }}
      --from-literal=LOG_LEVEL=${{ secrets.DJANGO_LOG_LEVEL }}
      --from-literal=DEBUG=${{ secrets.DJANGO_DEBUG }}
    secret-name: env-secrets
```

Add the corresponding `secrets.ENVIRONMENT_VARIABLE` in GitHub Secrets.
This will provide the corresponding environment variables in the Pod
 in k8s cluster, the application therefore must be adjusted to read from environment variables.

> Make sure to use a clean SECRET_KEY as it seems YAML is having interesting time resolving the secret (Characters such as --)__ is causing error flags) a clean HEX secret should work fine.

## Managing env vars as k8s secret file
Reference: https://gist.github.com/troyharvey/4506472732157221e04c6b15e3b3f094

`deployment.yml`
```
# Use envFrom to load Secrets and ConfigMaps into environment variables

apiVersion: apps/v1beta2
kind: Deployment
metadata:
  name: mans-not-hot
  labels:
    app: mans-not-hot
spec:
  replicas: 1
  selector:
    matchLabels:
      app: mans-not-hot
  template:
    metadata:
      labels:
        app: mans-not-hot
    spec:
      containers:
        - name: app
          image: gcr.io/mans-not-hot/app:bed1f9d4
          imagePullPolicy: Always
          ports:
            - containerPort: 80
          envFrom:
          - configMapRef:
              name: env-configmap
          - secretRef:
              name: env-secrets
```

`env-configmap.yml`
```
# Use config map for not-secret configuration data

apiVersion: v1
kind: ConfigMap
metadata:
  name: env-configmap
data:
  APP_NAME: Mans Not Hot
  APP_ENV: production
```

`env-secrets.yml`

```
# Use secrets for things which are actually secret like API keys, credentials, etc
# Base64 encode the values stored in a Kubernetes Secret: $ pbpaste | base64 | pbcopy
# The --decode flag is convenient: $ pbpaste | base64 --decode

apiVersion: v1
kind: Secret
metadata:
  name: env-secrets
type: Opaque
data:
  DB_PASSWORD: cDZbUGVXeU5e0ZW
  REDIS_PASSWORD: AAZbUGVXeU5e0ZB
```

## Side note
migration has to be done carefully and controlling the order and concurrency. `manage.py migrate` can easily get confused if you run two copies of it in parallel. So migrating while building the image using Dockerfile should only be used as long as runing one replica of the app.

Therefore for more instances of the same app there are some different options one is to use a migration operator such as https://github.com/coderanger/migrations-operator
