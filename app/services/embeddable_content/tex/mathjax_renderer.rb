module EmbeddableContent
  module Tex
    class MathjaxRenderer < BaseRenderer
      def target_format
        nil
      end

      def math_content
        mathjax
      end

      def replacement_css_classes
        'math'
      end
    end
  end
end
