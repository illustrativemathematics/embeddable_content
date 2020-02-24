require 'open3'

module EmbeddableContent
  module Tex
    class BaseRenderer
      RENDER_TEX_JS_PATH = Pathname.new('lib').join 'tasks/render_tex.js'

      attr_reader :html

      def initialize(html)
        @html = html
      end

      def render
        html.replace render_format(target_format) if target_format.present?
      end

      private

      def render_format(format)
        output, status = Open3.capture2(render_tex(format), stdin_data: html)
        return output if status.success?

        Rails.logger.warn "Error calling #{render_tex(format)}: #{status}"
        html
      end

      def render_tex(format)
        [RENDER_TEX_JS_PATH, '--output', format].join(' ')
      end
    end
  end
end
