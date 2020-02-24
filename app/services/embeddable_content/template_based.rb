module EmbeddableContent
  module TemplateBased
    delegate :replacement_node, to: :template_manager

    def node_type
      @node_type ||= embedding_module.underscore
    end

    private

    def replace_node
      node.replace replacement_node
    end

    def template_manager_class
      ReplacementTemplateManager
    end
  end
end
