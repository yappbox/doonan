require 'hashie'

module Doonan
  module InputProcessing
    class VariableResolver
      # Any hash-like object passed in gets scanned for values
      # that start with a dollar sign. The structure will be examined to find a top level
      # key of the same name (without the dollar sign) the "$..." value will be replaced
      # with the value of the top-level key.
      def resolve(hash)
        result = hash.clone
        perform_substitutions(result)
        result
      end
    
    private
  
      VARIABLE = /\$(\w+)/
      LEADING_DOLLAR = /\A\$/
      def perform_substitutions(hash)
        transform_values(hash) do |value|
          if value.is_a? String
            value.gsub(VARIABLE) do |name|
              variable_key = name.gsub(LEADING_DOLLAR,'')
              if hash.key?(variable_key)
                hash[name.gsub(LEADING_DOLLAR,'')]
              else
                Doonan.logger.warn("Missing variable referenced '#{value}'. Will not substitute.")
                value
              end
            end
          else
            value
          end
        end
      end
    
      def transform_values(hash, &block)
        hash.each_pair do |key, value|
          hash[key] = transform_value(value, &block)
        end
        hash
      end

      def transform_value(value, &block)
        case value
        when Hash
          transform_values(value, &block)
        when Array
          value.each_with_index {|v, i| value[i] = transform_value(v, &block) }
          value
        else
          yield value
        end
      end
    end
  end
end