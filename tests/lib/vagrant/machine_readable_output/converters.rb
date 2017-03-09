# frozen_string_literal: true
module Vagrant
  module MachineReadableOutput
    class Converter
      def initialize(*headers)
        @headers = headers
      end

      def [](field, field_info)
        if @headers.include?(field_info.header)
          convert(field, field_info)
        else
          field
        end
      rescue ArgumentError => e
        warn "Error converting field '#{field_info}': #{e.message}. Offending value was: #{field}"
        field
      end

      def arity
        2
      end

      def convert(field, field_info)
        raise "Subclasses must override #{self.class}##{__method__}"
      end
    end

    class NewlineConverter < Converter
      def convert(field, field_info)
        field.gsub('\\n', "\n")
      end
    end

    class VagrantCommaConverter < Converter
      def convert(field, _)
        field.gsub('%!(VAGRANT_COMMA)', ',')
      end
    end

    class EpochConverter < Converter
      def convert(field, _)
        Time.at(field.to_i)
      end
    end
  end
end
