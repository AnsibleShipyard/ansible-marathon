ansible-marathon
=============
[![Build Status](https://travis-ci.org/AnsibleShipyard/ansible-marathon.svg?branch=master)](https://travis-ci.org/AnsibleShipyard/ansible-marathon)

Marathon role for Ansible with optional HAProxy configuration support. Marathon is installed with HA mode activated [(see command line options)](https://github.com/mesosphere/marathon#command-line-options).

## Requirements

* Ansible-Java, or Java installed on the host machine
* HAProxy installed for HAProxy support. 

## Role Variables

See ```defaults/main.yml``` for a full list. The most important settings are:

* ```zookeeper_hostnames: "localhost:2181"``` The path to Zookeeper which Marathon can use to find the Mesos masters and use as a state store.
* ```mesos_zookeeper_path: "/mesos"``` The path to Mesos in the Zookeeper cluster
* ```marathon_zookeeper_path: "/marathon"``` The path to Marathon in the Zookeeper cluster 
* ```haproxy_script_location: "/usr/local/bin"``` The path to install the haproxy configuration script. If this is an empty string ```""``` haproxy configuration will be disabled.

## HAProxy Support

A cron job is configured to run the haproxy_dns_cfg script which will query the marathon api for applications and setup the appropriate frontend (listening on port 80) with backends for each application. HAProxy will look for a hostname prefixed with the application name and route to that backend. Using this technique you can wildcard a dns host to all your masters (say, *.example.com) and an application you launch (say, "myapp") will be available at myapp.example.com.

This can be disabled by setting the haproxy_script_location to an emptry string ```""```. It will only be installed if HAProxy is present.
