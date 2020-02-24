module EmbeddableContent
  class TokenReplacementMap
    attr_reader :target_pattern_map

    def initialize(target_pattern_map)
      @target_pattern_map = target_pattern_map
    end

    def target_regexp_map
      @target_regexp_map ||= build_target_regexp_map
    end

    private

    def build_target_regexp_map
      {}.tap do |regexp_map|
        target_pattern_map.each do |target, pattern_replacement_map|
          regexp_map[target] =
            convert_patterns_to_regexps pattern_replacement_map
        end
      end
    end

    def convert_patterns_to_regexps(pattern_replacement_map)
      {}.tap do |regexp_replacement_map|
        pattern_replacement_map.each do |pattern, replacement|
          regexp_replacement_map[Regexp.new(pattern)] = replacement
        end
      end
    end
  end
end
