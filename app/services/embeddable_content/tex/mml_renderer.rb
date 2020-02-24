require 'open3'

module EmbeddableContent
  module Tex
    class MmlRenderer < BaseRenderer
      def target_format
        :mml
      end
    end
  end
end
