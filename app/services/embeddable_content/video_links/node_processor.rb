module EmbeddableContent
  module VideoLinks
    class NodeProcessor < EmbeddableContent::VisualElementNodeProcessor
      include VimeoPlayerSettings

      delegate :url, to: :record

      def video_player
        case url
        when VIMEO_URL_REGEX then :vimeo_player
        else raise "Unrecognized video player for URL: #{url}"
        end
      end

      PLAYER_PRESENTATION_TARGETS      = %i[cc cms exported qti web].freeze
      DESCRIPTION_PRESENTATION_TARGETS = %i[editable print].freeze
      def presentation
        case target
        when *PLAYER_PRESENTATION_TARGETS      then :video_player
        when *DESCRIPTION_PRESENTATION_TARGETS then :description
        else raise "Undefined video presentation for target: #{target}"
        end
      end

      CAPTIONED_TARGETS   = %i[cc cms qti web].freeze
      UNCAPTIONED_TARGETS = %i[editable exported print].freeze
      def display_caption?
        case target
        when *CAPTIONED_TARGETS   then true
        when *UNCAPTIONED_TARGETS then false
        else raise "Undefined caption status for target: #{target}"
        end
      end

      def video_availability_text
        "Video '#{title}' available here: #{url}."
      end
    end
  end
end
