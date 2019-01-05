# Ansible Role for Ruby

[![Build Status](https://travis-ci.org/nerab/ansible-role-ruby.svg?branch=master)](https://travis-ci.org/nerab/ansible-role-ruby)

This role installs Ruby from source into `/usr/local`.

You may override the installed version from [`defaults/main.yml`](defaults/main.yml) using the following variable struct in your playbook:

```yaml
vars:
  ruby_version:
    major: 2
    minor: 6
    revision: 0
```

# Test

There is a [Vagrant file](tests/Vagrantfile) in the [tests](tests) folder that runs this role when started with `vagrant up`.

The Travis setup can be mimicked locally (from the project's root directory) with

```sh
$ ANSIBLE_ROLES_PATH=.. ansible-playbook -i tests/inventory tests/test.yml --syntax-check
```

# TODO

* Uninstall leaves a lot of empty directories behind
  => Can we just use the ones from `.installed.list` and delete those that are empty?
* Does "make -j `nproc`" improve compilation time?
* In the Ruby semver scheme, `revision` is really called [`teeny`](https://github.com/ruby/ruby#how-to-compile-and-install)
* Test upgrades between supported versions
* Create a Travis matrix to test the [stable Ruby releases](https://www.ruby-lang.org/en/downloads)
* Perhaps switch tests to use [Molecule](https://www.jeffgeerling.com/blog/2018/testing-your-ansible-roles-molecule)
