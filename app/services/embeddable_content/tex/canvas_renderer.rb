module EmbeddableContent
  module Tex
    class CanvasRenderer < BaseRenderer
      require 'embeddable_content/tex/uri_encode_component'

      def target_format
        :canvas
      end

      #################################################
      # EDC: this is the way Canvas likes things done #
      #################################################
      def math_node
        @math_node ||= Nokogiri::XML::Node.new('img', document).tap do |node|
          node['class']                 = 'equation_image'
          node['title']                 = unadorned_tex_string
          node['src']                   = expression_uri
          node['alt']                   = alt_expression
          node['data-equation-content'] = unadorned_tex_string
        end
      end

      def rendered_node
        @rendered_node ||= emptied_math_span.then { |span| span << math_node }
      end

      def base_replacement_span
        @base_replacement_span ||= blank_span.tap do |span|
          span['class'] = 'math'
        end
      end

      def alt_expression
        @alt_expression ||= "LaTeX: #{unadorned_tex_string}"
      end

      def expression_uri
        @expression_uri ||= "/equation_images/#{doubly_encoded_expression}"
      end

      def doubly_encoded_expression
        @doubly_encoded_expression ||=
          encodeURIComponent encodeURIComponent unadorned_tex_string
      end
    end
  end
end
