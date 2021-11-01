require 'open3'

module EmbeddableContent
  module Tex
    class BaseRenderer
      attr_reader :document, :math_span

      delegate :displaystyle?, :mathjax, :mml, :svg, :tex_string,
               to: :tex_expression

      def initialize(math_span, document)
        @math_span = math_span
        @document  = document
      end

      def render
        rendered_node
      end

      private

      def rendered_node
        @rendered_node ||= math_span.replace replacement
      end

      def replacement
        @replacement ||= base_replacement_span.then { |node| node << math_node }
      end

      def math_node
        @math_node ||= math_content_node
      end

      def math_content_node
        @math_content_node ||= Nokogiri::HTML.fragment(math_content).children.first
      end

      def base_replacement_span
        @base_replacement_span ||= blank_span.then do |span|
          span['class'] = replacement_css_classes if replacement_css_classes.present?
          span
        end
      end

      def blank_span
        Nokogiri::XML::Node.new('span', document)
      end

      def replacement_css_classes
        ''
      end

      def emptied_math_span
        @emptied_math_span ||= math_span.dup.then do |empty_span|
          empty_span.content = ''
          math_span.replace empty_span
        end
      end

      def first_build_math_node
        math_node
      end

      def tex_expression
        @tex_expression ||= TexExpression.for_math_span math_span
      end
    end
  end
end
