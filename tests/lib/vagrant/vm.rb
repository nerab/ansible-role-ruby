# frozen_string_literal: true
require 'open3'
require 'vagrant/snapshots'
require 'vagrant/machine_readable_output/message'
require 'vagrant/machine_readable_output/command'

module Vagrant
  class VM
    include Command
    include Snapshots

    attr_reader :name
    alias_method :to_s, :name

    def initialize(name='default')
      @name = name
    end

    # Returns an array of statue
    def status
      results = []

      vagrant('status') do |message, error|
        if message.is_a?(MachineReadableOutput::State)
          results << message.data
        end
      end

      results
    end

    def provision
      vagrant('provision') do |message, error|
        warn error if error
      end
    end

    def up(provision: true)
      vagrant('up', "--#{provision ? '' : 'no-'}provision")
    end
  end
end
