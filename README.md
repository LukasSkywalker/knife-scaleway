# Knife::DigitalOcean
## A knife plugin to deal with the [DigitalOcean.com](https://www.digitalocean.com) Cloud services.

[![Gem Version](https://badge.fury.io/rb/knife-digital_ocean.png)](http://badge.fury.io/rb/knife-digital_ocean)
[![Build Status](https://travis-ci.org/rmoriz/knife-digital_ocean.png)](https://travis-ci.org/rmoriz/knife-digital_ocean)
<a href="https://gemnasium.com/rmoriz/knife-digital_ocean"><img src="https://gemnasium.com/rmoriz/knife-digital_ocean.png"/></a>
<a href="https://codeclimate.com/github/rmoriz/knife-digital_ocean"><img src="https://codeclimate.com/github/rmoriz/knife-digital_ocean.png"/></a>
[![Coverage Status](https://coveralls.io/repos/rmoriz/knife-digital_ocean/badge.png?branch=master)](https://coveralls.io/r/rmoriz/knife-digital_ocean?branch=master)

This is a plugin for [Chef's](http://www.opscode.com/chef/) [knife](http://wiki.opscode.com/display/chef/Knife) tool. It allows you to bootstrap virtual machines with [DigitalOcean.com](https://www.digitalocean.com/) including the initial bootstrapping of chef on that system.
You can also use [knife-solo](http://matschaffer.github.com/knife-solo/) for chef bootstrapping or skip it altogether for another solution.

This knife plugin uses the [droplet_kit](https://github.com/digitalocean/droplet_kit) rubygem.

## Installation

```shell
➜ gem install knife-digital_ocean
```

## Overview

This plugin provides the following sub-commands:

* knife digital_ocean droplet create (options)
  **Creates a virtual machine with or without bootstrapping chef**

* knife digital_ocean droplet destroy (options)
  **Destroys the virtual machine and its data**

* knife digital_ocean droplet list (options)
  **Lists currently running virtual machines**

* knife digital_ocean image list (options)
  **Lists available images (snapshots, backups, OS-images)**

* knife digital_ocean region list (options)
  **Lists the server regions/locations/data-center**

* knife digital_ocean size list (options)
  **Lists the available server sizes**

* knife digital_ocean sshkey list
  **Lists name + id of the uploaded known ssh keys**


## Configuration

The best way is to put your API-credentials of DigitalOcean in your knife.rb file of choice (e.g. in ```~/.chef/knife.rb```):

```ruby
knife[:digital_ocean_access_token]   = 'YYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYY'
```

## Usage

### Create a Droplet

There are three different ways of creating a server/droplet instance:

If you just want to launch an instance
form the command line without any bootstrapping, go for option **C**.
If you use ```knife-solo``` try **B** and if you are a ```chef-server```-fan
use method **A**:
#### A. With bootstrapping in an chef-server environment:

__Examples__

```shell
➜ knife digital_ocean droplet create --server-name awesome-vm1.vm.io \
                                      --image debian-7-0-x64 \
                                      --location nyc3 \
                                      --size 1gb \
                                      --ssh-keys 1234,1235 \
                                      --ssh-port 22
```

```shell
➜ knife digital_ocean droplet create --server-name awesome-vm2.vm.io \
                                      --image debian-7.0-x64 \
                                      --location sfo1 \
                                      --size 512mb \
                                      --ssh-keys 1234,1235 \
                                      --bootstrap \
                                      --run-list "role[base],role[webserver]" \
                                      --secret-file "/home/user/.ssh/secret_file" \
                                      --ssh-port 22 \
                                      --identity-file "~/.ssh/id_rsa" \
                                      --private_networking
```

__Syntax__

```shell
➜ knife digital_ocean droplet create --server-name <FQDN> \
                                      --image <IMAGE SLUG> \
                                      --location <REGION SLUG> \
                                      --size <SIZE SLUG> \
                                      --ssh-keys <SSH KEY-ID(s), comma-separated> \
                                      --ssh-port <SSH PORT> \
                                      --bootstrap \
                                      --run-list "<RUNLIST>" \
                                      --secret-file "<FILENAME>" \
                                      --private_networking
```

__Short Syntax__

```shell
➜ knife digital_ocean droplet create -N <FQDN> \
                                      -I <IMAGE SLUG> \
                                      -L <REGION SLUG> \
                                      -S <SIZE SLUG> \
                                      -K <SSH KEY-ID(s), comma-separated> \
                                      -p <SSH PORT> \
                                      -B \
                                      -r "<RUNLIST>"
```

#### B. With knife-solo bootstrapping

You need to have [knife-solo](http://matschaffer.github.com/knife-solo/) gem installed.

This will create a droplet and run `knife solo bootstrap <IP>` equivalent for it.
Please consult the [knife-solo documentation](http://matschaffer.github.io/knife-solo/#label-Bootstrap+command) for further details.

__Example__

```bash
➜ knife digital_ocean droplet create --server-name awesome-vm1.vm.io \
                                      --image debian-7-0-x64 \
                                      --location lon1 \
                                      --size 2gb \
                                      --ssh-keys 1234,4567 \
                                      --run-list "<RUNLIST>" \
                                      --solo
```

#### C. With your custom external bootstrapping script or without chef at all

This will just create a droplet and return its IP-address. Nothing else. You can now run your custom solution to provision the droplet.

__Example__

```bash
➜ knife digital_ocean droplet create --server-name awesome-vm1.vm.io \
                                      --image debian-7-0-x64 \
                                      --location lon1 \
                                      --size 2gb \
                                      --ssh-keys 1234,4567
```

### List running droplets (servers)

```shell
➜ knife digital_ocean droplet list
ID     Name                  Size   Region       IPv4            Image                            Status
12345  app20.ams.nl.vm.io  1gb    Amsterdam 1  185.14.123.123  25306 (Ubuntu 12.10 x32 Server)  active
23456  awesome-vm1.vm.io   512mb  Amsterdam 1  185.14.124.125  25306 (Ubuntu 12.10 x32 Server)  active
```

### !WARNING! Destroy a droplet (server) including all of its data!

#### Destroy droplet by id
```shell
➜ knife digital_ocean droplet destroy -S 23456
OK
```

#### Destroy all droplets

```shell
➜ knife digital_ocean droplet destroy --all
Delete droplet with id: 1824315
Delete droplet with id: 1824316
Delete droplet with id: 1824317
```

### List regions

```shell
➜ knife digital_ocean region list
Name             Slug
New York 1       nyc1
Amsterdam 1      ams1
San Francisco 1  sfo1
New York 2       nyc2
Amsterdam 2      ams2
Singapore 1      sgp1
London 1         lon1
New York 3       nyc3
Amsterdam 3      ams3
```

### List sizes (instance types)

```shell
➜ knife digital_ocean size list
Slug
512mb
1gb
2gb
4gb
8gb
16gb
32gb
48gb
64gb
```

### List images

#### Custom images (snapshots, backups) (default)

```shell
➜ knife digital_ocean image list
ID     Distribution  Name
11111  Ubuntu        app100.ams.nlxxxxx.net 2013-02-01
11112  Ubuntu        app100.ams.nlxxxxx.net 2013-02-03
11113  Ubuntu        init
```

#### Public images (OS)

```shell
➜ knife digital_ocean image list --public
ID       Distribution  Name                                      Slug
6376601  Ubuntu        Ruby on Rails on 14.04 (Nginx + Unicorn)  ruby-on-rail
6423475  Ubuntu        WordPress on 14.04                        wordpress
6732690  Ubuntu        LEMP on 14.04                             lemp
6732691  Ubuntu        LAMP on 14.04                             lamp
6734341  Ubuntu        node-v0.10.32 on 14.04                    node
6734697  Ubuntu        Django on 14.04                           django
6738037  Ubuntu        Dokku v0.2.3 on 14.04 (w/ Docker 1.2.0)   dokku
6798184  Ubuntu        MEAN on 14.04                             mean
6854006  Ubuntu        Drupal 7.32 on 14.04                      drupal
6884371  Ubuntu        Magento 1.9.0.1 on 14.04                  magento
7284647  Ubuntu        Ghost 0.5.3 on 14.04                      ghost
7354580  Ubuntu        Docker 1.3.1 on 14.04                     docker
7518201  Ubuntu        GitLab 7.4.3 CE on 14.04                  gitlab
7572830  Ubuntu        Redmine on 14.04                          redmine
6370882  Fedora        20 x64                                    fedora-20-x6
6370885  Fedora        20 x32                                    fedora-20-x3
6370968  Fedora        19 x64                                    fedora-19-x6
6370969  Fedora        19 x32                                    fedora-19-x3
6372105  CentOS        6.5 x32                                   centos-6-5-x
6372108  CentOS        6.5 x64                                   centos-6-5-x
6372321  CentOS        5.10 x64                                  centos-5-8-x
6372425  CentOS        5.10 x32                                  centos-5-8-x
6372526  Debian        7.0 x64                                   debian-7-0-x
6372528  Debian        7.0 x32                                   debian-7-0-x
6372581  Debian        6.0 x64                                   debian-6-0-x
6372662  Debian        6.0 x32                                   debian-6-0-x
6374124  Ubuntu        10.04 x64                                 ubuntu-10-04
6374125  Ubuntu        10.04 x32                                 ubuntu-10-04
6374128  Ubuntu        12.04.5 x64                               ubuntu-12-04
6374130  Ubuntu        12.04.5 x32                               ubuntu-12-04
6882384  CoreOS        444.5.0 (beta)                            coreos-beta
6886342  CoreOS        444.5.0 (stable)                          coreos-stabl
6918735  Ubuntu        14.04 x32                                 ubuntu-14-04
6918990  Ubuntu        14.04 x64                                 ubuntu-14-04
7053293  CentOS        7.0 x64                                   centos-7-0-x
7111343  Ubuntu        14.10 x64                                 ubuntu-14-10
7111572  Ubuntu        14.10 x32                                 ubuntu-14-10
7556046  CoreOS        CoreOS (alpha) 490.0.0                    coreos-alpha
```

### SSH keys

#### List SSH keys

```shell
➜ knife digital_ocean sshkey list
ID    Name    Fingerprint
1234  Alice   e0:1a:1b:30:7f:bd:b2:cf:f2:4f:3b:35:3c:87:46:1c
1235  Bob     b0:ca:40:36:7f:bd:b2:cf:f2:4f:2b:45:3c:28:41:5f
1236  Chuck   g0:da:3e:15:7f:bd:b2:cf:f2:4f:3a:26:3c:34:52:2b
1237  Craig   f0:fa:2b:22:7f:bd:b2:cf:f2:4f:4c:18:3c:66:54:1c
```

#### Create a SSH key

```shell
➜ knife digital_ocean sshkey create -i ~/.ssh/id_rsa.pub -n Bob
```

#### Destroy a SSH key

```shell
➜ knife digital_ocean sshkey destroy -i 1236
OK
```

### DNS

#### Create a domain

```shell
➜ knife digital_ocean domain create -N example.com -I 192.168.1.1
```

#### Destroy a domain

```shell
➜ knife digital_ocean domain destroy -D example.com
OK
```

#### List domains

```shell
➜ knife digital_ocean domain list
Name         TTL
example.com  1800
```

#### Create a domain record

```shell
➜ knife digital_ocean domain create -D example.com -T cname -N www -a @
```

#### Destroy a domain record

```shell
➜ knife digital_ocean domain destroy -D example.com -R 3355880
OK
```

#### List domain records

```shell
➜ knife digital_ocean domain record list -D example.com
ID       Type  Name  Data
3355877  NS    @     ns1.digitalocean.com
3355878  NS    @     ns2.digitalocean.com
3355879  NS    @     ns3.digitalocean.com
3355880  A     @     192.168.1.1
```

### Account Info

```shell
➜ knife digital_ocean account info
UUID                                      Email           Droplet Limit  Email Verified
58e2e737d3b7407b042aa7f99f4da4229166f2a1  joe@example.com 10             true
```


## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

### Contributors

*   [Teemu Matilainen](https://github.com/tmatilai)
*   [Salvatore Poliandro](https://github.com/popsikle)

For more information and a complete list see [the contributor page on GitHub](https://github.com/rmoriz/knife-digital_ocean/contributors).

## License

Apache 2.0 (like Chef itself), see LICENSE.txt file.

## Copyright

Copyright © 2014 [Roland Moriz](https://roland.io), [Moriz GmbH](https://moriz.de/)
Copyright © 2014 [Greg Fitzgerald](https://github.com/gregf)
