# frozen_string_literal: true
require 'csv'
require 'vagrant/machine_readable_output/converters'
require 'vagrant/machine_readable_output/message_mapper'

module Vagrant
  module MachineReadableOutput
    #
    # Parse a line of Vagrant's machine-readable output format
    # see https://www.vagrantup.com/docs/cli/machine-readable.html
    #
    class Parser
      # TODO: 'data' is actually "zero or more comma-separated values", so we need to handle it as array
      HEADERS = %i(timestamp target type data optional).freeze
      CONVERTERS = %i(epoch vagrant_comma newline) + CSV::Converters.keys

      CSV::Converters[:epoch] = EpochConverter.new(:timestamp)
      CSV::Converters[:vagrant_comma] = VagrantCommaConverter.new(:optional)
      CSV::Converters[:newline] = NewlineConverter.new(:optional)

      def parse(io)
        message_mapper = MessageMapper.new
        message = CSV.new(io, col_sep: ',', headers: HEADERS, converters: CONVERTERS).shift
        message_mapper.map(message)
      end
    end
  end
end
