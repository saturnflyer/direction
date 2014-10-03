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

  # Generates a string sufficient to forward messages to the accessor.
  # Specify the return_value for the result of the forwarded message.
  def self.message_handler(message, accessor, return_value)
    %{
    def #{message}(*args)
      if block_given?
        #{accessor}.__send__(:#{message}, *args) { |*block_args| yield(*block_args) }
      else
        #{accessor}.__send__(:#{message}, *args)
      end
      #{return_value}
    end
    }
  end

  # Loops over a hash of options and defines methods to the apply_to module/class provided.
  # Specify the return_value for the result of all forwarded messages.
  def self.setup_forwarding(options, apply_to:, return_value: '')
    method_defs = []
    options.each_pair do |key, value|
      Array(key).map do |command_name|
        method_defs.unshift Direction.message_handler(command_name, value, return_value)
      end
    end
    apply_to.class_eval method_defs.join(' '), __FILE__, __LINE__
  end

  # Forward messages and return self, protecting the encapsulation of the object
  def command(options)
    Direction.setup_forwarding(options, apply_to: self, return_value: 'self')
  end

  # Forward messages and return the result of the forwarded message
  def query(options)
    Direction.setup_forwarding(options, apply_to: self)
  end
end
