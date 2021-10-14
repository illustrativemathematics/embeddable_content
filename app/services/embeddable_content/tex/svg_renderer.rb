require 'open3'

module EmbeddableContent
  module Tex
    class SvgRenderer < BaseRenderer
      private

      def rendered_node
        @rendered_node ||= emptied_math_span.then { |span| span << math_node }
      end

      def math_content
        svg
      end

      def base_replacement_span
        emptied_math_span
      end
    end
  end
end
