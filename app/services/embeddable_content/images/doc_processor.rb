# frozen_string_literal: true

module EmbeddableContent
  module Images
    class DocProcessor < EmbeddableContent::DocProcessor
      delegate :image_catalog, to: :embedder

      private

      def update_moveable_nodes?
        true
      end

      def relocate_moveable_node(moveable_node)
        place_moveable_node_before_parent moveable_node
      end

      def post_process
        attributions_processor.process!
      end

      def attributions_processor
        @attributions_processor ||=
          EmbeddableContent::Images::AttributionsProcessor.new self
      end

      def node_selector
        'img'
      end
    end
  end
end
