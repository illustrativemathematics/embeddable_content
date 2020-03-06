if Rails.env.test?
  [Embedding, EmbedderConfig, EmbeddableModelConfig].each do |model|
    model.destroy_all
    Pathname.new(File.expand_path('./', __dir__)).tap do |dir|
      dir.join(model.model_name.plural).sub_ext('.json').tap do |file|
        JSON.parse(file.read).each do |attrs|
          model.create attrs
        end
      end
    end
  end
end
