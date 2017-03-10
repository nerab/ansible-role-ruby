# frozen_string_literal: true
module Vagrant
  module MachineReadableOutput
    # An (abstract) message of a message
    Message = Struct.new(:timestamp, :target, :data) do
      def to_s
        "#{class_name}: #{data}"
      end

      private

      def class_name
        self.class.name.split('::').last
      end
    end

    # UI
    Ui = Class.new(Message)

    # Meta data
    Metadata = Class.new(Message)

    # Name of a box installed into Vagrant.
    BoxName = Class.new(Message)

    # Provider for an installed box.
    BoxProvider = Class.new(Message)

    # A subcommand of vagrant that is available.
    CliCommand = Class.new(Message)

    # An error occurred that caused Vagrant to exit. This contains that error. Contains two data elements: type of error, error message.
    ErrorExit = Class.new(Message)

    # The provider name of the target machine. targeted
    ProviderName = Class.new(Message)

    # The OpenSSH compatible SSH config for a machine. This is usually the result of the "ssh-config" command. targeted
    SshConfig = Class.new(Message)

    # The state ID of the target machine. targeted
    State = Class.new(Message)

    # Human-readable description of the state of the machine. This is the long version, and may be a paragraph or longer. targeted
    StateHumanLong = Class.new(Message)

    # Human-readable description of the state of the machine. This is the short version, limited to at most a sentence. targeted
    StateHumanShort = Class.new(Message)
  end
end
