require 'hashie'

module Doonan
  class VariableResolver
    VARIABLE = /\$[\w\.]+/
    STANDALONE_VARIABLE = /\A\$[\w\.]+\Z/
    LEADING_DOLLAR = /\A\$/

    # Any hash-like object passed in gets scanned for values
    # that start with a dollar sign. The structure will be examined to find a top level
    # key of the same name (without the dollar sign) the "$..." value will be replaced
    # with the value of the top-level key.
    def resolve(hash)
      transform_values(hash) do |value|
        check_and_resolve_variable(hash, value)
      end
    end

    private
    def check_and_resolve_variable(hash, value)
      if value.is_a? String
        if STANDALONE_VARIABLE =~ value
          resolve_variable(hash, value)
        else
          if VARIABLE =~ value
            value.gsub(VARIABLE) do |variable|
              resolve_variable(hash, variable, true)
            end
          else
            value
          end
        end
      else
        value
      end
    end

    def resolve_variable(hash, variable, gsub=false)
      variable_path = variable.sub(LEADING_DOLLAR,'').split('.')
      new_value = variable_path.inject(hash) do |hash, key|
        if hash && hash.respond_to?(:key?) && hash.key?(key)
          hash[key]
        else
          Doonan.logger.warn("Failed to resolve variable reference '#{variable_path.join('.')}'. Will not substitute.")
          return variable
        end
      end
      new_value = check_and_resolve_variable(hash, new_value)
      new_value = new_value.to_s if gsub
      new_value
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
