# frozen_string_literal: true
require 'spec_helper'
require 'vagrant/machine_readable_output/parser'

module Vagrant::MachineReadableOutput
  # rubocop:disable Metrics/BlockLength
  RSpec.describe Parser do
    context 'when the VM is in aborted state' do
      let(:message) { subject.parse(line) }
      let(:line) { '1489008439,ansible-role-ruby_debian,state-human-short,aborted' }

      it 'produces a message' do
        expect(message).to be
      end

      it 'produces a message with a time stamp' do
        expect(message).to respond_to(:timestamp)
        expect(message.timestamp).to be_within(2).of(Time.at(1489008438))
      end

      it 'produces a message with a target' do
        expect(message).to respond_to(:target)
      end

      context 'the state message' do
        shared_examples 'message with target' do |target|
          it 'has a target' do
            expect(message).to be_a(State)
            expect(message.target).to eq(target)
          end

          it 'has data' do
            expect(message.data).to eq('aborted')
          end
        end

        context 'of the Debian VM' do
          let(:line) { '1489008439,ansible-role-ruby_debian,state,aborted' }
          it_behaves_like('message with target', 'ansible-role-ruby_debian')
        end

        context 'of the Ubuntu VM' do
          let(:line) { '1489008439,ansible-role-ruby_ubuntu,state,aborted' }
          it_behaves_like('message with target', 'ansible-role-ruby_ubuntu')
        end
      end

      context 'the UI message' do
        # rubocop:disable Metrics/LineLength
        let(:line) { '1489008439,,ui,info,Current machine states:\n\nansible-role-ruby_debian  aborted (virtualbox)\nansible-role-ruby_ubuntu  aborted (virtualbox)\n\nThis environment represents multiple VMs. The VMs are all listed\nabove with their current state. For more information about a specific\nVM%!(VAGRANT_COMMA) run `vagrant status NAME`.' }
        # rubocop:enable Metrics/LineLength

        it 'has a target' do
          expect(message).to be_a(Ui)

          expect(message).to respond_to(:target)
          expect(message.target).to be_nil
        end

        it 'has data' do
          expect(message.data).to be
          expect(message.data).to_not be_empty
          expect(message.data).to_not include('VAGRANT_COMMA')
          expect(message.data).to_not include('\\n')
        end
      end
    end
  end
end
