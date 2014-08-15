require 'test_helper'

class Person
  extend Direction
  command [:make_me_a_sandwich, :cook] => :@friend
  query [:activities, :go] => :friend
  attr_accessor :friend
end

class Friend
  def make_me_a_sandwich
    Menu.record "I made a sandwich!"
  end

  def cook(what)
    Menu.record what
  end

  def activities
    'running, biking, hiking'
  end

  def go(do_what)
    Activities.record do_what
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

module Activities
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

describe Direction, 'command' do
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

  it 'forwards additional arguments' do
    assert_equal [], Menu.list
    person.cook('yum')
    assert_includes Menu.list, "yum"
  end
end

describe Direction, 'query' do
  let(:friend){ Friend.new }
  let(:person){ person = Person.new
                person.friend = friend
                person
              }
  before do
    Activities.clear
  end

  it 'forwards a message to another object' do
    assert_includes person.activities, "running, biking, hiking"
  end

  it 'forwards additional arguments' do
    assert_equal [], Activities.list
    person.go('have fun')
    assert_includes Activities.list, "have fun"
  end
end