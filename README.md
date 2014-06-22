ansible-marathon
=============

Marathon Playbook for Ansible with HAProxy support.

This playbook will install Marathon and relies on the Mesos playbook. For HAProxy support, HAProxy must be present.

Support open source!

## How to use this playbook?

Marathon is installed with HA mode activated [(see command line options)](https://github.com/mesosphere/marathon#command-line-options). By default this playbook will look for hosts in the ```mesos_masters``` group to configure the required zookeeper support.

A cron job is configured to run the haproxy_dns_cfg script which will query the marathon api for applications and setup the appropriate frontend (listening on port 80) with backends for each application. HAProxy will look for a hostname prefixed with the application name and route to that backend. Using this technique you can wildcard a dns host to all your masters (say, *.example.com) and an application you launch (say, "myapp") will be available at myapp.example.com.

### Samples
See this sample [playbook](https://github.com/AnsibleShipyard/ansible-galaxy-roles/blob/master/playbook.yml)
which shows how to use this playbook as well as others. It is part of [ansible-galaxy-roles](https://github.com/AnsibleShipyard/ansible-galaxy-roles) and
serves as a curation (and thus an example) of all our ansible playbooks.

You can also view another [sample playbook](https://github.com/mhamrah/ansible-mesos-playbook) which leverages this role to build a mesos cluster with separate master and slave nodes.

## Our Other Mesos related playbooks

1. [ansible-mesos](https://github.com/AnsibleShipyard/ansible-mesos)
1. [ansible-marathon](https://github.com/AnsibleShipyard/ansible-marathon)
1. [ansible-chronos](https://github.com/AnsibleShipyard/ansible-chronos)
1. [ansible-mesos-docker](https://github.com/AnsibleShipyard/ansible-mesos-docker)
