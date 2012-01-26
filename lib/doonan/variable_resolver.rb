require 'hashie'

module Doonan
  class VariableResolver
    VARIABLE = /\$(\w+)/
    LEADING_DOLLAR = /\A\$/

    # Any hash-like object passed in gets scanned for values
    # that start with a dollar sign. The structure will be examined to find a top level
    # key of the same name (without the dollar sign) the "$..." value will be replaced
    # with the value of the top-level key.
    def resolve(hash)
      transform_values(hash) do |value|
        if value.is_a? String
          value.gsub(VARIABLE) do |name|
            variable_key = name.sub(LEADING_DOLLAR,'')
            if hash.key?(variable_key)
              hash[variable_key]
            else
              Doonan.logger.warn("Missing variable '#{variable_key}' referenced by '#{value}'. Will not substitute.")
              name
            end
          end
        else
          value
        end
      end
    end

    private
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
