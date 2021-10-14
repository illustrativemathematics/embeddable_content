require 'open3'

module EmbeddableContent
  module Tex
    class MmlRenderer < BaseRenderer
      private

      def alttext
        displaystyle? ? tex_string.gsub('\\displaystyle', '').strip : tex_string
      end

      # TODO: update this once embedder specs working
      def replacement_css_classes
        @replacement_css_classes ||=
          displaystyle? ? 'mjpage mjpage__block' : 'mjpage'
      end

      def math_content
        mml
      end

      def math_node
        super.tap do |node|
          node['display'] = 'block' if displaystyle?
          node['alttext'] = alttext
        end
      end
    end
  end
end
