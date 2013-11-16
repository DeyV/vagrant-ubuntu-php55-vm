# Vagrant PHP Dev environment

## Introduction

This vagrant/puppet build installs the following:
- PHP 5.5 (dev, cli, pear)
- Nginx
- PHP-FPM
- MySQL 5.5.X
- ElasticSearch
- MongoDB
- Composer
- PhpUnit

The following PHP extensions are installed:
- curl
- intl
- ldap
- mcrypt
- mysql
- xdebug

The following PECL extensions are installed:
- mongo
- xhprof
- apcu

## Installation

The following instructions are specific to OSX.

### Requirements

- OSX 10.9
- Packer
- Vagrant

### Install Packer

Download and install Packer (0.3.11+): http://www.packer.io/downloads.html

### Install Vagrant

Download and install Vagrant (1.3.5+): http://downloads.vagrantup.com

### Create Vagrant box

```sh
$ git clone https://github.com/mikekamornikov/packer-ubuntu13.10-vagrant
$ cd packer-ubuntu13.10-vagrant
$ packer build template.json
# finally "packer_virtualbox_virtualbox.box" will be created
```

### Add new box to vagrant box list

```sh
$ vagrant box add saucy64 packer_virtualbox_virtualbox.box
```

### Clone the git repository

Clone the repository in your prefered location, initialize submodules, and update:

```sh
$ git clone https://github.com/mikekamornikov/vagrant-ubuntu-php55-vm --recursive
```

*--recursive* is important, as you want to initialize and update the submodules included in this repo.

### Install "vagrant-vbguest" plugin

It installs (and updates) the host's VirtualBox Guest Additions on the guest system.

```sh
$ vagrant plugin install vagrant-vbguest
```

### Prepare networking

1. Open Virtualbox -> Network settings
2. Add Host-Only network with ip = `192.168.99.199` (**required for virtualbox 4.3+**)
3. Add `192.168.99.199 php.development.vm` to your `/etc/hosts` (**optional**)

### Prepare Vagranfile (optional)

1. Open Vagrantfile
2. Find `# config.vm.box_url = "path-to-packer-ubuntu-13.10-vagrant-box"`
3. Uncomment and change to your `packer_virtualbox_virtualbox.box` absolute path

### Vagrant up

From the root of the directory of the cloned project, vagrant up:

```sh
$ cd vagrant-ubuntu-php55-vm
$ vagrant up
```

**Note:** You may be prompted with your OSX password during the point where NFS is enabled. You must provide your password to proceed.

## Usage

If everything goes well you should see the result of `phpinfo()` call on `http://php.development.vm:8080/`

Execute `vagrant ssh` to start ssh session (the host IP is `192.168.99.199`).

The following ports have been exposed for the following services:
* Nginx: 80
* ElasticSearch: 9200
