require 'hashie'

module Doonan
  class Scope < Hashie::Mash
    def self.variable_resolver
      @variable_resolver ||= begin
        require 'doonan/variable_resolver'
        VariableResolver.new
      end
    end

    def resolve_variables
      self.class.variable_resolver.resolve(self)
    end

    def result(template)
      template.result(binding)
    end
  end
end
