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
  def command(options)
    method_defs = []
    options.each_pair do |key, value|
      Array(key).map do |command_name|
        method_defs.unshift %{
          def #{command_name}(*args)
            if block_given?
              #{value}.__send__(:#{command_name}, *args) { |*block_args| yield(*block_args) }
            else
              #{value}.__send__(:#{command_name}, *args)
            end
            self
          end
        }
      end
    end
    self.class_eval method_defs.join(' '), __FILE__, __LINE__
  end

  def query(options)
    method_defs = []
    options.each_pair do |key, value|
      Array(key).map do |command_name|
        method_defs.unshift %{
          def #{command_name}(*args, &block)
            if block_given?
              #{value}.__send__(:#{command_name}, *args) { |*block_args| yield(*block_args) }
            else
              #{value}.__send__(:#{command_name}, *args)
            end
          end
        }
      end
    end
    self.class_eval method_defs.join(' '), __FILE__, __LINE__
  end
end
