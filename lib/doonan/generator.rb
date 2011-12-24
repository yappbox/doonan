module Doonan
  class Generator
    def initialize(templates_path)
      @templates_path = templates_path
      @scope_helper = Module.new
    end

    def helpers(*modules)
      @scope_helper.instance_eval { include *modules }
    end

    def generate(input_path, output_path, extensions)
      input = Doonan::Input.new(input_path)
      input.scope.extend @scope_helper
      session = Doonan::RenderSession.new(input, output_path, @templates_path, extensions)
      session.perform_generation
    end
  end
end
