# docker-dd-agent-build-deb-i386
This repo contains the Dockerfile used to build the Datadog Agent (https://github.com/DataDog/dd-agent).

The Datadog Agent is built using a Chef omnibus project (https://github.com/DataDog/dd-agent-omnibus) on CircleCi.

The base image of the container is a homemade i386 image of Debian Squeeze.

To build this base image on a Debian based OS:

```bash
sudo apt-get install debootstrap

wget https://raw.githubusercontent.com/docker/docker/master/contrib/mkimage-debootstrap.sh 
chmod +x mkimage-debootstrap.sh
./mkimage-debootstrap.sh -a i386 -t squeeze-386.tar.xz squeeze http://http.debian.net/debian

docker build -t datadog/debian-i386:squeeze -f Dockerfile-debian-i386 .
docker push datadog/debian-i386:squeeze
```
