module EmbeddableContent
  module HtmlTags
    class NodeProcessor < EmbeddableContent::NodeProcessor
      include TemplateBased

      def data_rows
        @data_rows ||= list_data.each_slice(num_columns).to_a
      end

      def node_selector_class
        'embedded-unstructured-data'
      end

      private

      def list_data
        @list_data ||= node.css('li').map(&:text)
      end

      DEFAULT_NUM_COLUMNS = 8
      def num_columns
        DEFAULT_NUM_COLUMNS
      end
    end
  end
end
