module EmbeddableContent
  module Images
    class AttributionsProcessor
      attr_reader :image_processor

      delegate :embedder, :target, :document, :image_catalog, to: :image_processor
      delegate :locale, to: :embedder

      TARGETS_NEEDING_ATTRIBUTIONS = %i[print].freeze
      ATTRIBUTIONS_PARTIAL = 'export/shared/attributions_images'.freeze
      ATTRIBUTIONS_NODE_ID = 'image-attributions-node'.freeze
      ATTRIBUTIONS_NODE_SELECTOR = "div##{ATTRIBUTIONS_NODE_ID}".freeze

      def initialize(image_processor)
        @image_processor = image_processor
      end

      def process!
        render_attributions if attributions_required?
      end

      private

      def attributions_required?
        TARGETS_NEEDING_ATTRIBUTIONS.include?(target) &&
          attributions_node.present? &&
          image_catalog.present? &&
          attributions.present?
      end

      def attributions
        @attributions =
          image_catalog.select(&:attribution).compact
      end

      def attributions_node
        @attributions_node ||= document.css(ATTRIBUTIONS_NODE_SELECTOR).first
      end

      def render_attributions
        attributions_node.replace(attributions_fragment)
      end

      def attributions_html
        I18n.with_locale(locale) { render_html }
      end

      def render_html
        ApplicationController.renderer.render(
          partial: ATTRIBUTIONS_PARTIAL,
          locals:  { image_files: image_catalog }
        )
      end

      def attributions_fragment
        @attributions_fragment ||= Nokogiri::HTML.fragment(attributions_html)
      end
    end
  end
end
