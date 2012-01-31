module Doonan
  module Logging
    module_function
    [:fatal, :error, :warn, :info, :debug].each do |level|
      module_eval <<-END
        def #{level}(progname = nil, &block)
          ::Doonan.logger.#{level}(progname, &block)
        end
      END
    end
  end
end
