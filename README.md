# Knife::DigitalOcean
## A knife plugin to deal with the [DigitalOcean.com](https://www.digitalocean.com) Cloud services.

This is a plugin for [Chef's](http://www.opscode.com/chef/) [knife](http://wiki.opscode.com/display/chef/Knife) tool. It allows you to bootstrap virtual machines with [DigitalOcean.com](https://www.digitalocean.com/) including the initial bootstrapping of chef on that system.
You can also skip the chef bootstrapping if you prefer using [knife-solo](http://matschaffer.github.com/knife-solo/) or another solution.

This knife plugin uses the [digital_ocean](https://github.com/rmoriz/digital_ocean) rubygem.


## Installation

(chef needs to be installed upfront, of course)

```shell
➜ gem install knife-digital_ocean
```


## Overview

This plugin provides the following sub-commands:

* knife digital_ocean droplet create (options)   
  **Creates a virtual machine with or without bootstrapping chef-client**

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

#### With bootstrapping in an chef-server environment:

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
➜ knife digital_ocean droplet create --N <FQDN> \
                                      --I <IMAGE ID> \
                                      --L <REGION ID> \
                                      --S <SIZE ID> \
                                      --K <SSH KEY-ID(s), comma-separated> \
                                      --B \
                                      --r "<RUNLIST>"
```

#### With knife-solo, your custom external bootstrapping script or without chef at all

This will just create a droplet and return its IP-address. Nothing else. You can now run your custom solution to provision the droplet e.g. ```knife solo bootstrap <IP> ``` if you use knife-solo. 

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

### List regions (servers)

```shell
➜ knife digital_ocean region list
ID  Name       
1   New York 1 
2   Amsterdam 1
```

### List sizes (server types)

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
ID     Distribution  Name                                 Global
23593  Arch Linux    Arch Linux 2012-09 x64               +     
1602   CentOS        CentOS 5.8 x32                       +     
1601   CentOS        CentOS 5.8 x64                       +     
1605   CentOS        CentOS 6.0 x32                       +     
1611   CentOS        CentOS 6.2 x64                       +     
12578  CentOS        CentOS 6.3 x32                       +     
12574  CentOS        CentOS 6.3 x64                       +     
12575  Debian        Debian 6.0 x32                       +     
12573  Debian        Debian 6.0 x64                       +     
1606   Fedora        Fedora 15 x64                        +     
1618   Fedora        Fedora 16 x64 Desktop                +     
1615   Fedora        Fedora 16 x64 Server                 +     
32399  Fedora        Fedora 17 x32 Desktop                +     
32387  Fedora        Fedora 17 x32 Server                 +     
32419  Fedora        Fedora 17 x64 Desktop                +     
32428  Fedora        Fedora 17 x64 Server                 +     
63749  Gentoo        Gentoo 2013-1 x64                    +     
1607   Gentoo        Gentoo x64                           +     
46964  Ubuntu        LAMP on Ubuntu 12.04                 +     
4870   Ubuntu        Rails 3.2.2 - Nginx MySQL Passenger  +     
14098  Ubuntu        Ubuntu 10.04 x32 Server              +     
14097  Ubuntu        Ubuntu 10.04 x64 Server              +     
43462  Ubuntu        Ubuntu 11.04x32 Desktop              +     
43458  Ubuntu        Ubuntu 11.04x64 Server               +     
1609   Ubuntu        Ubuntu 11.10 x32 Server              +     
42735  Ubuntu        Ubuntu 12.04 x32 Server              +     
14218  Ubuntu        Ubuntu 12.04 x64 Desktop             +     
2676   Ubuntu        Ubuntu 12.04 x64 Server              +     
25485  Ubuntu        Ubuntu 12.10 x32 Desktop             +     
25306  Ubuntu        Ubuntu 12.10 x32 Server              +     
25493  Ubuntu        Ubuntu 12.10 x64 Desktop             +     
25489  Ubuntu        Ubuntu 12.10 x64 Server              +     
13632  openSUSE      Open Suse 12.1 x32                   +     
13863  openSUSE      Open Suse 12.2 X64                   +  
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


## License

Apache 2.0 (like Chef itself), see LICENSE.txt file.


## Copyright

Copyright © 2013 [Roland Moriz](https://roland.io), [Moriz GmbH](https://moriz.de/)

[![LinkedIn](http://www.linkedin.com/img/webpromo/btn_viewmy_160x25.png)](http://www.linkedin.com/in/rmoriz)
