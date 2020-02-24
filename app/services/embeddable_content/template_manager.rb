module EmbeddableContent
  class TemplateManager < EmbedderBase
    DEFAULT_NUM_BACKTRACE_LINES    = 100
    NUM_BACKTRACE_LINES            =
      ENV.fetch('NUM_BACKTRACE_LINES', DEFAULT_NUM_BACKTRACE_LINES).try :to_i

    attr_reader :node_processor

    delegate :record, :node, :node_type, :error, :node_selector_class,
             :node_index,
             to: :node_processor

    def initialize(node_processor)
      @node_processor = node_processor
      super node_processor.config, node_processor.options
    end

    def warning_node
      render_path warning_node_path
    end

    def selected_backtrace_lines
      return if error.nil?

      error.backtrace.first(NUM_BACKTRACE_LINES).join "\n"
    end

    def node_attrs
      @node_attrs ||= { class: node_classes,
                        data:  node_data }.compact
    end

    def target_attrs
      @target_attrs ||= { id: node_id }.compact
    end

    def node_id
      return if record.nil?

      "#{record_model}-#{record.id}-#{node_index}"
    end

    private

    def node_data
      @node_data ||= { 'embedder-target': target }.merge record_node_data
    end

    def record_node_data
      return {} if record.nil?

      { 'record-model': record_model,
        'record-id':    record.id }
    end

    def record_model
      return if record.nil?

      @record_model ||= record.model_name.name
    end

    def node_classes
      ['embedded-content', node_selector_class].compact
    end

    def render_target
      render_path target_path
    end

    def render_path(path)
      ApplicationController.render rendering_options_for path
    rescue ActionView::MissingTemplate
      nil
    end

    def rendering_options_for(path)
      { assigns: assigns, template: path, layout: false }
    end

    def assigns
      { template_manager: self }
    end

    def warning_node_path
      @warning_node_path ||=
        status_template_path('warning').tap { |p| Rails.logger.debug "******* warning_node_path: #{p}" }
    end

    def status_template_path(status)
      status_dir.join status
    end

    def status_dir
      @status_dir ||= templates_dir.join 'status'
    end

    def templates_dir
      @templates_dir ||= Pathname.new('embeddable_content').join('replacements').tap { |p| Rails.logger.debug "******* templates_dir: #{p}" }
    end
  end
end
