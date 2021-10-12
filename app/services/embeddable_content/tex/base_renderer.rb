require 'open3'

module EmbeddableContent
  module Tex
    class RenderError < StandardError
      attr_reader :script, :stderr, :status

      def initialize(script, stderr, status, api_errors)
        @script = script
        @stderr = stderr
        @status = status
        super "Unable to resolve error raised calling #{script}: #{status}\n#{stderr}\n#{api_errors}"
      end
    end

    class BaseRenderer
      RENDER_TEX_JS_PATH = Pathname.new('lib').join 'tasks/render_tex.js'

      attr_reader :html, :stdout, :stderr, :status

      def initialize(html)
        @html = html
      end

      def render
        return html unless rendering_required?

        run_script
      end

      private

      def rendering_required?
        not_yet_rendered? && target_format.present?
      end

      def not_yet_rendered?
        status.blank?
      end

      def render_failed?
        failed_status || stderr.present?
      end

      def failed_status
        status.present? && !status.success?
      end

      def render_error
        @render_error ||= RenderError.new script, stderr, status, api_errors
      end

      def run_script
        @run_script ||= Open3.capture3(script, stdin_data: html).tap do |stdout, stderr, status|
          @stdout = stdout
          @stderr = stderr
          @status = status
        end
        render_failed? ? try_api_client : html.replace(stdout)
      end

      def script
        @script ||= [RENDER_TEX_JS_PATH, '--output', target_format].join(' ')
      end

      REGEX_TEX_STRING = /Formula\s+(?<texstring>.*)\s+contains the following errors:/.freeze
      def offending_tex_string
        @offending_tex_string ||= REGEX_TEX_STRING.match(stderr)[:texstring].strip if
          stderr.present?
      end

      def document
        @document ||= Nokogiri::HTML html
      end

      def all_spans
        @all_spans ||= document.css 'span'
      end

      def api_errors
        offending_node.blank? ? '' : api_client.errors.unshift('API errors:').join("\n")
      end

      def try_api_client
        raise render_error if offending_node.blank?
        raise render_error unless api_client.success?

        offending_node.content = ''
        offending_node.add_child repaired_content
        renderer_for_repaired_document.render
      end

      def renderer_for_repaired_document
        @renderer_for_repaired_document ||=
          self.class.new html.replace(document.to_html)
      end

      def repaired_span
        @repaired_span = %w[<span class="mathjax-api"></span>].tap do |span|
          span << repaired_content
        end
      end

      def repaired_content
        @repaired_content ||= api_client.send target_format
      end

      def api_client
        @api_client ||= Mathjax::Api::Client.new offending_tex_string
      end

      def offending_node
        @offending_node ||=
          all_spans.detect { |node| offending_tex_appears_in?(node) }
      end

      REGEX_NODE_TEX_CONTENT = /\\\(\s*(?<tex_string>.*)\s*\\\)/m.freeze
      def offending_tex_appears_in?(node)
        node.content.match(REGEX_NODE_TEX_CONTENT).then do |md|
          md.present? && md[:tex_string]&.strip.eql?(offending_tex_string)
        end
      end
    end
  end
end
