# tmate server on Alpine Linux

This is an attempt to build a pairing server using `tmate` and Alpine linux. The other implementations I found used Ubuntu which ships containers upwards of 250MB+. 
```
➜  tmate-alpine-docker git:(master) ✗ docker images
REPOSITORY                                                 TAG                                        IMAGE ID            CREATED             SIZE
tmate-alpine-docker_tmate-server                           latest                                     a18ea818736e        33 minutes ago      266MB
```

This implementation takes advantage of [multi-stage builds](https://docs.docker.com/develop/develop-images/multistage-build/) and Alpines awesomeness to generate container images just under 60MB:

```
➜  tmate-alpine-docker git:(master) ✗ docker images
REPOSITORY                                                 TAG                                        IMAGE ID            CREATED             SIZE
tmate-alpine-docker_tmate-server                           latest                                     3dad8bbd94fd        6 minutes ago       59.1MB
```

## Running

### Mounting your keys

I didn't like how other implementations of tmate + docker cached the server keys into the docker container. This implementation will generate them when the container starts if they don't exist, and will use existing ones if it finds them. For this to work, you'll have to mount a volume into the container at `/etc/tmate-keys` so that your keys remain persistent through container restarts.

### Native docker

```
$ sudo docker run --privileged -v tmate-keys:/etc/tmate-keys -p 2222 atomenger/tmate-alpine
```

### Docker compose

### Kubernetes

TODO

### ECS Service

TODO

### Digital Ocean

TODO

## what's backtrace.patch ??

Yes, Alpine Linux is missing `backtrace` and a few other constants from `libbacktrace`. To get around this, we patch out the use of it in `tmate` using `backtrace.patch`.  See [this link](https://www.openwall.com/lists/musl/2015/04/09/3) for more information and please feel free to correct me if my understanding of this is off.


I thank [sigma](https://github.com/sigma/docker-tmate/blob/master/backtrace.patch) for this patch and all other prior implementations of tmate on docker that I relied on.
