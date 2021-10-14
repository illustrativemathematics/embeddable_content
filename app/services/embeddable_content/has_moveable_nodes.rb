# frozen_string_literal: true

module EmbeddableContent
  module HasMoveableNodes
    CSS_CLASS_MOVEABLE_NODE_RELOCATED  = 'node-relocated-by-embedder'
    CSS_CLASS_MOVEABLE_NODES_RELOCATED = 'nodes-relocated-by-embedder'

    private

    def update_moveable_nodes?
      false
    end

    def update_moveable_nodes
      moveable_nodes.each { |node| update_moveable_node node }
      remove_affected_empty_nodes
    end

    def remove_affected_empty_nodes
      relocated_moveable_nodes.each { |node| node.remove if node.content.blank? }
    end

    def update_moveable_node(moveable_node)
      moveable_node.parent.tap do |parent_node|
        moveable_node.add_class CSS_CLASS_MOVEABLE_NODE_RELOCATED
        parent_node.add_class CSS_CLASS_MOVEABLE_NODES_RELOCATED
        relocate_moveable_node moveable_node
      end
    end

    def relocate_moveable_node(_moveable_node)
      raise 'define this method in including class'
    end

    def place_moveable_node_before_parent(moveable_node)
      moveable_node.parent.tap do |parent_node|
        parent_node.add_previous_sibling moveable_node
      end
    end

    def place_moveable_node_after_parent(moveable_node)
      moveable_node.parent.tap do |parent_node|
        parent_node.add_next_sibling moveable_node
      end
    end

    def moveable_nodes
      @moveable_nodes ||= document.css moveable_node_selector
    end

    def relocated_moveable_nodes
      @relocated_moveable_nodes ||= document.css(relocated_moveable_node_selector)
    end

    def relocated_moveable_node_selector
      @relocated_moveable_node_selector ||=
        "#{parent_node_selector}.#{CSS_CLASS_MOVEABLE_NODES_RELOCATED}"
    end

    DEFAULT_PARENT_NODE_SELECTOR = 'p'
    def parent_node_selector
      DEFAULT_PARENT_NODE_SELECTOR
    end

    def moveable_node_selector
      @moveable_node_selector ||= "#{parent_node_selector} > #{node_selector}"
    end
  end
end
