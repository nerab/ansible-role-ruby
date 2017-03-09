# frozen_string_literal: true
require 'spec_helper'
require 'vagrant/machine_readable_output/parser'

module Vagrant::MachineReadableOutput
  # rubocop:disable Metrics/BlockLength
  RSpec.describe Parser do
    context 'aborted' do
      let(:parsed) { subject.parse(fixture('aborted.txt').read) }

      it 'can parse' do
        expect(parsed).to be
        expect(parsed).not_to be_empty
      end

      it 'has a list of messages' do
        expect(parsed).to be
        expect(parsed.size).to eq(11)
      end

      it 'each message has a time stamp' do
        parsed.each do |message|
          expect(message).to respond_to(:timestamp)
          expect(message.timestamp).to be_within(2).of(Time.at(1489008438))
        end
      end

      context 'the state message' do
        context 'of the Debian VM' do
          let(:message) { parsed[3] }

          it 'has a target' do
            expect(message).to be_a(State)
            expect(message).to respond_to(:target)
            expect(message.target).to_not be_nil
            expect(message.target).to eq('ansible-role-ruby_debian')
          end

          it 'has data' do
            expect(message.data).to eq('aborted')
          end
        end

        context 'of the Ubuntu VM' do
          let(:message) { parsed[7] }

          it 'has a target' do
            expect(message).to be_a(State)
            expect(message).to respond_to(:target)
            expect(message.target).to_not be_nil
            expect(message.target).to eq('ansible-role-ruby_ubuntu')
          end

          it 'has data' do
            expect(message.data).to eq('aborted')
          end
        end
      end

      context 'the UI message' do
        let(:message) { parsed.last }

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
