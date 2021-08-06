require 'open3'

module EmbeddableContent
  module Tex
    class SchoologyStringRenderer < BaseRenderer
      def target_format
        :schoology_string
      end

      def render_format(_format)
        Mathjax::SchoologyStringRenderer.new(html).render
      end
    end
  end
end
