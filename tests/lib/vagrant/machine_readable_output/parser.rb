# frozen_string_literal: true
require 'csv'
require 'vagrant/machine_readable_output/converters'
require 'vagrant/machine_readable_output/type_mapper'

module Vagrant
  module MachineReadableOutput
    #
    # Parse Vagrant's machine readable output format
    # see https://www.vagrantup.com/docs/cli/machine-readable.html
    #
    class Parser
      class ComponentMapper
        def map(data)
          type_mapper = TypeMapper.new
          clazz = type_mapper.map(data[:type])

          clazz.new.tap do |component|
            component.timestamp = data[:timestamp]
            # ...
            component.optional = data[:optional]
          end
        end
      end

      # TODO: 'data' is actually "zero or more comma-separated values", so we need to handle it as array
      HEADERS = %i(timestamp target type data optional).freeze
      CONVERTERS = %i(epoch vagrant_comma newline) + CSV::Converters.keys

      CSV::Converters[:epoch] = EpochConverter.new(:timestamp)
      CSV::Converters[:vagrant_comma] = VagrantCommaConverter.new(:optional)
      CSV::Converters[:newline] = NewlineConverter.new(:optional)

      def parse(io)
        component_mapper = ComponentMapper.new

        CSV.new(io, col_sep: ',', headers: HEADERS, converters: CONVERTERS).map do |data|
          component_mapper.map(data)
        end
      end
    end
  end
end
