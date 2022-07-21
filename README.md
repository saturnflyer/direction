# Direction

[![Build Status](https://travis-ci.org/saturnflyer/direction.png?branch=master)](https://travis-ci.org/saturnflyer/direction)
[![Code Climate](https://codeclimate.com/github/saturnflyer/direction.png)](https://codeclimate.com/github/saturnflyer/direction)
[![Gem Version](https://badge.fury.io/rb/direction.png)](http://badge.fury.io/rb/direction)

Enforce better encapsulation by returning self from commands.

Thanks to James Ladd for the inspiration.

## Usage

Provide a feature like the Forwardable library, but set the return value to self.

It provides a class level "command" method to do message forwarding.

```ruby
class Person
  extend Direction

  command [:print_address] => :home

  attr_accessor :home
end

class Home
  def print_address(template)
    template << "... the address.."
  end
end

template = STDOUT
person = Person.new
person.home = Home.new
#commands won't leak internal structure and return the receiver of the command
person.print_address(template) #=> person

```

This will define methods on instances that forward to the provided receiver while enforcing encapsulation of the relationship between objects.


## Installation

Add this line to your application's Gemfile:

    gem 'direction'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install direction

## Contributing

Special thanks to [Aaron Kromer](https://github.com/cupakromer/) and [Ken Collins](https://github.com/metaskills) for their thoughts and code.

1. Fork it ( http://github.com/saturnflyer/direction/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
