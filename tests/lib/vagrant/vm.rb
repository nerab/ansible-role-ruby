# frozen_string_literal: true
require 'pathname'

module Vagrant
  class VM
    def save_snapshot(name)
      `vagrant snapshot save #{version}`
    end

    def restore_snapshot(name)
      `vagrant snapshot restore #{version}`
    end

    def has_snapshot?(version)
      # data =
      MachineReadableOutputParser.new.parse(`vagrant snapshot list --machine-readable`)
    end

    def up(provision: true)
      `vagrant up --#{provision ? '' : 'no-'}provision`
    end

    def find_or_create_snapshot(version)
      if has_snapshot?(version)
        restore_snapshot(version)
        up(provision: false)
      else
        Pathname("playbook-#{version}.yml").cp('playbook.yml')
        up(provision: true)
        save_snapshot(version)
      end
    end
  end
end
