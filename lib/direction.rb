# frozen_string_literal: true

require "forwardable"
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

  # Names that are safe to splice into generated source: plain identifiers,
  # optionally ending in "?" or "!" (predicate/bang). Setters, operators and
  # anything more exotic fall back to define_method below.
  SAFE_METHOD_NAME = /\A[a-zA-Z_][a-zA-Z0-9_]*[?!]?\z/
  SAFE_IVAR_NAME = /\A@[a-zA-Z_][a-zA-Z0-9_]*\z/
  private_constant :SAFE_METHOD_NAME, :SAFE_IVAR_NAME

  # Forward messages and return self, protecting the encapsulation of the object
  def command(**options)
    options.each do |methods, accessor|
      methods.each { |method_name| def_command accessor, method_name }
    end
  end

  # Create an individual command with an optional alias
  #
  # Whenever the accessor and method names are ordinary identifiers we generate
  # the forwarding method as source so that argument forwarding (...) avoids
  # allocating an args Array, a kwargs Hash and a block Proc on every call, and
  # so the receiver lookup and forwarded send resolve to plain, inline-cacheable
  # calls (friendly to Object Shapes and YJIT) rather than dynamic __send__.
  #
  # Method names that aren't plain identifiers -- setter (value=) or operator
  # methods -- fall back to define_method so they remain supported.
  def def_command accessor, method_name, aliased_method_name = method_name
    receiver = accessor.to_s
    ivar = receiver.start_with?("@")
    accessor_safe = ivar ? SAFE_IVAR_NAME.match?(receiver) : SAFE_METHOD_NAME.match?(receiver)

    if accessor_safe && SAFE_METHOD_NAME.match?(method_name.to_s) && SAFE_METHOD_NAME.match?(aliased_method_name.to_s)
      module_eval <<~RUBY, __FILE__, __LINE__ + 1
        def #{aliased_method_name}(...)
          #{receiver}.#{method_name}(...)
          self
        end
      RUBY
    else
      define_method aliased_method_name do |*args, **kwargs, &block|
        target = ivar ? instance_variable_get(accessor) : __send__(accessor)
        target.__send__(method_name, *args, **kwargs, &block)
        self
      end
    end
  end

  # Forward messages and return the result of the forwarded message
  def query(**options)
    instance_delegate options
  end
end
