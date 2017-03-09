# frozen_string_literal: true
require 'spec_helper'
require 'vagrant/vm'

module Vagrant
  RSpec.describe VM do
    it 'exists' do
      expect(subject).to be
    end
  end
end
