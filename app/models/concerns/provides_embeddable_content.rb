module ProvidesEmbeddableContent
  extend ActiveSupport::Concern
  include ActionView::Helpers::TagHelper

  class_methods do
    def embeddable_model_config
      @embeddable_model_config ||= EmbeddableModelConfig.for_model self
    end

    delegate(*EmbeddableModelConfig.attributes, to: :embeddable_model_config)
  end

  included do
    validates :title, presence: true
    delegate(*EmbeddableModelConfig.attributes, to: self)
  end

  def embeddable_tag_extension
    try(:file).try(:filename).try(:extension) || embeddable_tag_ext
  end

  def embeddable_tag(opts = {})
    convert_safe_buffer_to_string tag(embeddable_tag_name, embeddable_tag_attrs(opts))
  end

  def template_based?
    defined?(super) ? super : false
  end

  private

  def convert_safe_buffer_to_string(safe_buffer)
    safe_buffer.to_str
  end

  def embeddable_tag_attrs(opts)
    { src:  "/#{model_name.route_key}/#{id}.#{embeddable_tag_extension}",
      data: data_attributes(opts) }.compact
  end

  def data_attributes(opts)
    return unless tree_based?

    tree_based_data_attributes opts
  end

  def tree_based_data_attributes(opts)
    tree_node    = opts[:tree_node]
    tree_node_id = tree_node&.id ||
                   EmbeddableContent::TREE_EMBEDDER_ID_PLACEHOLDER
    tree_ref_id  = tree_node&.ref_id ||
                   EmbeddableContent::TREE_EMBEDDER_ID_PLACEHOLDER
    tree_code    = Tree.where(id: tree_ref_id)&.pluck(:code)&.first
    { tree_ref_id:  tree_ref_id,
      tree_node_id: tree_node_id,
      tree_code:    tree_code,
      tag_title:    title }.compact
  end
end
