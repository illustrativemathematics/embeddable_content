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
        template_based? ? place_node : modify_parent
      end

      def place_node
        if node_in_p_tag?
          add_empty_p_tag_for_pre_mjpage_compatibility
          place_node_after_parent_node
        else
          place_node_within_parent_node
        end
        remove_node
        true
      end

      def place_node_after_parent_node
        parent_node.add_next_sibling replacement_node
      end

      def place_node_within_parent_node
        parent_node << replacement_node
      end

      def add_empty_p_tag_for_pre_mjpage_compatibility
        parent_node
          .add_next_sibling '<p class="empty-p-tag-added-for-pre-mjpage-compatability"></p>'
      end

      def node_in_p_tag?
        parent_node&.name == 'p'
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
