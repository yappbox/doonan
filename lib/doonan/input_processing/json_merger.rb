require 'json'

module Doonan
  module InputProcessing
    class JsonMerger
      def merge(json_path, merge_target)
        json = File.read(json_path)
        settings = JSON.parse(json)
        merge_target.merge(settings)
      end
    end
  end
end