FROM mhamrah/ansible-ubuntu
MAINTAINER Michael Hamrah <m@hamrah.com>

ENV WORKDIR /tmp/build/ansible-marathon

ADD files $WORKDIR/files
ADD handlers $WORKDIR/handlers
ADD meta $WORKDIR/meta
ADD tasks $WORKDIR/tasks
ADD templates $WORKDIR/templates
ADD tests $WORKDIR/tests
ADD vars $WORKDIR/vars

ADD tests/inventory /etc/ansible/hosts
ADD tests/playbook.yml $WORKDIR/playbook.yml

RUN ansible-playbook $WORKDIR/playbook.yml -c local
