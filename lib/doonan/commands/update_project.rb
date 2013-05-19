module Doonan
  module Commands
    class UpdateProject
      def initialize(config)
        @config = config
      end

      attr_accessor :config

      def perform
        pipeline = Pipeline.new(config)
        pipeline.realize
      end
    end
  end
end
