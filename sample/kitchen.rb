class Kitchen
  def make_food(food)
    puts " <Kitchen preparing #{food}>"
    sleep(3)
    puts " <Kitchen made #{food}>"
  end

  def provide_food(food)
    puts " <Kitchen served up #{food}>"
  end

  def accountant
    @accountant ||= Accountant.new
  end
end
