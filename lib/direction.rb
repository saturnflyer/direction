require "direction/version"
# Provide a feature like the Forwardable library,
# but set the return value to self.
# It provides a class level "command" method to do
# message forwarding.
# 
# class SomeClass
#   extend Direction
# 
#   command [:name, :id] => :collaborator, [:color, :type] => :@partner
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
          def #{command_name}(*args, &block)
            #{value}.__send__(:#{command_name}, *args, &block)
            self
          end
        }
      end
    end
    self.class_eval method_defs.join(' '), __FILE__, __LINE__
  end
end
