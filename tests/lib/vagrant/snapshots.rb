# frozen_string_literal: true
require 'vagrant/logger'
require 'vagrant/machine_readable_output/command'

module Vagrant
  module Snapshots
    include Command
    include Logger

    def save_snapshot(snapshot_name)
      vagrant('snapshot', 'save', name, snapshot_name)
    end

    def restore_snapshot(snapshot_name)
      vagrant('snapshot', 'restore', name, snapshot_name)
    end

    def snapshots
      results = []

      vagrant('snapshot', 'list', name) do |message|
        if message.is_a?(MachineReadableOutput::Ui)
          type, snapshot_name = *message.data

          if type == 'output' && !snapshot_name.end_with?('No snapshots have been taken yet!')
            results << snapshot_name
          end
        end
      end

      results
    end

    #
    # Returns true the VM has a snapshot with the given name
    #
    def has_snapshot?(snapshot_name)
      snapshots.include?(snapshot_name)
    end

    #
    # If a snapshot with the given name is found, true will be yielded to the given block.
    # If it cannot be found, a new snapshot will be created. Before doing so, false will be yielded to the given block.
    #
    def restore_or_create_snapshot(snapshot_name)
      if has_snapshot?(snapshot_name)
        logger.info("Found desired snapshot #{snapshot_name}")
        yield true if block_given?
        restore_snapshot(snapshot_name)
        up(provision: false)
      else
        logger.info("Could not find desired snapshot #{snapshot_name}")
        yield false if block_given?
        up(provision: true)
        save_snapshot(snapshot_name)
      end
    end
  end
end
