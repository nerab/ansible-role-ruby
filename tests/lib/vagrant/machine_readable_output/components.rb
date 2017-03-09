# frozen_string_literal: true
module Vagrant
  module MachineReadableOutput
    Component = Struct.new(:timestamp, :target, :optional)

    # UI
    Ui = Class.new(Component)

    # Meta data
    Metadata = Class.new(Component)

    # Name of a box installed into Vagrant.
    BoxName = Class.new(Component)

    # Provider for an installed box.
    BoxProvider = Class.new(Component)

    # A subcommand of vagrant that is available.
    CliCommand = Class.new(Component)

    # An error occurred that caused Vagrant to exit. This contains that error. Contains two data elements: type of error, error message.
    ErrorExit = Class.new(Component)

    # The provider name of the target machine. targeted
    ProviderName = Class.new(Component)

    # The OpenSSH compatible SSH config for a machine. This is usually the result of the "ssh-config" command. targeted
    SshConfig = Class.new(Component)

    # The state ID of the target machine. targeted
    State = Class.new(Component)

    # Human-readable description of the state of the machine. This is the long version, and may be a paragraph or longer. targeted
    StateHumanLong = Class.new(Component)

    # Human-readable description of the state of the machine. This is the short version, limited to at most a sentence. targeted
    StateHumanShort = Class.new(Component)
  end
end
