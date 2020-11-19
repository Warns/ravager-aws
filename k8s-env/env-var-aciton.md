# Using environment variables within Kubernetes cluster

## Managing env vars for GitHub Actions
Include the following in the workflow just before invoking Kubernetes deployment.yml

For this you must you https://github.com/Azure/k8s-create-secret#for-generic-secret to give the ability to Kubernetes YAML file read GitHub Actions secrets object.

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

So instead of putting the secret in a YAML file (such as `env-secrets.yml`) and applying it, you are making it imperatively via the action

>

> Make sure to use a clean SECRET_KEY as it seems YAML is having interesting time resolving the secret (Characters such as --)__ is causing error flags) a clean HEX secret should work fine.

> YAML sees True as a boolean value but secrets can only have strings so make sure to use it such as `DEBUG: "True"` Because YAML has some specific values that it knows, such as True and true then it checks of the value looks like a number, if it doesn't, it makes it a string. Like `LOG_DEBUG: DEBUG` it knows that key is a string. Fun fact, `on` and `off` also parse as booleans in YAML, Because someone thought that was a good idea 15 years ago and now we're stuck with it :D

## Managing env vars as k8s secret file
Reference: https://gist.github.com/troyharvey/4506472732157221e04c6b15e3b3f094

`deployment.yml`
```
apiVersion: apps/v1
kind: Deployment
metadata:
  name: identity-api
spec:
  replicas: 1
  selector:
    matchLabels:
      app: identity-api
  template:
    metadata:
      labels:
        app: identity-api
    spec:
      nodeSelector:
        "beta.kubernetes.io/os": linux
      containers:
      - name: identity-api
        image: imagename.azurecr.io/identityservice:${{ github.sha }}
        env:
          - name: SECRET_KEY
            valueFrom:
              secretKeyRef:
                name: secret-key
                key: SECRET_KEY
          - name: ALLOWED_HOSTS
            valueFrom:
              secretKeyRef:
                name: allowed-hosts
                key: ALLOWED_HOSTS
          - name: DATABASE_HOST
            valueFrom:
              secretKeyRef:
                name: database-host
                key: DATABASE_HOST
          - name: DATABASE_USER
            valueFrom:
              secretKeyRef:
                name: database-user
                key: DATABASE_USER
          - name: DATABASE_NAME
            valueFrom:
              secretKeyRef:
                name: database-name
                key: DATABASE_NAME
```

`env-secrets.yml`
```
# Use secrets for things which are actually secret like API keys, credentials, etc
# # Base64 encode the values stored in a Kubernetes Secret: $ pbpaste | base64 | pbcopy
# # The --decode flag is convenient: $ pbpaste | base64 --decode

apiVersion: v1
kind: Secret
metadata:
  name: env-secrets
type: Opaque
# Changed to stringData to be able to include string values or else has to be base64 encoded. Do later for prod.
stringData: # use stringData instead of data when you're not encoding with base64 or else it won't work
  SECRET_KEY: ${{ secrets.DJANGO_SECRET_KEY }}
  ALLOWED_HOSTS: ${{ secrets.DJANGO_ALLOWED_HOSTS }}
  DJANGO_LOG_LEVEL: DEBUG
  DJANGO_DEBUG: "True"
  DATABASE_HOST: ${{ secrets.POSTGRES_DATABASE_HOST }}
  DATABASE_USER: ${{ secrets.POSTGRES_DATABASE_USER }}
  DATABASE_NAME: ${{ secrets.POSTGRES_DATABASE_NAME }}
```

## Side note
migration has to be done carefully and controlling the order and concurrency. `manage.py migrate` can easily get confused if you run two copies of it in parallel. So migrating while building the image using Dockerfile should only be used as long as runing one replica of the app.

Therefore for more instances of the same app there are some different options one is to use a migration operator such as https://github.com/coderanger/migrations-operator
