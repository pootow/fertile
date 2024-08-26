# fertile

`fertile`` is a tool for setup a new environment. The environment can be a new linux server, a new linux desktop, a new mac, or a new windows machine etc.

## core concepts

`config`: a config is just a description of actions need to be done to setup a new environment. for example:

* change linux kernel parameters
* change apt source

the config can be applied on demand, and can be applied multiple times. just like kubernetes, the config is declarative desired state, and the tool will make sure the actual state is the same as the desired state. so all scripts are idempotent and follow the pattern of `check and set`.

<!--
`app`: an app is a description of a software, including its name, version, and its config. apps may have multiple installations, for example, v2fly app may have multiple installations, each installation is a v2fly server, and each server has its own config.

`service`: a service is a description of a service, it can run in background, and can be started or stopped. for example, acme.sh is a service, it can run in background as a cron job, to renew certificates. 

**note**: the above concepts are old thoughts, for example, `service` and `app` are not distinct, app may run in background, and service may have multiple installations. so the concepts are not well defined, and may be changed in the future.
-->

## roadmap

this project will start as a one off script, and will evolve to a more reusable tool.

## TODO

* [ ] walk through a complete vps setup
  * [ ] secure the server
    * [ ] setup normal user and disable root login
      * [x] setup user
      * [x] remove user password and disable console login
      * [x] setup sudo
      * [x] setup ssh key login
      * [x] remove ssh password login
      * [ ] config sshd login retry and grace period
    * [ ] setup firewall
    * [x] server optimization
      * [x] change kernel parameters
        * [x] change tcp to use more modern congestion control algorithm(like bbr)
  * [x] apt update and upgrade
  * [ ] setup docker
* [ ] setup v2ray server on a vps
  * [ ] setup v2ray server
  * [ ] setup acme.sh
  * optional
    * [ ] setup nginx
    * [ ] setup a website for service obfuscation

## security

all credentials should be stored in a separate directory, eg: `~/.fertile/vault`, and should be kept locally, and should not be checked into git.
