# Ansible Role for Ruby

[![Build Status](https://travis-ci.org/nerab/ansible-role-ruby.svg?branch=master)](https://travis-ci.org/nerab/ansible-role-ruby)

This role installs Ruby from source into `/usr/local`.

You may override the installed version from [`defaults/main.yml`](defaults/main.yml) using the following variable struct in your playbook:

```yaml
vars:
  ruby_version:
    major: 2
    minor: 7
    teeny: 0
```

# Test

There is a [Vagrant file](tests/Vagrantfile) in the [tests](tests) folder that runs this role when started with `vagrant up`.

The Travis setup can be mimicked locally (from the project's root directory) with

```sh
$ ANSIBLE_ROLES_PATH=.. ansible-playbook -i tests/inventory tests/playbook-2.6.5.yml --syntax-check
```

# TODO

* Uninstall leaves a lot of empty directories behind
  => Can we just use the ones from `.installed.list` and delete those that are empty?
* Test upgrades between supported versions
* Perhaps switch tests to use [Molecule](https://www.jeffgeerling.com/blog/2018/testing-your-ansible-roles-molecule)
