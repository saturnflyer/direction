require 'direction'
$:.unshift(__dir__) unless $:.include?(__dir__)
require 'sample/accountant'
require 'sample/customer'
require 'sample/kitchen'
require 'sample/micro_manager'
require 'sample/server'

def setup
  @kitchen = Kitchen.new
  @server = Server.new(@kitchen)
  @manager = MicroManager.new(@server)
  @customer = Customer.new(@server)
  @manager
  self
end

def manager
  @manager
end

def customer
  @customer
end

# Try loading this in the console and interact to make food using @manager vs. @customer
# customer.order_food('burrito').pay_bill vs. ... lots of commands for @manager