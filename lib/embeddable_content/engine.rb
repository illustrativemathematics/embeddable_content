module EmbeddableContent
  class Engine < ::Rails::Engine
    config.eager_load_paths <<
      File.expand_path('../../db/embeddable_content', __dir__)
    config.assets.precompile += %w[embeddable_content/geogebra/support.js
                                   embeddable_content/desmos/support.js]
  end
end
