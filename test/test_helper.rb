require 'simplecov'
SimpleCov.start do
  add_filter 'test'
  add_filter 'direction/version'
end

require 'minitest/autorun'
require 'direction'
