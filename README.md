ansible-marathon
=================

[![Build Status](https://travis-ci.org/AnsibleShipyard/ansible-marathon.svg?branch=master)](https://travis-ci.org/AnsibleShipyard/ansible-marathon)
[![Gitter](https://badges.gitter.im/gitterHQ/gitter.svg)](https://gitter.im/AnsibleShipyard/devs)

Apache Marathon playbook with optional HAProxy configuration support.

Note that current Ansible Marathon version requires Java8 you can find how to install it below.

Installation
-----------

```bash
ansible-galaxy install JasonGiedymin.marathon
```

Requirements
------------

 - Java 8
 - Apache Zookeeper
 - Apache Mesos

Role Variables
--------------

```yaml
---
marathon_version: "1.3.6"

# Debian: Mesosphere apt repository URL
marathon_apt_package: "marathon={{ marathon_version }}-*"
marathon_apt_repo: "deb http://repos.mesosphere.com/{{ansible_distribution|lower}} {{ansible_distribution_release|lower}} main"
# Debian apt pin priority for the marathon package. If empty (the default), no pin priority is used.
marathon_apt_pin_priority:

# RedHat: Mesosphere yum repository URL
marathon_yum_package: "marathon-{{ marathon_version }}"
mesosphere_yum_repo: "http://repos.mesosphere.com/el/{{ os_version_major }}/noarch/RPMS/{{ mesosphere_releases[os_version_major] }}"

marathon_hostname: "{{ inventory_hostname }}"
marathon_port: 8080
marathon_env_java_opts: '-Xmx512m'
marathon_env_vars:
  - "JAVA_OPTS={{ marathon_env_java_opts }}"

# command line flags:
# https://mesosphere.github.io/marathon/docs/command-line-flags.html
# Marathon reads files under /etc/marathon/conf and adds them to CLI
# The path to Zookeeper which Marathon can use to find the Mesos masters and use as a state store.
zookeeper_hostnames: "localhost:2181"

# The path to Mesos in the Zookeeper cluster
mesos_zookeeper_path: "/mesos"

# The path to Marathon in the Zookeeper cluster
marathon_zookeeper_path: "/marathon"
mesos_zookeeper_masters: "zk://{{ zookeeper_hostnames }}{{ mesos_zookeeper_path }}"
marathon_zookeeper_state: "zk://{{ zookeeper_hostnames }}{{ marathon_zookeeper_path }}"

# The path to install the haproxy configuration script. If this is an empty string ```""``` haproxy configuration will be disabled.
haproxy_script_location: "/usr/local/bin"

# **Mesos** SSL support
mesos_ssl_enabled: false # When mesos has SSL enabled, set to true and fill in other `mesos_ssl_` variables.
mesos_ssl_support_downgrade: false
mesos_ssl_key_file: # When mesos SSL is enabled this must be used to point to the SSL key file
mesos_ssl_cert_file: # When mesos SSL is enabled this must be used to point to the SSL certificate file

# optional
artifact_store: ""
checkpoint: "true"
marathon_mesos_role: ""

marathon_additional_configs: []
#    For example:
#    - name: task_lost_expunge_interval
#      value: 900000
```

Dependencies
------------

 - https://github.com/geerlingguy/ansible-role-java
 - https://github.com/AnsibleShipyard/ansible-zookeeper
 - https://github.com/AnsibleShipyard/ansible-mesos
 - HAProxy installed for HAProxy support

Example Playbook
----------------

```yaml
- hosts: all
  tasks:
    - name: Installing repo for Java 8 for Debian
      apt_repository: repo='ppa:openjdk-r/ppa'
      when:
        - ansible_os_family == 'Debian'
        - ansible_distribution_version|version_compare(16.04, '<')

- name: Install dependencies
  hosts: all
  roles:
    - role: geerlingguy.java
      java_packages:
        - openjdk-8-jdk
      when: ansible_os_family == 'Debian'

    - role: geerlingguy.java
      java_packages:
        - java-1.8.0-openjdk
      when: ansible_os_family == 'RedHat'

    - role: AnsibleShipyard.ansible-zookeeper
    - role: JasonGiedymin.mesos
      mesos_install_mode: master-slave

    - role: JasonGiedymin.marathon
```

HAProxy Support
----------------

A cron job is configured to run the haproxy_dns_cfg script which will query
the marathon api for applications and setup the appropriate frontend (listening on port 80)
with backends for each application.
HAProxy will look for a hostname prefixed with the application name and route to that backend.
Using this technique you can wildcard a dns host to all your masters
(say, *.example.com) and an application you launch (say, "myapp") will be
available at myapp.example.com. This can be disabled by setting the haproxy_script_location
to an emptry string ```""```. It will only be installed if HAProxy is present.

License
-------

Apache License Version 2.0, January 2004

AnsibleShipyard
-------

Our related playbooks

1. [ansible-mesos](https://github.com/AnsibleShipyard/ansible-mesos)
1. [ansible-chronos](https://github.com/AnsibleShipyard/ansible-chronos)
1. [ansible-zookeeper](https://github.com/AnsibleShipyard/ansible-zookeeper)

Author Information
------------------

@AnsibleShipyard/developers and others.
