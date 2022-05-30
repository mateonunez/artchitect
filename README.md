# Architect

## Running on Minikube

> I've created only the *Components* of the Archifront (frontend) project.

I decided to run my archiproject on the most basic of clusters: **minikube**.

The first step is to install **minikube**, you can follow the official documentation [here](https://minikube.sigs.k8s.io/docs/start/)

> *Kubectl* will be automatically installed.

The first step is to properly set your `configmaps`.

```bash
> cd ~/architect/k8s/nginx/archifront
> kubectl apply -f nginx-archifront-configmap.yaml
configmap/nginx-archifront-configmap created
```

> These maps were created to properly set the IP addresses of the nodes I am going to create. The first is in the frontend for the HomePage the other is for the authentication frontend.

```bash
> kubectl get configmaps
NAME                         DATA   AGE
kube-root-ca.crt             1      31h
nginx-archifront-configmap   2      2m6s
```

Now I can create my deployments and my frontend services.

```bash
> cd ~/architect/k8s/frontend/archifront/homepage
> kubectl apply -f archifront-homepage.yaml
deployment.apps/archifront-homepage created
service/archifront-homepage-service created

> cd ~/architect/k8s/frontend/archifront/authentication
> kubectl apply -f archifront-authentication.yaml 
deployment.apps/archifront-authentication created
service/archifront-authentication-service created
```

Ok now I created my deployments and my services.

This is the output of my k8s components:

```bash
> kubectl get all
NAME                                            READY   STATUS              RESTARTS   AGE
pod/archifront-authentication-7b7d47d69-k9qjw   0/1     ContainerCreating   0          40s
pod/archifront-homepage-5bf88459cf-k5x6t        0/1     ContainerCreating   0          65s

NAME                                        TYPE        CLUSTER-IP      EXTERNAL-IP   PORT(S)    AGE
service/archifront-authentication-service   ClusterIP   10.98.113.56    <none>        3010/TCP   40s
service/archifront-homepage-service         ClusterIP   10.111.35.164   <none>        3030/TCP   65s
service/kubernetes                          ClusterIP   10.96.0.1       <none>        443/TCP    31h

NAME                                        READY   UP-TO-DATE   AVAILABLE   AGE
deployment.apps/archifront-authentication   0/1     1            0           40s
deployment.apps/archifront-homepage         0/1     1            0           65s

NAME                                                  DESIRED   CURRENT   READY   AGE
replicaset.apps/archifront-authentication-7b7d47d69   1         1         0       40s
replicaset.apps/archifront-homepage-5bf88459cf        1         1         0       65s
```

Now I'm gonna create my **nginx** and the service will be expose to an extenal IP.

```bash
> cd ~/architect/k8s/nginx/archifront
> kubectl apply -f nginx-archifront.yaml 
deployment.apps/nginx-archifront created
service/nginx-archifront created
```

And check if your Pod is running.

```bash
> kubectl get pod
NAME                                        READY   STATUS    RESTARTS   AGE
archifront-authentication-7b7d47d69-k9qjw   1/1     Running   0          3m16s
archifront-homepage-5bf88459cf-k5x6t        1/1     Running   0          3m41s
nginx-archifront-f4968c8b7-vm4qm            1/1     Running   0          57s
```

The nginx is serving correctly, now I'll check my services.

```bash
$ kubectl get svc
NAME                                TYPE           CLUSTER-IP      EXTERNAL-IP   PORT(S)        AGE
archifront-authentication-service   ClusterIP      10.98.113.56    <none>        3010/TCP       4m16s
archifront-homepage-service         ClusterIP      10.111.35.164   <none>        3030/TCP       4m41s
kubernetes                          ClusterIP      10.96.0.1       <none>        443/TCP        31h
nginx-archifront                    LoadBalancer   10.106.60.62    <pending>     80:30000/TCP   117s
```

As you can see my `nginx-archifront` service is a LoadBalancer, I should assign it an external ip. To do that I'm gonna use `minikube tunnel`.

```bash
> minikube tunnel
```

And checking the services again...

```bash
$ kubectl get svc
NAME                                TYPE           CLUSTER-IP      EXTERNAL-IP   PORT(S)        AGE
...
nginx-archifront                    LoadBalancer   10.106.60.62    127.0.0.1     80:30000/TCP   3m26s
```

An external ip was assigned to my service.

Now just visit the following link: 

> http://127.0.0.1


____________________________________


## Backend PHP Laravel

### Installation

Set your environment variables

```bash
DB_CONNECTION=mysql
DB_HOST=architect_database
DB_PORT=3306
DB_DATABASE=architect
DB_USERNAME=root
DB_PASSWORD=root
```

Then run the `docker-compose` commands

```bash
docker-compose build && docker-compose up -d
```

After the installation you must run the following commands:

```bash
docker-compose exec architect_backend_php_laravel composer install
docker-compose exec architect_backend_php_laravel php artisan prepare:env
```

### Testing

Set your environment variables

```env
DB_CONNECTION=mysql
DB_HOST=architect_database
DB_PORT=3306
DB_DATABASE=architect_test
DB_USERNAME=root
DB_PASSWORD=root
```

Then run the `docker-compose` commands

```bash
docker-compose exec architect_backend_php_laravel php artisan migrate:fresh --seed --env=testing
docker-compose exec architect_backend_php_laravel php artisan passport:install --env=testing
docker-compose exec architect_backend_php_laravel php artisan test 
```

## Backend Javascript Watchful

Watchful is a simple program that checks and handles the queue.

### Set up

Set your environment variables

```bash
RABBITMQ_HOST=architect_rabbitmq
RABBITMQ_PORT=5672
RABBITMQ_USER=architect
RABBITMQ_PASS=architect
```

Then run the `docker-compose` commands

```bash
docker-compose build && docker-compose up -d
```

After the installation you must run the following commands:

```bash
docker-compose exec architect_backend_javascript_watchful npm install
```

## Backend Javascript Balancer

This simple backend is used just for activate a balancing strategy

### Set up

Set your environment variables

```bash
BALANCER_HOST=architect_backend_javascript_balancer
BALANCER_PORT=5010
```

Then run the `docker-compose` commands

```bash
docker-compose build && docker-compose up -d
```

After the installation you must run the following commands:

```bash
docker-compose exec architect_backend_javascript_balancer npm install
```

## Backend Rust Balancer

This simple backend is used just for activate a balancing strategy

Run the `docker-compose` commands

```bash
docker-compose build && docker-compose up -d
```

## Frontend Next.js Homepage

This simple frontend allows you consume the Auth APIs

Run the `docker-compose` commands

```bash
docker-compose build && docker-compose up -d
```

After the installation you must run the following commands:

```bash
docker-compose exec architect_frontend_archifront_homepage npm install
```

## Frontend Next.js Authentication

This simple frontend allows you consume the Auth APIs

Run the `docker-compose` commands

```bash
docker-compose build && docker-compose up -d
```

After the installation you must run the following commands:

```bash
docker-compose exec architect_frontend_archifront_authentication npm install
```
