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
#
#   def_command :collaborator, :print_details, :aliased_name_for_print_details
# end
# 
# This will define methods on instances that forward to the
# provided receiver while enforcing encapsulation of the 
# relationship between objects.
module Direction
  def self.extended(base)
    base.extend Forwardable
  end

  # Forward messages and return self, protecting the encapsulation of the object
  def command(**options)
    options.each do |methods, accessor|
      methods.each { |method_name| def_command accessor, method_name }
    end
  end

  # Create an individual command with an optional alias
  def def_command accessor, method_name, aliased_method_name = method_name
    result_name = "#{aliased_method_name}_result"
    def_delegator accessor, method_name, result_name
    private result_name
    define_method aliased_method_name do |*args, **kwargs, &block|
      send(result_name, *args, **kwargs, &block)
      self
    end
  end

  # Forward messages and return the result of the forwarded message
  def query(**options)
    instance_delegate options
  end
end
