module Doonan
  class Generator
    def initialize(templates_path)
      @templates_path = templates_path
    end

    def generate(input_path, output_path, extensions)
      input = Doonan::Input.new(input_path)
      session = Doonan::RenderSession.new(input, output_path, @templates_path, extensions)
      session.perform_generation
    end
  end
end
