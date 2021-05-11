# frozen_string_literal: true

module EmbeddableContent
  module Images
    class DocProcessor < EmbeddableContent::DocProcessor
      delegate :image_catalog, to: :embedder

      CLASS_IMG_TAG_RELOCATED = 'img-tag-relocated-by-embedder'

      private

      def pre_process
        move_img_tags_out_from_p_tags
      end

      def post_process
        attributions_processor.process!
      end

      def attributions_processor
        @attributions_processor ||=
          EmbeddableContent::Images::AttributionsProcessor.new self
      end

      def node_selector
        'img'
      end

      def move_img_tags_out_from_p_tags
        img_tags_inside_p_tags.each do |img_tag|
          move_img_tag_out_from_p_tag img_tag
        end
        remove_affected_empty_p_tags
      end

      def remove_affected_empty_p_tags
        document.css("p.#{CLASS_IMG_TAG_RELOCATED}").each do |p_tag|
          remove_if_empty p_tag
        end
      end

      def move_img_tag_out_from_p_tag(img_tag)
        img_tag.parent.tap do |p_tag|
          p_tag.add_previous_sibling img_tag
          p_tag.add_class CLASS_IMG_TAG_RELOCATED
        end
      end

      def img_tags_inside_p_tags
        @img_tags_inside_p_tags ||= document.css 'p > img'
      end
    end
  end
end
