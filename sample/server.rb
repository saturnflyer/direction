class Server
  def initialize(kitchen)
    @kitchen = kitchen
    @accountant = kitchen.accountant
  end
  attr_reader :kitchen
  attr_accessor :customer
  
  def order_food(food)
    puts "I'll put that order in for you right now"
    sleep(2)
    kitchen.make_food(food)
    serve_food(food)
  end
  
  def serve_food(food)
    retrieve_food(food)
    sleep(2)
    puts " <Server retrieved #{food}>"
    return_to_customer(food)
  end
  
  def retrieve_food(food)
    kitchen.provide_food(food)
  end
  
  def return_to_customer(food)
    puts "Here's your order of #{food}"
  end
  
  def pay_bill
    @accountant.accept_funds
  end
end