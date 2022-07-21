require "direction/version"
# Provide a feature like the Forwardable library,
# but set the return value to self.
# It provides a class level "command" method to do
# message forwarding.
# 
# class SomeClass
#   extend Direction
# 
#   command [:print_details, :setup_things] => :collaborator
#   query [:name, :id] => :collaborator, :type => :@partner
# end
# 
# This will define methods on instances that forward to the
# provided receiver while enforcing encapsulation of the 
# relationship between objects.
module Direction

  # Forward messages and return self, protecting the encapsulation of the object
  def command(**options)
    Direction.define_methods(self, **options) do |command, accessor|
      %{
      def #{command}(...)
        #{accessor}.__send__(:#{command}, ...)
        self
      end
      }
    end
  end

  # Create an individual command with an optional alias
  def def_command accessor, method_name, aliased_method_name = method_name
    Direction.define_methods(self, accessor => [method_name, aliased_method_name]) do |accessor, (method_name, aliased_method_name)|
      %{
      def #{aliased_method_name}(...)
        #{accessor}.__send__(:#{method_name}, ...)
        self
      end
      }
    end
  end

  # Forward messages and return the result of the forwarded message
  def query(**options)
    Direction.define_methods(self, **options) do |query, accessor|
      %{
      def #{query}(...)
        #{accessor}.__send__(:#{query}, ...)
      end
      }
    end
  end

  def self.define_methods(mod, **options)
    method_defs = []
    options.each_pair do |method_names, accessor|
      Array(method_names).map do |message|
        method_defs.push yield(message, accessor)
      end
    end
    mod.class_eval method_defs.join("\n"), __FILE__, __LINE__
  end
end
