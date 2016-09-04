# 2.5.0 / 2016-04-19

* fix vcr cassettes (droplet_kit pagination)
* drop support for Ruby 2.0.0
* fix to work with chef 12.5.x
* update droplet_kit dependency to 1.3.x
* fixed some rubocop issues (some are still pending)
* we will drop support for chef 10 and chef 11 soon,
  please upgrade to chef 12 ASAP!

# 2.4.2 / 2015-07-04

* Fix knife scaleway droplet destroy

# 2.4.1 / 2015-07-01

* Fix knife scaleway droplet destroy (broken)

# 2.4.0 / 2015-04-11

* Add knife-zero bootstrapping support

# 2.3.3 / 2015-03-17

* Bump droplet_kit version to fix a few bugs with api changes.

# 2.3.2 / 2014-01-29

* Removed duplicate splitting, Thanks to [@mikian](https://github.com/mikian) [PR #64]

# 2.3.1 / 2014-01-21

* Fix knife scaleway image list --public

# 2.3.0 / 2014-11-18

* New subcommands
  - knife scaleway droplet power
  - knife scaleway droplet powercycle
  - knife scaleway droplet reboot
  - knife scaleway droplet snapshot
  - knife scaleway droplet rename
  - knife scaleway droplet rebuild
  - knife scaleway droplet resize
  - knife scaleway image transfer
* Removed hacky use of rescue
* Use sort_by in list commands, where it makes sense
* Add --bootstrap-version to examples, thanks to [@brandoncc ](https://github.com/brandoncc) [PR #54]
* Fix status check during droplet create

## 2.2.0 / 2014-11-14

* Domain support, thanks to [@nozpheratu](https://github.com/nozpheratu) [PR #32]
* knife scaleway destroy -all, Thanks to [@yury-egorenkov](https://github.com/yury-egorenkov) [PR #41]
* New commands account info, sshkey create, sshkey destroy.

## 2.1.0 / 2014-11-09

* Better test coverage
* -6 --ipv6-enabled option to enable ipv6
* -b --backups-enabled option to enable backups, thanks to [@salemine](https://github.com/salemine) [PR #45]

## 2.0.0 / 2014-11-07

* Now using Digital Ocean apiv2.
* Switched to the droplet_kit gem
* knife scaleway images list -G now replaced with -P or --public
* knife[:scaleway_api_key] and knife[:scaleway_client_id] replaced with knife[:digitalocean_access_token]

* [Full Changelog](https://github.com/rmoriz/knife-scaleway/compare/v0.7.0...master)


## 0.7.0 / 2014-05-21

* [Full Changelog](https://github.com/rmoriz/knife-scaleway/compare/v0.6.0...v0.7.0)
* added --ssh-port option (thanks @popsikle)


## 0.6.0 / 2014-05-02

* [Full Changelog](https://github.com/rmoriz/knife-scaleway/compare/v0.5.0...v0.6.0)
* bump scaleway gem dependency (for hashie/rash removal to fix ChefDK issues)


## 0.5.0 / 2014-04-26

* [Full Changelog](https://github.com/rmoriz/knife-scaleway/compare/v0.4.0...v0.5.0)
* support for private networking and secret-file (thanks @popsikle)
* bump scaleway gem dependency (for faraday)


## 0.4.0 / 2013-12-30

* [Full Changelog](https://github.com/rmoriz/knife-scaleway/compare/v0.3.0...v0.4.0)
* bump scaleway gem dependency


## 0.3.0 / 2013-11-25

* [Full Changelog](https://github.com/rmoriz/knife-scaleway/compare/v0.2.0...v0.3.0)
* support for first_boot_attributes/json-attributes (thanks @zuazo)
* updated doc examples


## 0.2.0 / 2013-09-07

* [Full Changelog](https://github.com/rmoriz/knife-scaleway/compare/v0.1.1...v0.2.0)
* require ```scaleway``` gem version 1.2.0 or later_
* ensure status of image details is OK before outputting image name (thanks @salemine)
* add option to pass environment (thanks @tedkulp)


## 0.1.1 / 2013-03-26

* [Full Changelog](https://github.com/rmoriz/knife-scaleway/compare/v0.1.0...v0.1.1)
* merge to knife bootstrap config instead of overwriting it (thanks @tmatilai)
* bump dependency to ```scaleway``` gem to circument issue https://github.com/rmoriz/knife-scaleway/issues/10


## 0.1.0 / 2013-03-01

* [Full Changelog](https://github.com/rmoriz/knife-scaleway/compare/v0.0.5...v0.1.0)
* support for integrated ```knife-solo``` bootstrapping using the ```--solo``` option (thanks @tmatilai)
* added basic rspec tests for various bootstrapping options
* remove JRuby from CI as chef itself does currently not work with JRuby
  except when c-extensions are enabled (off by default)


## 0.0.5 / 2013-02-23

* [Full Changelog](https://github.com/rmoriz/knife-scaleway/compare/v0.0.4...v0.0.5)


## 0.0.4 / 2013-02-18

* [Full Changelog](https://github.com/rmoriz/knife-scaleway/compare/v0.0.3...v0.0.4)


## 0.0.2 / 2013-02-04

* [Full Changelog](https://github.com/rmoriz/knife-scaleway/compare/v0.0.1...v0.0.2)


## 0.0.1 / 2013-02-03

* [Full Changelog](https://github.com/rmoriz/knife-scaleway/compare/d9bd11c01c8d963a1214e7ab234eeb7f09e6a7eb...v0.0.1)
* First release
