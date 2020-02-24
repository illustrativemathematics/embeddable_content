require 'open3'

module EmbeddableContent
  module Tex
    class SvgRenderer < BaseRenderer
      def target_format
        :svg
      end
    end
  end
end
