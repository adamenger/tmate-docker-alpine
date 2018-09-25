# tmate on Google Kubernetes Engine

This is a fully working deployment of tmate on top of kubernetes **in GKE**. To make this work, we needed a few GKE specific things:

* [Load balancer](https://cloud.google.com/kubernetes-engine/docs/tutorials/http-balancer)
* [Internal load balancing](https://cloud.google.com/kubernetes-engine/docs/how-to/internal-load-balancing) Use this link only if you want to do this inside of a vpc and not create a public load balancer
* [Persistent Volume Claim](https://cloud.google.com/kubernetes-engine/docs/concepts/persistent-volumes)

# 1. Create disk

```
kubectl create -f disk.yaml
```

# 2. Create deployment

```
kubectl create -f deployment.yaml
```

# 3. Create service

This will create the load balancers

```
kubectl create -f service.yaml
```

# 4. Update deployment with load balancer ip

Find and update `HOST` variable in the `deployment.yaml` with the public IP address from your load balancer. You can grab this easily by running `kubectl describe service tmate | grep Ingress`. This will ensure your connection strings have the proper address on the end: `ssh -p2222 dAoXDMSDxiq0zFpl6mxI1SNDg@35.239.184.75`.

Once you've updated the file, update the deployment in k8s:

```
kubectl apply -f deployment.yaml
```

# 5. Get the config

Run these commands and then grab all the lines that start with `set`. Plop these into your `~/.tmate.conf` and fire it up.

```
➜  kubectl get pods
NAME                     READY     STATUS    RESTARTS   AGE
tmate-5fdcdc885b-djl8j   1/1       Running   0          8m
➜ kubectl logs tmate-5fdcdc885b-djl8j
Add this to your /root/.tmate.conf file
set -g tmate-server-host 35.239.184.75
set -g tmate-server-port 2222
set -g tmate-server-rsa-fingerprint "de:3d:02:e2:2a:3a:f6:d4:85:19:82:db:17:86:86:cf"
set -g tmate-server-ecdsa-fingerprint "50:30:9b:4e:a7:2a:4c:57:bc:d9:db:34:e9:15:74:1d"
set -g tmate-identity ""
<5> (tmate) Accepting connections on :2222
```
