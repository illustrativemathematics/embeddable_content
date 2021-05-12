module EmbeddableContent
  module Images
    class ModalDialog
      include Images::Shared

      attr_reader :node_processor

      delegate :record_css_id_for, :s3_ttl_service_url, :caption, :attribution,
               :alt_text, to: :node_processor

      def initialize(node_processor)
        @node_processor = node_processor
      end

      def img_tag_attrs
        { src:   s3_ttl_service_url,
          width: '80%',
          alt:   strip_tags(alt_text),
          role:  :image }
      end

      def attribution_display_text
        [attribution.owner_and_title_info,
         attribution.license.name,
         attribution.via_reference].join('. ').strip + '.'
      end

      def container_attrs
        { tabindex:           '-1',
          role:               'dialog',
          'aria-labelledby':  labelled_by_id,
          'aria-describedby': described_by_id,
          'aria-label':       'Image information' }
      end

      def target_attrs
        { 'id':          target_div_id,
          'hidden':      'true',
          'aria-hidden': 'true' }
      end

      def close_button_attrs
        { 'aria-hidden':  'true',
          height:         '18',
          width:          '18',
          viewBox:        '0 0 1200 1200' }
      end

      def description
        node_processor.long_description
      end

      def labelled_by_id
        record_css_id_for 'dialog-alt-text'
      end

      def described_by_id
        record_css_id_for 'dialog-long-description'
      end

      def target_div_id
        record_css_id_for 'modal-target'
      end

      def caption_id
        record_css_id_for 'dialog-caption'
      end

      def attribution_id
        record_css_id_for 'dialog-attribution'
      end
    end
  end
end
