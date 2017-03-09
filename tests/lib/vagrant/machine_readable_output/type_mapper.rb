# frozen_string_literal: true
require 'vagrant/machine_readable_output/components'

module Vagrant
  module MachineReadableOutput
    class TypeMapper
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
