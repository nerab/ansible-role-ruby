# frozen_string_literal: true
require 'vagrant/machine_readable_output/message_type_mapper'

module Vagrant
  module MachineReadableOutput
    #
    # Maps a message struct to a message
    #
    class MessageMapper
      def initialize
        @message_type_mapper = MessageTypeMapper.new
      end

      def map(row)
        message_class = @message_type_mapper.map(row[:type])
        message_class.new(row[:timestamp], row[:target], data(row))
      end

      private

      def data(row)
        extra = row.headers.map.with_index { |x, i| i if x.nil? }.compact.map do |i|
          row.field(i)
        end

        if extra.any?
          extra.unshift(row[:data])
        else
          row[:data]
        end
      end
    end
  end
end
