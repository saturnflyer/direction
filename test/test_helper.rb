require 'simplecov'
SimpleCov.start do
  add_filter 'test'
end

require 'coveralls'
if ENV['COVERALLS']
  Coveralls.wear!
end

require 'minitest/autorun'
require 'direction'