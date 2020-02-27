module EmbeddableContent
  module Images
    class ImgTagAttributes
      include Images::Shared

      attr_reader :node_processor

      delegate :alt_text, :attached_file, :record,
               :cms_url, :s3_url, :storage_url, :target,
               :node,    to: :node_processor
      delegate :image,   to: :record
      delegate :raw_svg, to: :image_downloader

      def initialize(node_processor)
        @node_processor = node_processor
      end

      def to_h
        { alt:    strip_tags(alt_text),
          role:   :image,
          src:    src,
          height: height,
          class:  css_classes,
          width:  width }.compact
      end

      def src
        case target
        when :cc             then s3_url(with_extension: true)
        when :cms            then cms_url
        when :editable       then downloaded_file_url
        when :exported, :qti then s3_url
        when :print, :web    then storage_url
        end
      end

      def width
        case target
        when :editable then width_for_editable_target
        when :cc, :qti then image_width
        end
      end

      def height
        case target
        when :editable then height_for_editable_target
        when :cc, :qti then image_height
        end
      end

      private

      def css_classes
        node.classes.any? ? node.classes.join(' ') : nil
      end

      def svg_image?
        image.attached? && image.content_type == 'image/svg+xml'
      end

      def use_original_svg_dimensions_for_converted_png_file?
        svg_image? && svg_document.present?
      end

      def downloaded_file_url
        downloaded_image.to_path
      end

      def downloaded_image
        @downloaded_image ||= image_downloader.save
      end

      def image_downloader
        @image_downloader ||= ImageDownloader.new attached_file
      end

      def height_for_editable_target
        svg_height if use_original_svg_dimensions_for_converted_png_file?
      end

      def width_for_editable_target
        svg_width if use_original_svg_dimensions_for_converted_png_file?
      end

      def svg_width
        svg_document.root['width'] if svg_available?
      end

      def svg_height
        svg_document.root['height'] if svg_available?
      end

      def svg_available?
        svg_image? && svg_document.present?
      end

      def svg_document
        @svg_document ||= Nokogiri::XML.parse raw_svg if raw_svg.present?
      end

      def image_width
        image_dimensions[1]
      end

      def image_height
        image_dimensions[2]
      end

      IMAGE_DIMENSION_SCRIPT = %(identify -ping -format "%[w]x%[h]").freeze
      IMAGE_DIMENSION_REGEX  = /(\d+)x(\d+)/.freeze

      def run_image_dimension_script
        `#{IMAGE_DIMENSION_SCRIPT} #{downloaded_file_url}`
      end

      def image_dimensions
        @image_dimensions ||=
          run_image_dimension_script.match IMAGE_DIMENSION_REGEX
      end
    end
  end
end
