# docker-dd-agent-build-deb-i386

To build the i386 docker image (on an ubuntu node)

```
sudo apt-get install debootstrap
wget https://raw.githubusercontent.com/docker/docker/master/contrib/mkimage-debootstrap.sh
chmod +x mkimage-debootstrap.sh
./mkimage-debootstrap.sh -a i386 -t squeeze-386.tar.xz squeeze http://http.debian.net/debian
docker build -t datadog/debian-i386:squeeze -f Dockerfile-debian-i386 .
docker push datadog/debian-i386:squeeze
```
