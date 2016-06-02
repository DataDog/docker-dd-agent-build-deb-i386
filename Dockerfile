FROM datadog/debian-i386:squeeze
MAINTAINER Remi Hakim @remh
RUN rm /bin/sh && ln -s /bin/bash /bin/sh

RUN cat /etc/apt/sources.list | grep -v "squeeze-updates" | sed "s#http\.debian\.net#archive.debian.org#" > /etc/apt/sources.new.list && mv /etc/apt/sources.new.list /etc/apt/sources.list && echo "Acquire::Check-Valid-Until false;" > /etc/apt/apt.conf
# FIXME
RUN echo "130.89.148.13 archive.debian.org" >> /etc/hosts && echo "195.20.242.89 security.debian.org" >> /etc/hosts
RUN apt-get update && linux32 apt-get install -y \
    curl \
    procps \
    gcc-multilib \
    fakeroot

RUN echo "deb http://archive.debian.org/debian-backports squeeze-backports main" >/etc/apt/sources.list.d/squeeze-backports.list
RUN apt-get update -q && apt-get -t squeeze-backports install -y -q \
    git

RUN gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3
RUN curl -sSL https://get.rvm.io | linux32 bash -s stable

RUN sed -i "s/libgmp-dev//g" /usr/local/rvm/scripts/functions/requirements/debian

RUN /bin/bash -l -c "rvm requirements && rvm install 2.2.2 && gem install bundler --no-ri --no-rdoc" && \
    rm -rf /usr/local/rvm/src/ruby-2.2.2

RUN curl -o /tmp/go1.3.3.linux-386.tar.gz https://storage.googleapis.com/golang/go1.3.3.linux-386.tar.gz && \
    tar -C /usr/local -xzf /tmp/go1.3.3.linux-386.tar.gz && \
    rm -f /tmp/go1.3.3.linux-386.tar.gz && \
    echo "PATH=$PATH:/usr/local/go/bin" | tee /etc/profile.d/go.sh

RUN git config --global user.email "package@datadoghq.com" && \
    git config --global user.name "Debian Omnibus Package" && \
    git clone https://github.com/DataDog/dd-agent-omnibus.git

RUN git clone https://github.com/DataDog/integrations-extras.git
RUN git clone https://github.com/DataDog/integrations-core.git

# TODO: remove the checkout line after the merge to master
RUN cd dd-agent-omnibus && \
    linux32 /bin/bash -l -c "OMNIBUS_RUBY_BRANCH='datadog-5.0.0' bundle install --binstubs"

RUN /bin/bash -l -c "echo 'deb http://apt.datadoghq.com/ stable main' > /etc/apt/sources.list.d/datadog.list"
RUN linux32 apt-key adv --recv-keys --keyserver hkp://keyserver.ubuntu.com:80 C7A7DA52
RUN linux32 apt-get update

VOLUME ["/dd-agent-omnibus/pkg"]
ENTRYPOINT linux32 /bin/bash -l /dd-agent-omnibus/omnibus_build.sh
