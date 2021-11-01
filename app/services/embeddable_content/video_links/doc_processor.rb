module EmbeddableContent
  module VideoLinks
    class DocProcessor < EmbeddableContent::DocProcessor
      TARGETS_FOR_WHICH_NODES_ARE_UNMOVEABLE = %i[cms].freeze

      def update_moveable_nodes?
        TARGETS_FOR_WHICH_NODES_ARE_UNMOVEABLE.exclude? target
      end

      private

      def relocate_moveable_node(moveable_node)
        place_moveable_node_after_parent moveable_node
      end
    end
  end
end
