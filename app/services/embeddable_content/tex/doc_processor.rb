module EmbeddableContent
  module Tex
    class DocProcessor < EmbeddableContent::DocProcessor
      delegate :remove_repaired_math_spans?, :tex_output_format,
               to: :embedder

      private

      def process_node(node, _node_index)
        tex_renderer_for_node(node).render
      end

      # TODO: resolve this --- still needed?
      def remove_repaired_math_span(node)
        # node.replace node.content
      end

      def node_selector
        Mathjax::Config::MATH_SPAN_SELECTOR
      end

      def tex_renderer_for_node(node)
        tex_renderer_class.new node, document
      end

      def tex_renderer_class
        @tex_renderer_class ||=
          "#{module_name}::#{tex_output_format.classify}Renderer".constantize
      end
    end
  end
end
