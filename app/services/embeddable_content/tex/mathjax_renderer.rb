require 'open3'

module EmbeddableContent
  module Tex
    class MathjaxRenderer < BaseRenderer
      def target_format
        nil
      end
    end
  end
end
