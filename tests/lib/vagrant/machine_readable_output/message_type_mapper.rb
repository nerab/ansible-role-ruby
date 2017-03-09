# frozen_string_literal: true
require 'vagrant/machine_readable_output/message'

module Vagrant
  module MachineReadableOutput
    #
    # Maps the 'type' component of a message to an actual class
    #
    class MessageTypeMapper
      def map(type)
        MachineReadableOutput.const_get(constantize(type))
      end

      def constantize(type)
        type.
          gsub(/^(\S)|-\S/, &:upcase).
          tr('-', '')
      end
    end
  end
end
