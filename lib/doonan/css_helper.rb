module CSSHelper
  CSS_PROPERTY = /\A[\w-]+\z/
  module_function
  def o(property_or_format, value)
    return unless value
    if CSS_PROPERTY =~ property_or_format
      "#{property_or_format}: #{value};"
    else
      property_or_format % value
    end
  end
end
