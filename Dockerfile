FROM datadog/debian-i386:squeeze
MAINTAINER Remi Hakim @remh
RUN rm /bin/sh && ln -s /bin/bash /bin/sh

RUN apt-get update && linux32 apt-get install -y \
    git \
    curl \
    procps \
    gcc-multilib

RUN gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3
RUN \curl -sSL https://get.rvm.io | linux32 bash -s stable
RUN /bin/bash -l -c "rvm requirements"
RUN /bin/bash -l -c "rvm install 2.2.2"
RUN /bin/bash -l -c "gem install bundler --no-ri --no-rdoc"

RUN curl -o /tmp/go1.3.3.linux-386.tar.gz https://storage.googleapis.com/golang/go1.3.3.linux-386.tar.gz && \
    tar -C /usr/local -xzf /tmp/go1.3.3.linux-386.tar.gz && \
    echo "PATH=$PATH:/usr/local/go/bin" | tee /etc/profile.d/go.sh

RUN git config --global user.email "package@datadoghq.com"
RUN git config --global user.name "Debian Omnibus Package"
RUN git clone https://github.com/DataDog/dd-agent-omnibus.git
RUN cd dd-agent-omnibus && \
    linux32 /bin/bash -l -c "bundle install --binstubs"

VOLUME ["/dd-agent-omnibus/pkg"]
ENTRYPOINT linux32 /bin/bash -l /dd-agent-omnibus/omnibus_build.sh