module EmbeddableContent
  class Engine < ::Rails::Engine
    config.eager_load_paths <<
      File.expand_path('../../db/embeddable_content', __dir__)
  end
end
