# frozen_string_literal: true
require 'open3'
require 'vagrant/vm'
require 'vagrant/machine_readable_output/command'

module Vagrant
  #
  # Represents a Vagrant environment with zero or more VMs
  #
  class Environment
    include Command

    def vms
      result = []

      vagrant('status') do |message|
        if message.is_a?(MachineReadableOutput::State)
          result << VM.new(message.target)
        end
      end

      result
    end
  end
end
