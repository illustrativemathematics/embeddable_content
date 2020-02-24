module EmbeddableContent
  module Images
    class ImageDownloader
      attr_reader :attached_image

      delegate :to_path, to: :image_file

      def initialize(attached_image)
        @attached_image = attached_image
      end

      def save
        image_file.tap { |file| file.write raw_image_data }
      end

      def delete
        image_file.delete if image_file.exist?
      end

      def raw_svg
        @raw_svg ||= downloaded_image_data if svg_attached?
      end

      private

      TMP_IMAGE_DIR = Rails.root.join('tmp').freeze

      def image_file
        @image_file ||= TMP_IMAGE_DIR.join filename
      end

      def raw_image_data
        png_rendered_from_svg || downloaded_image_data
      end

      def png_rendered_from_svg
        Script::SvgToPng.new(downloaded_image_data).to_png if svg_attached?
      end

      def downloaded_image_data
        @downloaded_image_data ||=
          attached_image.download.force_encoding 'utf-8'
      end

      def filename
        @filename ||= "embedder-#{Time.now.to_f}.#{extension}"
      end

      def extension
        @extension ||=
          svg_attached? ? 'png' : attached_image.filename.extension
      end

      CONTENT_TYPE_SVG = 'image/svg+xml'.freeze
      def svg_attached?
        attached_image.content_type.eql? CONTENT_TYPE_SVG
      end
    end
  end
end
