# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  config.ssh.forward_agent = true
  config.vm.synced_folder Dir.getwd, "/home/vagrant/roles/ansible-marathon", nfs: true

  # give Virtualbox more mem for Java to build
  config.vm.provider :virtualbox do |vb|
    vb.customize ["modifyvm", :id, "--memory", "2048"]
  end

  config.vm.define 'ubuntu', primary: true do |c|
    c.vm.network "private_network", ip: "192.168.100.2"
    c.vm.box = "mesos-0.20.0_ubuntu-14.04_amd64_virtualbox_0.20.0.3"
    c.vm.box_url = "https://s3-us-west-1.amazonaws.com/everpeace-vagrant-mesos/mesos-0.20.0_ubuntu-14.04_amd64_virtualbox_0.20.0.3.box"

    c.vm.provision "shell" do |s|
      s.inline = "apt-get update -y; apt-get install python-dev python-pip -y; pip install -U ansible; service mesos-master restart"
      s.privileged = true
    end

    c.vm.provision "ansible" do |ansible|
      ansible.playbook = "tests/playbook.yml"
    end

  end

  # centos:
  config.vm.define 'centos' do |c|
    c.vm.network "private_network", ip: "192.168.100.3"
    c.vm.box = "centos65-x86_64-20140116"
    c.vm.box_url = "https://github.com/2creatives/vagrant-centos/releases/download/v6.5.3/centos65-x86_64-20140116.box"

    c.vm.provision "shell" do |s|
      s.inline = "
      hostname localhost;
      iptables -F;
      service iptables save;
      rpm -Uvh http://archive.cloudera.com/cdh4/one-click-install/redhat/6/x86_64/cloudera-cdh-4-0.x86_64.rpm;
      yum -y install zookeeper;
      zookeeper-server-initialize --myid=1
      zookeeper-server start;
      rpm -Uvh http://repos.mesosphere.io/el/6/noarch/RPMS/mesosphere-el-repo-6-2.noarch.rpm;
      yum -y install mesos;
      #mesos-init-wrapper master &;
      "
      s.privileged = true
    end

    c.vm.provision "ansible" do |ansible|
      ansible.playbook = "tests/playbook.yml"
    end
  end

  # centos 7:
  config.vm.define 'centos7' do |c|
    c.vm.network "private_network", ip: "192.168.100.4"
    c.vm.box = "centos/7"
    c.vm.provision "shell" do |s|
      s.inline = "
      hostname localhost;
      iptables -F;
      service iptables save;
      rpm -Uvh http://archive.cloudera.com/cdh4/one-click-install/redhat/6/x86_64/cloudera-cdh-4-0.x86_64.rpm;
      yum -y install zookeeper;
      zookeeper-server-initialize --myid=1
      zookeeper-server start;
      rpm -Uvh http://repos.mesosphere.io/el/7/noarch/RPMS/mesosphere-el-repo-7-2.noarch.rpm;
      yum install -y epel-release;
      yum -y install mesos ansible;
      "
      s.privileged = true
    end
  end
  
end