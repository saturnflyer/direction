require 'test_helper'

class Person
  extend Direction
  command :make_me_a_sandwich => :@friend
  attr_accessor :friend
end

class Friend
  def make_me_a_sandwich
    Menu.record "I made a sandwich!"
  end
end

module Menu
  def self.record(text)
    list << text
  end
  def self.list
    @list ||= []
  end
  def self.clear
    @list = []
  end
end

describe Direction do
  let(:friend){ Friend.new }
  let(:person){ person = Person.new
                person.friend = friend
                person
              }
  before do
    Menu.clear
  end
  it 'forwards a message to another object' do
    assert_equal [], Menu.list
    person.make_me_a_sandwich
    assert_includes Menu.list, "I made a sandwich!"
  end
  
  it 'returns the original receiver' do
    assert_equal person, person.make_me_a_sandwich
  end
end