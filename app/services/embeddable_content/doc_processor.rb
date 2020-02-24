module EmbeddableContent
  class DocProcessor < EmbedderBase
    PROCESS_NODES_BY_DEFAULT = true

    attr_reader :embedder

    delegate :document, :html, :rebuild_document, to: :embedder
    delegate :selector, :process_target?, to: :embedding

    def initialize(embedder)
      @embedder = embedder
      super embedder.config
    end

    def process!
      return unless process_target?(target)

      pre_process
      process_matching_nodes if process_nodes?
      post_process
      refresh_html
    end

    def embedding
      @embedding ||= Embedding.find_by processor_module: embedding_module
    end

    private

    def refresh_html
      html.replace document.to_s
    end

    def pre_process; end

    def process_matching_nodes
      matching_nodes.each.with_index(1) { |node, idx| process_node(node, idx) }
    end

    def post_process; end

    def process_nodes?
      PROCESS_NODES_BY_DEFAULT
    end

    def process_node(node, node_index)
      node_processor_factory.new(self, node, node_index).process!
    end

    def node_selector
      @node_selector ||= embedding_module.underscore.dasherize.singularize
    end

    def matching_nodes
      @matching_nodes ||= document.css node_selector
    end

    def node_processor_factory
      @node_processor_factory ||=
        "#{module_name}::NodeProcessor".constantize
    end
  end
end
