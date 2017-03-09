# frozen_string_literal: true
require 'csv'
require 'vagrant/machine_readable_output/converters'
require 'vagrant/machine_readable_output/message_type_mapper'

module Vagrant
  module MachineReadableOutput
    #
    # Parse Vagrant's machine readable output format
    # see https://www.vagrantup.com/docs/cli/machine-readable.html
    #
    class Parser
      #
      # Maps a message struct to a message
      #
      class MessageMapper
        def map(message)
          message_type_mapper = MessageTypeMapper.new
          message_class = message_type_mapper.map(message[:type])
          message_class.new(message[:timestamp], message[:target], message[:data])
        end
      end

      # TODO: 'data' is actually "zero or more comma-separated values", so we need to handle it as array
      HEADERS = %i(timestamp target type data optional).freeze
      CONVERTERS = %i(epoch vagrant_comma newline) + CSV::Converters.keys

      CSV::Converters[:epoch] = EpochConverter.new(:timestamp)
      CSV::Converters[:vagrant_comma] = VagrantCommaConverter.new(:optional)
      CSV::Converters[:newline] = NewlineConverter.new(:optional)

      def parse(io)
        message_mapper = MessageMapper.new

        CSV.new(io, col_sep: ',', headers: HEADERS, converters: CONVERTERS).map do |message|
          message_mapper.map(message)
        end
      end
    end
  end
end