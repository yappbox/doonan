module Doonan
  module CSSHelper
    CSS_PROPERTY = /\A[\w-]+\z/

    def o(property_or_format, value, condition=value)
      return unless condition
      if CSS_PROPERTY =~ property_or_format
        "#{property_or_format}: #{value};"
      else
        property_or_format % value
      end
    end
  end
end
