module Cms
  module EmbeddableContentController
    extend  ActiveSupport::Concern
    include ::EmbeddableContentController

    included do
      embed_content_for :show
    end

    def embedder_target
      :cms
    end
  end
end
