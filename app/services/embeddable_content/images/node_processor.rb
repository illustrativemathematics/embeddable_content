module EmbeddableContent
  module Images
    class NodeProcessor < EmbeddableContent::VisualElementNodeProcessor
      delegate :target, :image_catalog, to: :embedder
      delegate :attribution, :long_description, :label, :alt_text,
               to: :record

      def modal_dialog
        @modal_dialog = ModalDialog.new self
      end

      def img_tag_attrs
        @img_tag_attrs ||= ImgTagAttributes.new(self).to_h
      end

      TARGETS_THAT_DISPLAY_A_MODAL_DIALOG = %i[web].freeze
      def display_modal_dialog?
        TARGETS_THAT_DISPLAY_A_MODAL_DIALOG.include? target.to_sym
      end

      TARGETS_THAT_USE_DIV_TAGS    = %i[editable].freeze
      TARGETS_THAT_USE_FIGURE_TAGS = %i[cms print web exported qti cc].freeze
      def figure_tag
        case target
        when *TARGETS_THAT_USE_DIV_TAGS     then :div
        when *TARGETS_THAT_USE_FIGURE_TAGS  then :figure
        else raise "Undefined tag for target: #{target}"
        end
      end

      def node_can_be_removed?
        false
      end

      def node_selector_class
        [super, 'embedded-content-image'].join ' '
      end

      private

      def catalog_image
        image_catalog << record
      end

      def replace_node
        record.render_svg if svg_should_be_rendered?
        catalog_image     if image_should_be_catalogued?

        super
      end

      def svg_should_be_rendered?
        config.render_images?              &&
          record_model.requires_rendering? &&
          attachment_status_matters?       &&
          attachment_unavailable?
      end

      def attachment_unavailable?
        !attached_file.attached? ||
          !attachment_url_response_status_ok?
      end

      def attachment_url_response_status_ok?
        attachment_url_response.instance_of? Net::HTTPOK
      end

      def attachment_url_response
        @attachment_url_response ||= Net::HTTP.get_response storage_uri
      end

      def storage_uri
        @storage_uri ||= URI.parse storage_url
      end

      def attachment_status_matters?
        Rails.env.production? &&
          ENV['VERIFY_ATTACHMENT_STATUS'].eql?('true')
      end

      def image_should_be_catalogued?
        record.present? && attribution.present?
      end

      def route_keys
        %i[tikz_files image_files]
      end
    end
  end
end
