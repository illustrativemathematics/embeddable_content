module EmbeddableContent
  class NodeProcessor < EmbedderBase
    NODE_CAN_BE_REMOVED_BY_DEFAULT   = true
    SELECTOR_CLASS_BLANK_BY_DEFAULT  = nil
    RECORD_BLANK_BY_DEFAULT          = nil
    ALL_TARGETS_PROCESSED_BY_DEFAULT = EmbedderConfig::ALL_TARGETS
    DEFAULT_TEMPLATE_MANAGER_CLASS   = TemplateManager
    ADDED_CLASSES_BLANK_BY_DEFAULT   = [].freeze

    attr_reader :node, :node_index, :doc_processor, :error

    delegate :embedder,     to: :doc_processor
    delegate :warning_node, to: :template_manager

    def initialize(doc_processor, node, node_index)
      @doc_processor  = doc_processor
      @node           = node
      @node_index     = node_index
      super embedder.config, embedder.options
    end

    def process!
      process_node || remove_node
    rescue StandardError => e
      @error = e
      node.replace warning_node
    end

    def node_selector_class
      SELECTOR_CLASS_BLANK_BY_DEFAULT
    end

    def node_added_classes
      ADDED_CLASSES_BLANK_BY_DEFAULT
    end

    def record
      RECORD_BLANK_BY_DEFAULT
    end

    private

    def process_node
      replace_node if node_should_be_replaced?
    end

    def node_should_be_replaced?
      targets_that_require_processing.include? target
    end

    def targets_that_require_processing
      ALL_TARGETS_PROCESSED_BY_DEFAULT
    end

    def replace_node
      raise 'implement in a subclass'
    end

    def remove_node
      node.remove if node_can_be_removed?
    end

    def node_can_be_removed?
      NODE_CAN_BE_REMOVED_BY_DEFAULT
    end

    def template_manager
      @template_manager ||= template_manager_class.new self
    end

    def template_manager_class
      DEFAULT_TEMPLATE_MANAGER_CLASS
    end
  end
end
