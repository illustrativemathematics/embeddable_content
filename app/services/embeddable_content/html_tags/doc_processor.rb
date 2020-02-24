module EmbeddableContent
  module HtmlTags
    class DocProcessor < EmbeddableContent::DocProcessor
      private

      def node_selector
        'ul.c-unstructured'
      end
    end
  end
end
