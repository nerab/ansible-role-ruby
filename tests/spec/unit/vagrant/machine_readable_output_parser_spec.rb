# frozen_string_literal: true
require 'spec_helper'
require 'vagrant/machine_readable_output_parser'

RSpec.describe Vagrant::MachineReadableOutputParser do
  context 'aborted' do
    let(:parsed) { subject.parse(fixture('aborted.txt').read) }

    it 'can parse' do
      expect(parsed).to be
      expect(parsed).not_to be_empty
    end

    it 'has a list of components' do
      expect(parsed).to be
      expect(parsed.size).to eq(11)
    end

    it 'each component has a time stamp' do
      parsed.each do |component|
        expect(component).to respond_to(:timestamp)
        expect(component.timestamp).to be_within(2).of(Time.at(1489008438))
      end
    end

    it 'each component has data' do
      component = parsed.last
      expect(component).to respond_to(:optional)

      expect(component.optional).to be
      expect(component.optional).to_not be_empty
      expect(component.optional).to_not include('VAGRANT_COMMA')
      expect(component.optional).to_not include('\\n')
    end
  end
end
