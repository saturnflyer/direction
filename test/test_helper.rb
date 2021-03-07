require 'simplecov'
SimpleCov.start do
  add_filter 'test'
end

require 'codecov'
SimpleCov.formatter = SimpleCov::Formatter::Codecov

require 'minitest/autorun'
require 'direction'
