class Customer
  extend Direction
  def initialize(server)
    @server = server
  end
  attr_accessor :server

  command [:order_food, :pay_bill] => :server
end
