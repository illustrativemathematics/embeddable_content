module EmbeddableContent
  module PresentationTags
    class NodeProcessor < EmbeddableContent::TreeBasedNodeProcessor
      alias presentation_tag record

      private

      def replace_node
        parent_node.add_class added_classes
        remove_node
      end

      def parent_node
        @parent_node ||= node.parent
      end

      def added_classes
        ['presentation-tag-classes-added',
         presentation_tag.added_class].join ' '
      end

      def targets_that_require_processing
        %i[print]
      end
    end
  end
end
