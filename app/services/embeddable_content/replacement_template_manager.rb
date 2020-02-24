module EmbeddableContent
  class ReplacementTemplateManager < TemplateManager
    def replacement_node
      render_target || warning_node
    end

    private

    def node_templates_subdir
      @node_templates_subdir ||= node_type.underscore
    end

    def node_templates_path
      @node_templates_path ||= templates_dir.join node_templates_subdir
    end

    def target_path
      @target_path ||= node_templates_path.join target.to_s
    end
  end
end
