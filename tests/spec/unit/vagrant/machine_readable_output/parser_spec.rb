# frozen_string_literal: true
require 'spec_helper'
require 'vagrant/machine_readable_output/parser'

module Vagrant::MachineReadableOutput
  # rubocop:disable Metrics/BlockLength
  RSpec.describe Parser do
    let(:message) { subject.parse(line) }

    shared_examples 'escaping data' do
      it 'has data' do
        expect(message.data).to be
        expect(message.data).to_not be_empty
        expect(message.data).to_not include('VAGRANT_COMMA')
        expect(message.data).to_not include('\\n')
      end
    end

    context "VM state is 'running'" do
      context 'state' do
        let(:line) {'1489156915,ansible-role-ruby_debian,state,running'}

        it 'has the expected data' do
          expect(message.data).to eq('running')
        end
      end

      context 'state-human-short' do
        let(:line) { '1489156915,ansible-role-ruby_debian,state-human-short,running' }

        it 'has the expected data' do
          expect(message.data).to eq('running')
        end
      end

      context 'state-human-long' do
        # rubocop:disable Metrics/LineLength
        let(:line) { '1489156915,ansible-role-ruby_debian,state-human-long,The VM is running. To stop this VM%!(VAGRANT_COMMA) you can run `vagrant halt` to\nshut it down forcefully%!(VAGRANT_COMMA) or you can run `vagrant suspend` to simply\nsuspend the virtual machine. In either case%!(VAGRANT_COMMA) to restart it again%!(VAGRANT_COMMA)\nsimply run `vagrant up`.'}
        # rubocop:enable Metrics/LineLength

        it_behaves_like('escaping data')

        it 'has the expected data' do
          expect(message.data).to include('simply run')
        end
      end

      context 'ui' do
        let(:line){'1489166158,,ui,info,Current machine states:\n\nansible-role-ruby_debian  running (virtualbox)\nansible-role-ruby_ubuntu  running (virtualbox)\n\nThis environment represents multiple VMs. The VMs are all listed\nabove with their current state. For more information about a specific\nVM%!(VAGRANT_COMMA) run `vagrant status NAME`.'}
        it_behaves_like('escaping data')
      end
    end

    context "VM state is 'aborted'" do
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
        shared_examples 'message with target' do |target, expected_data|
          it 'has a target' do
            expect(message).to be_a(State)
            expect(message.target).to eq(target)
          end

          it 'has data' do
            expect(message.data).to_not be_empty
          end

          it 'has the expected data' do
            expect(message.data).to eq(expected_data)
          end
        end

        context 'of the Debian VM' do
          let(:line) { '1489008439,ansible-role-ruby_debian,state,aborted' }
          it_behaves_like('message with target', 'ansible-role-ruby_debian', 'aborted')
        end

        context 'of the Ubuntu VM' do
          let(:line) { '1489008439,ansible-role-ruby_ubuntu,state,aborted' }
          it_behaves_like('message with target', 'ansible-role-ruby_ubuntu', 'aborted')
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

        it_behaves_like('escaping data')
      end

      context 'a message with even more extra fields' do
        let(:line) { '1489008439,a_target,ui,info,extra0,extra1,extra2' }

        it 'splats extra fields into data' do
          expect(message.data).to eq(%w(info extra0 extra1 extra2))
        end
      end
    end
  end
end
