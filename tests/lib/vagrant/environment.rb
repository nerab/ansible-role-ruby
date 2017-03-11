# frozen_string_literal: true
require 'open3'
require 'vagrant/machine_readable_output/parser'
require 'logger'

module Vagrant
  #
  # Represents a Vagrant environment with potentially virtual machines
  #
  class Environment
    def initialize(logger=default_logger)
      @logger = logger
      @parser = MachineReadableOutput::Parser.new
    end

    def save_snapshot(name)
      vagrant('snapshot', 'save', name)
    end

    def restore_snapshot(name)
      vagrant('snapshot', 'restore', name)
    end

    def snapshots
      results = {}

      vagrant('snapshot', 'list') do |message|
        if message.is_a?(MachineReadableOutput::Ui)
          type, snapshot_name = *message.data

          if type == 'output'
            results[message.target] = snapshot_name
          end
        end
      end

      results
    end

    def has_snapshot?(name)
      snapshots.include?(name)
    end

    # Returns a hash of machine_name => status
    def status
      results = {}

      vagrant('status') do |message|
        if message.is_a?(MachineReadableOutput::State)
          results[message.target] = message.data
        end
      end

      results
    end

    def provision
      vagrant('provision')
    end

    def up(provision: true)
      vagrant('up', "--#{provision ? '' : 'no-'}provision")
    end

    # if a snapshot cannot be found, it will be created. Before doing so, `name` will be yielded to the given block.
    def find_or_create_snapshot(name)
      vagrant('halt')

      if has_snapshot?(name)
        logger.info("Found desired snapshot #{name}")
        restore_snapshot(name)
        up(provision: false)
      else
        logger.info("Could not find desired snapshot #{name}")
        yield name if block_given?
        up(provision: true)
        save_snapshot(name)
      end
    end

    private

    attr_reader :logger

    def default_logger
      Logger.new(STDERR).tap do |logger|
        logger.level = Logger::DEBUG
      end
    end

    def vagrant(command, *args)
      Open3.popen3('vagrant', '--machine-readable', command, *args) do |stdin, stdout, stderr, wait_thread|
        stdout.each do |line|
          message = @parser.parse(line)
          logger.debug(message.to_s)
          yield message if block_given?
        end

        raise stderr.read unless wait_thread.value.success?
      end
    end
  end
end
