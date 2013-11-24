# Knife::DigitalOcean
## A knife plugin to deal with the [DigitalOcean.com](https://www.digitalocean.com) Cloud services.

[![Gem Version](https://badge.fury.io/rb/knife-digital_ocean.png)](http://badge.fury.io/rb/knife-digital_ocean)
[![Build Status](https://travis-ci.org/rmoriz/knife-digital_ocean.png)](https://travis-ci.org/rmoriz/knife-digital_ocean)
<a href="https://gemnasium.com/rmoriz/knife-digital_ocean"><img src="https://gemnasium.com/rmoriz/knife-digital_ocean.png"/></a>
<a href="https://codeclimate.com/github/rmoriz/knife-digital_ocean"><img src="https://codeclimate.com/github/rmoriz/knife-digital_ocean.png"/></a>

This is a plugin for [Chef's](http://www.opscode.com/chef/) [knife](http://wiki.opscode.com/display/chef/Knife) tool. It allows you to bootstrap virtual machines with [DigitalOcean.com](https://www.digitalocean.com/) including the initial bootstrapping of chef on that system.
You can also use [knife-solo](http://matschaffer.github.com/knife-solo/) for chef bootstrapping or skip it altogether for another solution.

This knife plugin uses the [digital_ocean](https://github.com/rmoriz/digital_ocean) rubygem.


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
knife[:digital_ocean_client_id] = 'XXXXXXXXXXXX'
knife[:digital_ocean_api_key]   = 'YYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYY'
```

## Usage

### Create a Droplet

There are three different ways of creating a server/droplet instance:

If you just want to launch an instance
form the command line without any bootstrapping, go for option **C**.
If you use ```knife-solo``` try **B** and if you are a ```chef-server```-fan
use method **A**:
#### A. With bootstrapping in an chef-server environment:

__Example__

```shell
➜ knife digital_ocean droplet create --server-name awesome-vm1.chef.io \
                                      --image 25306 \
                                      --location 2 \
                                      --size 66 \
                                      --ssh-keys 1234,1235 \
                                      --bootstrap \
                                      --run-list "role[base],role[webserver]"
```

__Syntax__

```shell
➜ knife digital_ocean droplet create --server-name <FQDN> \
                                      --image <IMAGE ID> \
                                      --location <REGION ID> \
                                      --size <SIZE ID> \
                                      --ssh-keys <SSH KEY-ID(s), comma-separated> \
                                      --bootstrap \
                                      --run-list "<RUNLIST>"
```

__Short Syntax__

```shell
➜ knife digital_ocean droplet create -N <FQDN> \
                                      -I <IMAGE ID> \
                                      -L <REGION ID> \
                                      -S <SIZE ID> \
                                      -K <SSH KEY-ID(s), comma-separated> \
                                      -B \
                                      -r "<RUNLIST>"
```

#### B. With knife-solo bootstrapping

You need to have [knife-solo](http://matschaffer.github.com/knife-solo/) gem installed.

This will create a droplet and run `knife solo bootstrap <IP>` equivalent for it.
Please consult the [knife-solo documentation](http://matschaffer.github.io/knife-solo/#label-Bootstrap+command) for further details.

__Example__

```bash
➜ knife digital_ocean droplet create --server-name awesome-vm1.chef.io \
                                      --image 25306 \
                                      --location 2 \
                                      --size 66 \
                                      --ssh-keys 1234,4567 \
                                      --run-list "<RUNLIST>" \
                                      --solo
```

#### C. With your custom external bootstrapping script or without chef at all

This will just create a droplet and return its IP-address. Nothing else. You can now run your custom solution to provision the droplet.

__Example__

```bash
➜ knife digital_ocean droplet create --server-name awesome-vm1.chef.io \
                                      --image 25306 \
                                      --location 2 \
                                      --size 66 \
                                      --ssh-keys 1234,4567
```

### List running droplets (servers)

```shell
➜ knife digital_ocean droplet list
ID     Name                  Size   Region       IPv4            Image                            Status
12345  app20.ams.nl.chef.io  1GB    Amsterdam 1  185.14.123.123  25306 (Ubuntu 12.10 x32 Server)  active
23456  awesome-vm1.chef.io   512MB  Amsterdam 1  185.14.124.125  25306 (Ubuntu 12.10 x32 Server)  active
```

### Destroy a droplet (server) including all of its data!

```shell
➜ knife digital_ocean droplet destroy -S 23456
OK
```

### List regions

```shell
➜ knife digital_ocean region list
ID  Name
1   New York 1
2   Amsterdam 1
3   San Francisco 1
4   New York 2
```

### List sizes (instance types)

```shell
➜ knife digital_ocean size list
ID  Name
63  1GB
62  2GB
64  4GB
65  8GB
61  16GB
60  32GB
70  48GB
69  64GB
68  96GB
66  512MB
```

### List images

#### Custom images (snapshots, backups) (default)

```shell
➜ knife digital_ocean image list
ID     Distribution  Name                                Global
11111  Ubuntu        app100.ams.nlxxxxx.net 2013-02-01   -
11112  Ubuntu        app100.ams.nlxxxxx.net 2013-02-03   -
11113  Ubuntu        init                                -
```


#### Global images (OS)

```shell
➜ knife digital_ocean image list --global
ID       Distribution  Name                                             Global
361740   Arch Linux    Arch Linux 2013.05 x32                           +
350424   Arch Linux    Arch Linux 2013.05 x64                           +
1602     CentOS        CentOS 5.8 x32                                   +
1601     CentOS        CentOS 5.8 x64                                   +
376568   CentOS        CentOS 6.4 x32                                   +
562354   CentOS        CentOS 6.4 x64                                   +
12575    Debian        Debian 6.0 x32                                   +
12573    Debian        Debian 6.0 x64                                   +
303619   Debian        Debian 7.0 x32                                   +
308287   Debian        Debian 7.0 x64                                   +
32387    Fedora        Fedora 17 x32                                    +
32399    Fedora        Fedora 17 x32 Desktop                            +
32428    Fedora        Fedora 17 x64                                    +
32419    Fedora        Fedora 17 x64 Desktop                            +
697056   Fedora        Fedora 19 x32                                    +
696598   Fedora        Fedora 19 x64                                    +
1004145  Ubuntu        Docker on Ubuntu 13.04 x64                       +
959207   Ubuntu        Ghost 0.3.3 on Ubuntu 12.04                      +
1215015  Ubuntu        GitLab 6.2.4 CE                                  +
459444   Ubuntu        LAMP on Ubuntu 12.04                             +
483575   Ubuntu        Redmine on Ubuntu 12.04                          +
464235   Ubuntu        Ruby on Rails on Ubuntu 12.10 (Nginx + Unicorn)  +
14098    Ubuntu        Ubuntu 10.04 x32                                 +
14097    Ubuntu        Ubuntu 10.04 x64                                 +
284211   Ubuntu        Ubuntu 12.04 x32                                 +
284203   Ubuntu        Ubuntu 12.04 x64                                 +
1015250  Ubuntu        Ubuntu 12.04.3 x32                               +
1015253  Ubuntu        Ubuntu 12.04.3 x64                               +
433240   Ubuntu        Ubuntu 12.10 x32                                 +
473123   Ubuntu        Ubuntu 12.10 x64                                 +
473136   Ubuntu        Ubuntu 12.10 x64 Desktop                         +
345791   Ubuntu        Ubuntu 13.04 x32                                 +
350076   Ubuntu        Ubuntu 13.04 x64                                 +
962304   Ubuntu        Ubuntu 13.10 x32                                 +
961965   Ubuntu        Ubuntu 13.10 x64                                 +
1061995  Ubuntu        Wordpress on Ubuntu 12.10                        +
```


### SSH keys (previously uploaded via DigitalOcean's webfrontend)

```shell
➜ knife digital_ocean sshkey list
ID    Name
1234  Alice
1235  Bob
1236  Chuck
1237  Craig
```


## Commercial Support

Commercial support is available. Please contact [https://roland.io/](https://roland.io/) or [http://moriz.com/](http://moriz.com/)


## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

### Contributors

*   [Teemu Matilainen](https://github.com/tmatilai)

For more information and a complete list see [the contributor page on GitHub](https://github.com/rmoriz/knife-digital_ocean/contributors).

## License

Apache 2.0 (like Chef itself), see LICENSE.txt file.


## Mobile Application

Ever wanted to control your DigitalOcean Droplets with your iPhone, iPad or iPod Touch?

[Get my CloudOcean App!](http://cloudoceanapp.com/)

[![CloudOcean - DigitalOcean iOS app](http://i.imgur.com/JLQua2w.png)](http://cloudoceanapp.com/)


## Copyright

Copyright © 2013 [Roland Moriz](https://roland.io), [Moriz GmbH](https://moriz.de/)

[![LinkedIn](http://www.linkedin.com/img/webpromo/btn_viewmy_160x25.png)](http://www.linkedin.com/in/rmoriz)
[![Twitter](http://i.imgur.com/1kYFHlu.png)](https://twitter.com/rmoriz)




