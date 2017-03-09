# frozen_string_literal: true
require 'open3'
require 'vagrant/machine_readable_output/parser'

module Vagrant
  class VM
    def save_snapshot(name)
      `vagrant snapshot save #{name} --machine-readable`
    end

    def restore_snapshot(name)
      `vagrant snapshot restore #{name} --machine-readable`
    end

    def has_snapshot?(name)
      # data =
      MachineReadableOutput::Parser.new.parse(`vagrant snapshot list --machine-readable`)
    end

    def status
      results = {}

      parser = MachineReadableOutput::Parser.new

      Open3.popen3('vagrant', 'status', '--machine-readable') do |stdin, stdout, stderr, wait_thr|
        pid = wait_thr.pid # pid of the started process.
        warn "Running status as pid #{pid}"

        stdout.each do |line|
          message = parser.parse(line).first

          if message.is_a?(MachineReadableOutput::State)
            results[message.target] = message.data
          end
        end

        exit_status = wait_thr.value # Process::Status object returned.
        warn "Finished with success: #{exit_status.success?}"
      end

      results
    end

    def up(provision: true)
      `vagrant up --#{provision ? '' : 'no-'}provision --machine-readable`
    end

    def find_or_create_snapshot(name)
      if has_snapshot?(name)
        restore_snapshot(name)
        up(provision: false)
      else
        yield name if block_given?
        up(provision: true)
        save_snapshot(name)
      end
    end
  end
end
