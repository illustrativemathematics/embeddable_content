module EmbeddableContent
  module Images
    module Shared
      private

      def strip_tags(html)
        Nokogiri::HTML.fragment(html).text.strip
      end
    end
  end
end
