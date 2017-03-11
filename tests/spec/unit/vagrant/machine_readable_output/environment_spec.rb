# frozen_string_literal: true
require 'spec_helper'
require 'vagrant/environment'

module Vagrant
  RSpec.describe Environment do
    it 'exists' do
      expect(subject).to be
    end
  end
end
