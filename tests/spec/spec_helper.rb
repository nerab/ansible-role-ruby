#!/usr/bin/env ruby
# frozen_string_literal: true
$LOAD_PATH.unshift File.join(__dir__, '..', 'lib')

require 'pathname'

RSpec.configure do |config|
end

def fixture(path)
  Pathname('fixtures').join(path).expand_path(__dir__)
end
