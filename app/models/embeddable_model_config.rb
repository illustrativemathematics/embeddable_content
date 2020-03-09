class EmbeddableModelConfig < ApplicationRecord
  IGNORED_ATTRIBUTES = %w[id created_at updated_at].freeze
  BOOLEAN_ATTRIBUTES =
    %w[tree_based?
       always_display_tag_indicator?
       embeddable_applet?
       embeddable_image?
       requires_rendering?].freeze

  def self.ckeditor_config
    pluck :embeddable_tag_selector, :ckeditor_allowed_content
  end

  def self.ckeditor_allowed_content_rules
    ckeditor_config.map do |selector, content|
      [selector, content]
    end.to_h
  end

  def self.attributes
    @attributes ||= (attribute_names -
                     IGNORED_ATTRIBUTES +
                     BOOLEAN_ATTRIBUTES).map(&:to_sym)
  end

  def self.all_embeddable_models
    all.map(&:embeddable_model)
  end

  def self.embeddable_image_models
    where(embeddable_image: true).map(&:embeddable_model)
  end

  def self.embeddable_applet_models
    where(embeddable_applet: true).map(&:embeddable_model)
  end

  def self.embeddable_tree_based_models
    where(tree_based: true).map(&:embeddable_model)
  end

  def self.for_model(embeddable_model)
    find_by! embeddable_model_name: embeddable_model.model_name.name
  end

  def embeddable_model
    embeddable_model_name.constantize
  end

  def styled_indicator_selector(tree_node: nil)
    return embeddable_tag_name unless tree_based? && tree_node.present?

    "#{embeddable_tag_name}[data-tree-ref-id=\"#{tree_node.ref_id}\"]".html_safe
  end
end
