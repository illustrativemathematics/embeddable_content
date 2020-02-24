module EmbeddableContent
  module VideoLinks
    module VimeoPlayerSettings
      VIMEO_URL_REGEX = %r{\Ahttps:\/\/player\.vimeo\.com\/video\/\d+\z}.freeze
      DEFAULT_VIMEO_ATTRIBUTES = {
        width:                   '640',
        height:                  '360',
        frameborder:               '0',
        allowfullscreen:        'true',
        mozillaallowfullscreen: 'true',
        safariallowfullscreen:  'true'
      }.freeze

      def vimeo_attributes
        DEFAULT_VIMEO_ATTRIBUTES.merge src: url
      end
    end
  end
end
