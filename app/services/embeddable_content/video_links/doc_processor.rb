module EmbeddableContent
  module VideoLinks
    class DocProcessor < EmbeddableContent::DocProcessor
      def update_moveable_nodes?
        true
      end

      private

      def relocate_moveable_node(moveable_node)
        place_moveable_node_after_parent moveable_node
      end
    end
  end
end
