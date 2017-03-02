# Ansible Role for Ruby

[![Build Status](https://travis-ci.org/nerab/ansible-role-ruby.svg?branch=master)](https://travis-ci.org/nerab/ansible-role-ruby)

This role installs Ruby from source into `/usr/local`.

You may override the installed version from [`defaults/main.yml`](defaults/main.yml) using the following variable struct in your playbook:

```yaml
vars:
  ruby_version:
    major: 2
    minor: 4
    revision: 0
```

# Test

Besides the tests running in Travis, there is a [Vagrant file](tests/Vagrantfile) in the [tests](tests) folder that runs this role when started with `vagrant up`.

# TODO

* Uninstall the old Ruby if the actually present ruby version is different from the desired one:

  ```yaml
  when: "ruby_version_present == '{{ ruby_version_full }}'"
  ```
