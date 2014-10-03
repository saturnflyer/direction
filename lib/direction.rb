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
  def command(options)
    Direction.define_methods(self, options) do |message, accessor|
      %{
      def #{message}(*args, &block)
        #{accessor}.__send__(:#{message}, *args, &block)
        self
      end
      }
    end
  end

  # Forward messages and return the result of the forwarded message
  def query(options)
    Direction.define_methods(self, options) do |message, accessor|
      %{
      def #{message}(*args, &block)
        #{accessor}.__send__(:#{message}, *args, &block)
      end
      }
    end
  end

  def self.define_methods(mod, options)
    method_defs = []
    options.each_pair do |method_names, accessor|
      Array(method_names).map do |message|
        method_defs.unshift yield(message, accessor)
      end
    end
    mod.class_eval method_defs.join("\n"), __FILE__, __LINE__
  end
end
