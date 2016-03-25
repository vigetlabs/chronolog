module Chronolog
  module Differ
    class << self
      def diff(original, current)
        (original.keys | current.keys).sort.inject({}) do |diff, key|
          if original[key] != current[key]
            if original[key].is_a?(Array) && current[key].is_a?(Array)
              diff[key] = [original[key] - current[key], current[key] - original[key]]
            else
              diff[key] = [original[key], current[key]]
            end
          end

          diff
        end
      end
    end
  end
end
