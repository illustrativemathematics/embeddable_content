module EmbeddableContent
  module PresentationTags
    class NodeProcessor < EmbeddableContent::TreeBasedNodeProcessor
      include TemplateBased

      alias presentation_tag record

      def node_added_classes
        ['presentation-tag-classes-added',
         presentation_tag.added_class].join ' '
      end

      private

      delegate :template_based?, to: :presentation_tag

      def replace_node
        template_based? ? super : modify_parent
      end

      def modify_parent
        parent_node.add_class node_added_classes
        remove_node
      end

      def parent_node
        @parent_node ||= node.parent
      end

      def targets_that_require_processing
        %i[print]
      end
    end
  end
end
