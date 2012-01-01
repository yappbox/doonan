require 'hashie'

module Doonan
  class InputScope < Hashie::Mash
    def merge_json!(json)
      settings = JSON.parse(json)
      perform_substitutions(settings)
      merge!(settings)
    end
    
  private
  
    VARIABLE = /\$(\w+)/
    LEADING_DOLLAR = /\A\$/
    def perform_substitutions(settings)
      transform_values(settings) do |value|
        if value.is_a? String
          value.gsub(VARIABLE) do |name|
            variable_key = name.gsub(LEADING_DOLLAR,'')
            if settings.key?(variable_key)
              settings[name.gsub(LEADING_DOLLAR,'')]
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
    
    def transform_values(json_object, &block)
      json_object.each_pair do |key, value|
        json_object[key] = transform_value(value, &block)
      end
      json_object
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