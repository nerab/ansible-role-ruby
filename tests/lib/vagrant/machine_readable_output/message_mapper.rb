# frozen_string_literal: true
require 'vagrant/machine_readable_output/message_type_mapper'

module Vagrant
  module MachineReadableOutput
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
  end
end
