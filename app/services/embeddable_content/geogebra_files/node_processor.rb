module EmbeddableContent
  module GeogebraFiles
    class NodeProcessor < EmbeddableContent::RecordNodeProcessor
      include TemplateBased

      def data_parameters
        @data_parameters ||= record.full_configuration.to_json
      end
    end
  end
end
