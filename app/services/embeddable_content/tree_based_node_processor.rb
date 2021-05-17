module EmbeddableContent
  class TreeBasedNodeProcessor < EmbeddableContent::RecordNodeProcessor
    EMBBEDER_TAG_TREE_ID_ATTRIBUTE = 'data-tree-ref-id'.freeze

    private

    def node_should_be_replaced?
      super && tag_references_current_tree?
    end

    def tag_references_current_tree?
      embedded_tag_tree_id == tree_embedder_tag_id
    end

    def embedded_tag_tree_id
      node[EMBBEDER_TAG_TREE_ID_ATTRIBUTE]
    end

    def tree_embedder_tag_id
      tree_node&.embedder_tag_id
    end
  end
end
