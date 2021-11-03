module EmbeddableContent
  module Tex
    class MmlRenderer < BaseRenderer
      private

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
          node['alttext'] = unadorned_tex_string
        end
      end
    end
  end
end
