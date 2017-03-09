# frozen_string_literal: true
require 'spec_helper'
require 'vagrant/machine_readable_output/message_type_mapper'

module Vagrant::MachineReadableOutput
  # rubocop:disable Metrics/BlockLength
  RSpec.describe MessageTypeMapper do
    it 'understands metadata' do
      expect(subject.map('metadata')).to eq(Metadata)
    end

    it 'understands box-name' do
      expect(subject.map('box-name')).to eq(BoxName)
    end

    it 'understands box-provider' do
      expect(subject.map('box-provider')).to eq(BoxProvider)
    end

    it 'understands cli-command' do
      expect(subject.map('cli-command')).to eq(CliCommand)
    end

    it 'understands error-exit' do
      expect(subject.map('error-exit')).to eq(ErrorExit)
    end

    it 'understands provider-name' do
      expect(subject.map('provider-name')).to eq(ProviderName)
    end

    it 'understands ssh-config' do
      expect(subject.map('ssh-config')).to eq(SshConfig)
    end

    it 'understands state' do
      expect(subject.map('state')).to eq(State)
    end

    it 'understands state-human-long' do
      expect(subject.map('state-human-long')).to eq(StateHumanLong)
    end

    it 'understands state-human-short' do
      expect(subject.map('state-human-short')).to eq(StateHumanShort)
    end

    it 'understands ui' do
      expect(subject.map('ui')).to eq(Ui)
    end
  end
end
