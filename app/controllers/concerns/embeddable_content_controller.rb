module EmbeddableContentController
  extend ActiveSupport::Concern

  class_methods do
    def embed_content_for(* actions)
      whitelisted_embedder_actions.replace actions
    end

    def do_not_embed_content_for(* actions)
      blacklisted_embedder_actions.replace actions
    end
  end

  included do
    class_attribute :whitelisted_embedder_actions, default: []
    class_attribute :blacklisted_embedder_actions, default: []

    after_action :embed_content
  end

  private

  def handle_unknown_format_error
    embed_content
  end

  def embed_content
    render_embedded_content if embedder_required_for_action?
  end

  def render_embedded_content
    render_html
  end

  def render_html
    response.body = embedded_html
  end

  def embedder_required_for_action?
    embedder_required_by_default? || embedder_action_whitelisted?
  end

  def embedder_required_by_default?
    !embedder_action_blacklisted? && whitelisted_embedder_actions.empty?
  end

  def embedder_action_whitelisted?
    whitelisted_embedder_actions.map(&:to_s).include? action_name
  end

  def embedder_action_blacklisted?
    blacklisted_embedder_actions.map(&:to_s).include? action_name
  end

  def embedded_html
    @embedded_html ||= embedder.embed_content! raw_html
  end

  def raw_html
    @raw_html ||= response.body.presence || render_raw_html
  end

  def requested_format
    request.format.to_sym
  end

  def render_raw_html
    raise 'Define this method for blank response body (e.g., docx)'
  end

  def embedder
    @embedder ||= create_embedder
  end

  def create_embedder
    raise_missing_target if embedder_target.blank?

    EmbeddableContent::Embedder.new embedder_target
  end

  def raise_missing_target
    raise "No embedder target defined for action '#{action_name}'" \
          " and format '#{requested_format}'"
  end
end
