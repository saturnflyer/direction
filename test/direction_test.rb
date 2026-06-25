require "test_helper"

class Person
  extend Direction
  command [:make_me_a_sandwich, :cook, :blocky] => :@friend
  query [:activities, :go, :say_what] => :friend
  attr_accessor :friend

  def_command :friend, :cook, :get_in_the_kitchen_and_cook
end

class Friend
  def make_me_a_sandwich
    Table.place "a sandwich!"
  end

  def cook(what)
    Table.place what
  end

  def activities
    "running, biking, hiking"
  end

  def go(do_what)
    Activities.record do_what
  end

  def blocky(text)
    Activities.record([yield(self).to_s, text].join(" "))
  end

  def say_what(text)
    [yield(self).to_s, text].join(" ")
  end
end

module Table
  def self.place(text)
    contents << text
  end

  def self.contents
    @contents ||= []
  end

  def self.clear
    @contents = []
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

class SpecialCollaborator
  attr_reader :value

  def reload!
    Table.place "reloaded"
  end

  def ready?
    Table.place "asked if ready"
    true
  end

  def value=(new_value)
    @value = new_value
  end
end

describe Direction, "command" do
  let(:friend) { Friend.new }
  let(:person) {
    person = Person.new
    person.friend = friend
    person
  }
  before do
    Table.clear
    Activities.clear
  end
  it "forwards a message to another object" do
    assert_equal [], Table.contents
    person.make_me_a_sandwich
    assert_includes Table.contents, "a sandwich!"
  end

  it "returns the original receiver" do
    assert_equal person, person.make_me_a_sandwich
  end

  it "forwards additional arguments" do
    assert_equal [], Table.contents
    person.cook("yum")
    assert_includes Table.contents, "yum"
  end

  it "forwards block arguments" do
    assert_equal [], Activities.list
    person.blocky("yay!") do |friend|
      "Arguments forwarded to #{friend}"
    end
    assert_includes Activities.list, "Arguments forwarded to #{friend} yay!"
  end

  it "allows individual commands with an alias" do
    person.get_in_the_kitchen_and_cook("breakfast")
    assert_includes Table.contents, "breakfast"
  end
end

describe Direction, "query" do
  let(:friend) { Friend.new }
  let(:person) {
    person = Person.new
    person.friend = friend
    person
  }
  before do
    Activities.clear
  end

  it "forwards a message to another object" do
    assert_includes person.activities, "running, biking, hiking"
  end

  it "forwards additional arguments" do
    assert_equal [], Activities.list
    person.go("have fun")
    assert_includes Activities.list, "have fun"
  end

  it "forwards block arguments" do
    assert_equal [], Activities.list
    what_said = person.say_what("yay!") do |friend|
      "Arguments forwarded to #{friend}"
    end
    assert_equal what_said, "Arguments forwarded to #{friend} yay!"
  end
end

describe Direction, "command with non-identifier method names" do
  let(:collaborator) { SpecialCollaborator.new }
  let(:commander) {
    klass = Class.new do
      extend Direction
      command [:reload!, :ready?, :value=] => :collab
      attr_accessor :collab
    end
    obj = klass.new
    obj.collab = collaborator
    obj
  }
  before { Table.clear }

  it "forwards a bang method and returns self" do
    assert_equal commander, commander.reload!
    assert_includes Table.contents, "reloaded"
  end

  it "forwards a predicate method and returns self" do
    assert_equal commander, commander.ready?
    assert_includes Table.contents, "asked if ready"
  end

  it "forwards a setter method" do
    commander.send(:value=, 42)
    assert_equal 42, collaborator.value
  end
end

describe Direction, "loading" do
  it "can be extended without requiring forwardable first" do
    lib = File.expand_path("../lib", __dir__)
    script = 'require "direction"; Class.new { extend Direction }; print "ok"'
    output = IO.popen([RbConfig.ruby, "-I#{lib}", "-e", script], err: [:child, :out], &:read)
    assert_equal "ok", output
  end
end
