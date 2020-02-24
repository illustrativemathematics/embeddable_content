module EmbeddableContent
  module Tex
    class DocProcessor < EmbeddableContent::DocProcessor
      REPAIRED_MATH_CSS_CLASS    = 'math-repaired'.freeze
      REPAIRED_MATH_CSS_SELECTOR = ".#{REPAIRED_MATH_CSS_CLASS}".freeze

      delegate :remove_repaired_math_spans?, to: :embedder

      private

      def process_nodes?
        remove_repaired_math_spans?
      end

      def process_node(node, _node_index)
        remove_repaired_math_span node
      end

      def remove_repaired_math_span(node)
        node.replace node.content
      end

      def post_process
        refresh_html
        render_tex
        fix_mml_fragments if fix_mml_fragments?
        rebuild_document
      end

      def node_selector
        REPAIRED_MATH_CSS_SELECTOR
      end

      def repaired_math_nodes
        @repaired_math_nodes ||= document.css(REPAIRED_MATH_CSS_SELECTOR)
      end

      def render_tex
        tex_renderer.new(html).render
      end

      def fix_mml_fragments?
        embedder.fragment? && embedder.xml?
      end

      def fix_mml_fragments
        html.replace Nokogiri::HTML(html).at('body').children.to_xml
      end

      def tex_renderer
        "#{module_name}::#{tex_output_format.classify}Renderer".constantize
      end
    end
  end
end
