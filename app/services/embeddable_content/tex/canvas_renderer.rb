require 'open3'

module EmbeddableContent
  module Tex
    class CanvasRenderer < BaseRenderer
      def target_format
        :canvas
      end

      def render
        html.replace Mathjax::CanvasRenderer.new(html).render
      end
    end
  end
end
