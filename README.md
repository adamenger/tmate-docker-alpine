# tmate server on Alpine Linux

> Pairing is caring - Aldous Huxley

This repo is an attempt to build a pairing server using `tmate` and Alpine linux. My main goal is to increase the amount of pairing teams do amongst each other. My implementation takes advantage of [multi-stage builds](https://docs.docker.com/develop/develop-images/multistage-build/) and Alpines awesomeness to generate container images just under 60MB. The other implementations of Tmate and Docker use Ubuntu as a base layer which produces containers upwards of 250MB+. I've tried to collate the tmate + docker approaches here, and have added a few other scripts + examples to make deploying tmate (and pairing) easier.

## Running

### Mounting your keys

I didn't like how other implementations of tmate + docker cached the server keys into the docker container. This implementation will generate them when the container starts if they don't exist, and will use existing ones if it finds them. For this to work, you'll have to mount a volume into the container at `/etc/tmate-keys` so that your keys remain persistent through container restarts.

### Native docker

```
$ docker run --privileged -v tmate-keys:/etc/tmate-keys -e PORT=2222 -e HOST=127.0.0.1 -p 2222:2222 atomenger/tmate-docker:latest
```

### Docker compose

### Kubernetes

TODO

### ECS Service

TODO

### Digital Ocean

See [examples/digitalocean](examples/digitalocean)

## what's backtrace.patch ??

Yes, Alpine Linux is missing `backtrace` and a few other constants from `libbacktrace`. To get around this, we patch out the use of it in `tmate` using `backtrace.patch`.  See [this link](https://www.openwall.com/lists/musl/2015/04/09/3) for more information and please feel free to correct me if my understanding of this is off.


I thank [sigma](https://github.com/sigma/docker-tmate/blob/master/backtrace.patch) for this patch and all other prior implementations of tmate on docker that I relied on.
