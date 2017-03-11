# frozen_string_literal: true
require 'open3'
require 'vagrant/logger'
require 'vagrant/machine_readable_output/parser'

module Vagrant
  module Command
    include Logger

    def vagrant(command, *args)
      command_args = ['vagrant', '--machine-readable', command]
      command_args.concat(args)

      logger.debug(command_args)

      Open3.popen3(*command_args) do |stdin, stdout, stderr, wait_thread|
        stdout.each do |line|
          begin
            message = parser.parse(line)
            logger.debug(message.to_s)
            yield message, nil if block_given?
          rescue CSV::MalformedCSVError => e
            yield nil, "#{e.message}: #{line}" if block_given?
          end
        end

        raise stderr.read unless wait_thread.value.success?
      end
    end

    def parser
      @parser ||= MachineReadableOutput::Parser.new
    end
  end
end
